#!/bin/bash

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/loppis-patch006.XXXXXXXXXX")"

cleanup() {
  rm -rf "$TMP_ROOT"
}
trap cleanup EXIT HUP INT TERM

cd "$REPO_ROOT" || exit 1

python3 scripts/export_navigation.py --output-root "$TMP_ROOT/generated" || exit 1

python3 - "$REPO_ROOT" "$TMP_ROOT/generated" <<'PYVALIDATE'
from __future__ import annotations

import csv
import html
import json
import re
import sqlite3
import subprocess
import sys
from pathlib import Path
from urllib.parse import parse_qs, urlparse

repo = Path(sys.argv[1])
generated = Path(sys.argv[2])
home = "Hofterup, Sverige"
expected = {
    "SOUTH": ("soderrundan", 11),
    "HALLAND": ("hallandsrundan", 11),
    "BLEKINGE": ("blekingerundan", 11),
}


def fail(message: str) -> None:
    raise SystemExit(f"FAIL: {message}")


def read_csv(slug: str) -> list[dict[str, str]]:
    with (generated / "mymaps" / f"{slug}_mymaps.csv").open(encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def parse_maps_url(url: str) -> dict[str, list[str]]:
    parsed = urlparse(html.unescape(url))
    if parsed.scheme != "https" or parsed.netloc != "www.google.com" or parsed.path != "/maps/dir/":
        fail(f"Unexpected Google Maps URL: {url}")
    return parse_qs(parsed.query, keep_blank_values=True)


def location_chain(query: dict[str, list[str]]) -> list[str]:
    origin = query.get("origin", [None])[0]
    destination = query.get("destination", [None])[0]
    if not origin or not destination:
        fail("Directions URL lacks origin or destination.")
    waypoints = query.get("waypoints", [""])[0]
    middle = waypoints.split("|") if waypoints else []
    return [origin, *middle, destination]


csv_rows = {}
for route_code, (slug, expected_count) in expected.items():
    rows = read_csv(slug)
    csv_rows[route_code] = rows
    if len(rows) != expected_count:
        fail(f"{route_code} has {len(rows)} rows; expected {expected_count}.")
    orders = [int(row["Stoppordning"]) for row in rows]
    if orders != list(range(1, expected_count + 1)):
        fail(f"{route_code} stop_order is not contiguous: {orders}")
    if any("Hofterup" in row["Namn"] or "Hofterup" in row["Adress"] for row in rows):
        fail(f"Hofterup appears as a CSV shop row in {route_code}.")

kattens = [row for row in csv_rows["HALLAND"] if row["Public_ID"] == "halland-kattens-loppis-vaxtorp"]
if len(kattens) != 1:
    fail("Kattens Loppis must occur exactly once in Hallandsrundan.")
if kattens[0]["Adress"] != "Kristianstadsvägen 6, 312 75 Våxtorp, Sverige":
    fail(f"Unexpected Kattens address: {kattens[0]['Adress']}")
if kattens[0]["Kandidatstatus"] != "conditional":
    fail("Kattens Loppis must remain conditional.")

manifest = json.loads((generated / "routes" / "manifest.json").read_text(encoding="utf-8"))
if manifest.get("route_origin") != home or manifest.get("route_destination") != home:
    fail("Manifest origin or destination is incorrect.")
if manifest.get("google_maps_api_key_required") is not False:
    fail("Manifest must state that no API key is required.")
if len(manifest.get("routes", [])) != 3:
    fail("Manifest must contain exactly three routes.")
by_code = {route["route_code"]: route for route in manifest["routes"]}

link_pattern = re.compile(r"\[[^\]]+\]\((https://www\.google\.com/maps/dir/\?[^)]+)\)")

for route_code, (slug, _) in expected.items():
    rows = csv_rows[route_code]
    addresses = [row["Adress"] for row in rows]
    route_manifest = by_code[route_code]
    if route_manifest["stops"] != len(rows):
        fail(f"Manifest stop count differs for {route_code}.")
    if route_manifest["full_url_length"] > 2048:
        fail(f"Full URL exceeds 2048 characters for {route_code}.")
    urls = link_pattern.findall((generated / "routes" / f"{slug}.md").read_text(encoding="utf-8"))
    if not urls:
        fail(f"No route links found for {route_code}.")
    full_url = urls[0]
    full_query = parse_maps_url(full_url)
    if full_query.get("api") != ["1"] or full_query.get("travelmode") != ["driving"]:
        fail(f"Full route parameters are incorrect for {route_code}.")
    expected_chain = [home, *addresses, home]
    if location_chain(full_query) != expected_chain:
        fail(f"Full route chain differs from CSV order for {route_code}.")
    if len(full_url) != route_manifest["full_url_length"]:
        fail(f"Manifest URL length differs for {route_code}.")
    segment_urls = urls[1:]
    if len(segment_urls) != route_manifest["mobile_segments"]:
        fail(f"Manifest segment count differs for {route_code}.")
    chains = []
    for segment_url in segment_urls:
        if len(segment_url) > 2048:
            fail(f"Mobile URL exceeds 2048 characters for {route_code}.")
        query = parse_maps_url(segment_url)
        chain = location_chain(query)
        if len(chain) > 5:
            fail(f"Segment has more than five locations for {route_code}.")
        chains.append(chain)
    if chains[0][0] != home or chains[-1][-1] != home:
        fail(f"Mobile chain start or end is incorrect for {route_code}.")
    rebuilt = list(chains[0])
    for previous, current in zip(chains, chains[1:]):
        if previous[-1] != current[0]:
            fail(f"Segment continuity fails for {route_code}.")
        rebuilt.extend(current[1:])
    if rebuilt != expected_chain:
        fail(f"Combined mobile chain differs for {route_code}.")
    if rebuilt.count(home) != 2:
        fail(f"Hofterup occurs unexpectedly inside the chain for {route_code}.")

db_path = generated / "validation.sqlite"
subprocess.run(["sqlite3", str(db_path)], input=(repo / "database/schema.sql").read_text(encoding="utf-8"), text=True, check=True)
seeds = sorted((repo / "database/seed").glob("*.sql"))
for _ in range(2):
    for seed in seeds:
        subprocess.run(["sqlite3", str(db_path)], input=seed.read_text(encoding="utf-8"), text=True, check=True)
with sqlite3.connect(db_path) as conn:
    if conn.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
        fail("PRAGMA integrity_check did not return ok.")
    if conn.execute("PRAGMA foreign_key_check").fetchall():
        fail("PRAGMA foreign_key_check returned rows.")

secret_patterns = [
    re.compile(r"AIza[0-9A-Za-z_-]{20,}"),
    re.compile(r"(?i)(?:google[_-]?maps|maps)[_-]?api[_-]?key\s*[:=]\s*['\"][^'\"]+['\"]"),
]
for path in [repo / "scripts/export_navigation.py", repo / "database/seed/002_hallandsrundan.sql", *generated.rglob("*")]:
    if not path.is_file():
        continue
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        continue
    for pattern in secret_patterns:
        if pattern.search(content):
            fail(f"Possible Google API key found in {path}")

print("PASS: Patch 006 content validation")
PYVALIDATE

if [ $? -ne 0 ]; then
  exit 1
fi

git diff --check || exit 1

echo "PASS: Patch 006 validation complete"
