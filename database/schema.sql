PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS routes (
    route_code TEXT PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS shops (
    shop_id INTEGER PRIMARY KEY AUTOINCREMENT,
    public_id TEXT NOT NULL UNIQUE,
    route_code TEXT NOT NULL REFERENCES routes(route_code),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    postcode TEXT,
    locality TEXT NOT NULL,
    latitude REAL CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
    longitude REAL CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180),
    tuesday_opens TEXT,
    tuesday_closes TEXT,
    tuesday_status TEXT NOT NULL CHECK (
        tuesday_status IN ('verified_open', 'verify_directly', 'verified_closed', 'unknown')
    ),
    source_url TEXT NOT NULL,
    source_type TEXT NOT NULL CHECK (
        source_type IN ('official_website', 'official_social_media', 'direct_contact', 'secondary_source')
    ),
    checked_at TEXT NOT NULL,
    assessment TEXT NOT NULL,
    candidate_status TEXT NOT NULL DEFAULT 'candidate' CHECK (
        candidate_status IN ('selected', 'candidate', 'conditional', 'excluded')
    ),
    stop_order INTEGER,
    visit_minutes INTEGER CHECK (visit_minutes IS NULL OR visit_minutes > 0),
    notes TEXT,
    CHECK (
        (tuesday_status = 'verified_open' AND tuesday_opens IS NOT NULL AND tuesday_closes IS NOT NULL)
        OR tuesday_status <> 'verified_open'
    )
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_shops_route_stop_order
ON shops(route_code, stop_order)
WHERE stop_order IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_shops_route_candidate
ON shops(route_code, candidate_status, tuesday_status);

CREATE VIEW IF NOT EXISTS v_route_candidates AS
SELECT
    route_code,
    public_id,
    name,
    address,
    postcode,
    locality,
    tuesday_opens,
    tuesday_closes,
    tuesday_status,
    candidate_status,
    stop_order,
    visit_minutes,
    assessment,
    source_url,
    checked_at
FROM shops
WHERE candidate_status <> 'excluded'
ORDER BY route_code, COALESCE(stop_order, 999), name;

CREATE VIEW IF NOT EXISTS v_needs_verification AS
SELECT *
FROM shops
WHERE tuesday_status <> 'verified_open'
   OR latitude IS NULL
   OR longitude IS NULL
ORDER BY route_code, name;
