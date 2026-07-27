#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import html
import json
import sqlite3
import subprocess
import tempfile
from pathlib import Path
from typing import TypeAlias
from urllib.parse import urlencode

ROUTES = {
    "SOUTH": ("soderrundan", "Söderrundan"),
    "HALLAND": ("hallandsrundan", "Hallandsrundan"),
    "BLEKINGE": ("blekingerundan", "Blekingerundan"),
}
HOME_LOCATION = "Hofterup, Sverige"
MAX_NAVIGATION_LOCATIONS = 5
Location: TypeAlias = sqlite3.Row | str

CSV_FIELDS = [
    "Namn", "Ursprungligt_namn", "Adress", "Runda", "Stoppordning",
    "Kandidatstatus", "Tisdagsöppettid", "Besökstid_min", "Public_ID",
    "Beskrivning",
]


def build_database(repo: Path, db_path: Path) -> None:
    subprocess.run(
        ["sqlite3", str(db_path)],
        input=(repo / "database/schema.sql").read_text(encoding="utf-8"),
        text=True,
        check=True,
    )
    for seed in sorted((repo / "database/seed").glob("*.sql")):
        subprocess.run(
            ["sqlite3", str(db_path)],
            input=seed.read_text(encoding="utf-8"),
            text=True,
            check=True,
        )


def full_address(row: sqlite3.Row) -> str:
    city_line = " ".join(part for part in (row["postcode"], row["locality"]) if part)
    address = ", ".join(part for part in (row["address"], city_line) if part)
    return f"{address}, Sverige"


def location_address(location: Location) -> str:
    return location if isinstance(location, str) else full_address(location)


def google_maps_url(locations: list[Location]) -> str:
    if len(locations) < 2:
        raise ValueError("A directions link requires at least two locations.")
    addresses = [location_address(location) for location in locations]
    params = {
        "api": "1",
        "origin": addresses[0],
        "destination": addresses[-1],
        "travelmode": "driving",
    }
    if len(addresses) > 2:
        params["waypoints"] = "|".join(addresses[1:-1])
    return "https://www.google.com/maps/dir/?" + urlencode(params, safe="|")


def navigation_chain(stops: list[sqlite3.Row]) -> list[Location]:
    return [HOME_LOCATION, *stops, HOME_LOCATION]


def mobile_segments(locations: list[Location], max_locations: int = MAX_NAVIGATION_LOCATIONS) -> list[list[Location]]:
    segments = []
    start = 0
    while start < len(locations) - 1:
        end = min(start + max_locations, len(locations))
        segment = locations[start:end]
        if len(segment) >= 2:
            segments.append(segment)
        if end == len(locations):
            break
        start = end - 1
    return segments


def location_label(location: Location) -> str:
    if isinstance(location, str):
        return "Hofterup"
    return f"stopp {int(location['stop_order']):02d}"


def segment_label(index: int, segment: list[Location]) -> str:
    return f"Etapp {index}: {location_label(segment[0])}–{location_label(segment[-1])}"


def tuesday_hours(row: sqlite3.Row) -> str:
    if row["tuesday_opens"] and row["tuesday_closes"]:
        return f"{row['tuesday_opens']}–{row['tuesday_closes']}"
    return row["tuesday_status"]


def numbered_name(row: sqlite3.Row) -> str:
    return f"{int(row['stop_order']):02d} – {row['name']}"


def load_routes(conn: sqlite3.Connection) -> dict[str, list[sqlite3.Row]]:
    conn.row_factory = sqlite3.Row
    result = {}
    for route_code in ROUTES:
        rows = conn.execute(
            """
            SELECT * FROM shops
            WHERE route_code = ?
              AND candidate_status <> 'excluded'
              AND stop_order IS NOT NULL
            ORDER BY stop_order, name
            """,
            (route_code,),
        ).fetchall()
        if not rows:
            raise RuntimeError(f"No publishable route stops found for {route_code}.")
        result[route_code] = rows
    return result


def route_notice(route_code: str) -> list[str]:
    notices = [
        "Rundan startar och slutar i Hofterup.",
        "Hofterup är start- och målpunkt men räknas inte som ett butiksstopp.",
        "Stoppordningen är projektets publicerade geografiska arbetsordning och är inte automatiskt tidsoptimerad.",
        "Kontrollera alltid aktuella öppettider före avresa.",
    ]
    if route_code == "HALLAND":
        notices.append("Kattens Loppis & Kuriosa är ett säsongsberoende och villkorat stopp; öppettiden måste verifieras före avresa.")
    return notices


def write_mymaps_csv(out_dir: Path, route_code: str, stops: list[sqlite3.Row]) -> None:
    slug, route_name = ROUTES[route_code]
    path = out_dir / f"{slug}_mymaps.csv"
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=CSV_FIELDS)
        writer.writeheader()
        for row in stops:
            description = [
                f"Runda: {route_name}",
                f"Stoppordning: {row['stop_order']}",
                f"Status: {row['candidate_status']}",
                f"Tisdag: {tuesday_hours(row)}",
                f"Planerad besökstid: {row['visit_minutes']} min",
                "Placering via: verifierad eller redovisad publicerad adress",
                f"Bedömning: {row['assessment']}",
                f"Källa: {row['source_url']}",
                f"Kontrollerad: {row['checked_at']}",
            ]
            if row["notes"]:
                description.append(f"Anteckningar: {row['notes']}")
            writer.writerow({
                "Namn": numbered_name(row),
                "Ursprungligt_namn": row["name"],
                "Adress": full_address(row),
                "Runda": route_name,
                "Stoppordning": row["stop_order"],
                "Kandidatstatus": row["candidate_status"],
                "Tisdagsöppettid": tuesday_hours(row),
                "Besökstid_min": row["visit_minutes"],
                "Public_ID": row["public_id"],
                "Beskrivning": "\n".join(description),
            })


def write_route_markdown(out_dir: Path, route_code: str, stops: list[sqlite3.Row]) -> None:
    slug, route_name = ROUTES[route_code]
    chain = navigation_chain(stops)
    segments = mobile_segments(chain)
    lines = [f"# {route_name}", ""]
    lines.extend(f"> {notice}" for notice in route_notice(route_code))
    lines.extend(["", f"**[Öppna hela rundan i Google Maps]({google_maps_url(chain)})**", "", "## Mobilanpassade deletapper", ""])
    for index, segment in enumerate(segments, start=1):
        lines.append(f"- [{segment_label(index, segment)}]({google_maps_url(segment)})")
    lines.extend(["", "## Stopp", ""])
    for row in stops:
        lines.extend([
            f"### {numbered_name(row)}", "",
            f"- Adress: {full_address(row)}",
            f"- Tisdag: {tuesday_hours(row)}",
            f"- Status: `{row['candidate_status']}`",
            f"- Planerad besökstid: {row['visit_minutes']} minuter", "",
        ])
    (out_dir / f"{slug}.md").write_text("\n".join(lines), encoding="utf-8")


def write_index_html(out_dir: Path, route_data: dict[str, list[sqlite3.Row]]) -> None:
    cards = []
    for route_code, stops in route_data.items():
        _, route_name = ROUTES[route_code]
        chain = navigation_chain(stops)
        segments = mobile_segments(chain)
        segment_buttons = "\n".join(
            f'<a class="secondary" href="{html.escape(google_maps_url(segment))}">{html.escape(segment_label(index, segment))}</a>'
            for index, segment in enumerate(segments, start=1)
        )
        stop_list = "\n".join(
            f"<li><strong>{html.escape(numbered_name(row))}</strong><br>{html.escape(full_address(row))}<br>Tisdag {html.escape(tuesday_hours(row))}<br>Status: {html.escape(row['candidate_status'])}</li>"
            for row in stops
        )
        notices = "".join(f"<p>{html.escape(notice)}</p>" for notice in route_notice(route_code))
        cards.append(f"""
<section class="card">
  <h2>{html.escape(route_name)}</h2>
  <p>{len(stops)} butiksstopp i publicerad geografisk arbetsordning.</p>
  {notices}
  <a class="primary" href="{html.escape(google_maps_url(chain))}">Öppna hela rundan</a>
  <div class="segments"><h3>Mobilanpassade deletapper</h3>{segment_buttons}</div>
  <details><summary>Visa stoppen</summary><ol>{stop_list}</ol></details>
</section>
""")
    document = f"""<!doctype html>
<html lang="sv"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Loppisrundor Sydsverige – navigering</title>
<style>
body {{ font-family: system-ui, sans-serif; margin: 0; background: #f4f4f4; color: #202124; }}
main {{ max-width: 760px; margin: auto; padding: 20px; }}
.card {{ background: white; border-radius: 14px; padding: 20px; margin: 16px 0; box-shadow: 0 2px 10px #0002; }}
a {{ display: block; text-decoration: none; text-align: center; border-radius: 10px; padding: 13px; margin: 8px 0; }}
.primary {{ background: #1769aa; color: white; }}
.secondary {{ background: #e8f0fe; color: #174ea6; }}
li {{ margin: 12px 0; }}
</style></head><body><main>
<h1>Loppisrundor Sydsverige</h1>
<p>Alla rundor startar och slutar i Hofterup. Hofterup räknas inte som ett butiksstopp.</p>
<p>Kontrollera alltid aktuella öppettider före avresa.</p>
{''.join(cards)}
</main></body></html>
"""
    (out_dir / "index.html").write_text(document, encoding="utf-8")


def write_manifest(out_dir: Path, route_data: dict[str, list[sqlite3.Row]]) -> None:
    manifest = {
        "generator": "scripts/export_navigation.py",
        "source": "database/schema.sql + database/seed/*.sql",
        "google_maps_api_key_required": False,
        "route_origin": HOME_LOCATION,
        "route_destination": HOME_LOCATION,
        "route_order_semantics": "published_geographic_work_order_not_time_optimized",
        "routes": [],
    }
    for route_code, stops in route_data.items():
        slug, route_name = ROUTES[route_code]
        chain = navigation_chain(stops)
        manifest["routes"].append({
            "route_code": route_code,
            "slug": slug,
            "name": route_name,
            "stops": len(stops),
            "full_url_length": len(google_maps_url(chain)),
            "mobile_segments": len(mobile_segments(chain)),
        })
    (out_dir / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def generate(repo: Path, output_root: Path) -> None:
    mymaps_dir = output_root / "mymaps"
    routes_dir = output_root / "routes"
    mymaps_dir.mkdir(parents=True, exist_ok=True)
    routes_dir.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="loppisrundor-") as temp:
        db_path = Path(temp) / "routes.sqlite"
        build_database(repo, db_path)
        with sqlite3.connect(db_path) as conn:
            route_data = load_routes(conn)
            for route_code, stops in route_data.items():
                write_mymaps_csv(mymaps_dir, route_code, stops)
                write_route_markdown(routes_dir, route_code, stops)
            write_index_html(routes_dir, route_data)
            write_manifest(routes_dir, route_data)
    (mymaps_dir / "README.md").write_text(
        "# Google My Maps-export\n\nImportera en CSV per lager. Välj `Adress` som platskolumn och `Namn` som rubrikkolumn. Namnet börjar med tvåsiffrig stoppordning.\n\nHofterup är start- och målpunkt för navigeringslänkarna men ingår inte som CSV-rad eller butiksstopp.\n",
        encoding="utf-8",
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--output-root", type=Path, default=None)
    args = parser.parse_args()
    repo = args.repo.resolve()
    output_root = args.output_root.resolve() if args.output_root else (repo / "exports").resolve()
    generate(repo, output_root)
    print(f"PASS: navigation exports generated in {output_root}")


if __name__ == "__main__":
    main()
