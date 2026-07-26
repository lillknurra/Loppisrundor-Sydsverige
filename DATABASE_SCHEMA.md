# DATABASE_SCHEMA.md

## Purpose

This document defines the canonical logical data model for `Loppisrundor-Sydsverige`.

The SQLite schema in `database/schema.sql` will be the executable source of truth. This document explains intent, semantics, relationships, controlled values, and migration rules.

## Design principles

- Preserve source traceability.
- Separate current facts from historical verification events.
- Separate facts from subjective ratings.
- Represent uncertainty explicitly.
- Support seasonal opening hours.
- Support reproducible exports and route generation.
- Avoid duplicating chain, category, feature, and locality data.
- Keep historical evidence even when current values change.

## Identifier policy

Internal primary keys use integer identifiers unless a later migration introduces stable UUIDs.

External exports should use stable public identifiers derived from immutable database identifiers, not row position.

Primary keys must never be reused for another real-world entity.

## Core entities

### `routes`

Represents one of the project's defined route regions.

Planned columns:

- `route_id` INTEGER PRIMARY KEY
- `code` TEXT UNIQUE NOT NULL
- `name` TEXT NOT NULL
- `description` TEXT
- `active` INTEGER NOT NULL DEFAULT 1
- `created_at` TEXT NOT NULL
- `updated_at` TEXT NOT NULL

Initial controlled route codes:

- `SOUTH`
- `HALLAND`
- `BLEKINGE`

### `chains`

Represents an organization or chain with multiple shops.

Planned columns:

- `chain_id` INTEGER PRIMARY KEY
- `name` TEXT UNIQUE NOT NULL
- `website_url` TEXT
- `notes` TEXT

Independent shops have `NULL` chain references.

### `shops`

Represents one physical shop or permanent flea-market location.

Planned columns:

- `shop_id` INTEGER PRIMARY KEY
- `public_id` TEXT UNIQUE NOT NULL
- `name` TEXT NOT NULL
- `chain_id` INTEGER REFERENCES `chains`
- `route_id` INTEGER REFERENCES `routes`
- `shop_type` TEXT NOT NULL
- `status` TEXT NOT NULL
- `tuesday_status` TEXT NOT NULL
- `verification_level` TEXT NOT NULL
- `user_favorite` INTEGER NOT NULL DEFAULT 0
- `route_relevance` INTEGER
- `address_line1` TEXT
- `address_line2` TEXT
- `postcode` TEXT
- `locality` TEXT
- `municipality` TEXT
- `county` TEXT
- `country_code` TEXT NOT NULL DEFAULT 'SE'
- `latitude` REAL
- `longitude` REAL
- `phone` TEXT
- `email` TEXT
- `website_url` TEXT
- `facebook_url` TEXT
- `instagram_url` TEXT
- `notes` TEXT
- `created_at` TEXT NOT NULL
- `updated_at` TEXT NOT NULL

Required constraints:

- latitude between -90 and 90 when present
- longitude between -180 and 180 when present
- booleans restricted to 0 or 1
- route relevance restricted to the documented scale when present

### `opening_hours`

Represents recurring ordinary opening hours.

Planned columns:

- `opening_hours_id` INTEGER PRIMARY KEY
- `shop_id` INTEGER NOT NULL REFERENCES `shops` ON DELETE CASCADE
- `weekday` INTEGER NOT NULL
- `opens_at` TEXT
- `closes_at` TEXT
- `closed` INTEGER NOT NULL DEFAULT 0
- `appointment_only` INTEGER NOT NULL DEFAULT 0
- `valid_from` TEXT
- `valid_to` TEXT
- `source_id` INTEGER REFERENCES `sources`
- `verified_at` TEXT
- `notes` TEXT

Weekday mapping:

- 1 Monday
- 2 Tuesday
- 3 Wednesday
- 4 Thursday
- 5 Friday
- 6 Saturday
- 7 Sunday

A shop may have multiple intervals per weekday.

### `opening_exceptions`

Represents holiday, temporary, event-specific, or one-off opening changes.

Planned columns:

- `exception_id` INTEGER PRIMARY KEY
- `shop_id` INTEGER NOT NULL REFERENCES `shops` ON DELETE CASCADE
- `date` TEXT NOT NULL
- `opens_at` TEXT
- `closes_at` TEXT
- `closed` INTEGER NOT NULL DEFAULT 0
- `reason` TEXT
- `source_id` INTEGER REFERENCES `sources`
- `verified_at` TEXT

### `sources`

Represents one source used to support facts.

Planned columns:

- `source_id` INTEGER PRIMARY KEY
- `shop_id` INTEGER REFERENCES `shops` ON DELETE CASCADE
- `source_type` TEXT NOT NULL
- `title` TEXT
- `url` TEXT
- `publisher` TEXT
- `accessed_at` TEXT NOT NULL
- `published_at` TEXT
- `official` INTEGER NOT NULL DEFAULT 0
- `archived_url` TEXT
- `notes` TEXT

A source record may support several facts through verification events.

### `verification_events`

Represents a dated verification action and its result.

Planned columns:

- `verification_event_id` INTEGER PRIMARY KEY
- `shop_id` INTEGER NOT NULL REFERENCES `shops` ON DELETE CASCADE
- `source_id` INTEGER REFERENCES `sources`
- `verification_type` TEXT NOT NULL
- `result` TEXT NOT NULL
- `checked_at` TEXT NOT NULL
- `checked_by` TEXT
- `evidence_summary` TEXT NOT NULL
- `next_action` TEXT
- `valid_until` TEXT
- `notes` TEXT

Examples of `verification_type`:

- `identity`
- `address`
- `contact`
- `ordinary_hours`
- `tuesday_hours`
- `seasonal_hours`
- `temporary_closure`
- `shop_type`
- `route_relevance`
- `phone_confirmation`

### `categories`

Represents inventory categories.

Planned columns:

- `category_id` INTEGER PRIMARY KEY
- `code` TEXT UNIQUE NOT NULL
- `name` TEXT UNIQUE NOT NULL
- `description` TEXT

Initial category examples:

- furniture
- tools
- electronics
- vinyl
- books
- clothing
- household
- antiques
- toys
- building_materials

### `shop_categories`

Many-to-many relationship between shops and inventory categories.

Planned columns:

- `shop_id` INTEGER NOT NULL REFERENCES `shops` ON DELETE CASCADE
- `category_id` INTEGER NOT NULL REFERENCES `categories` ON DELETE CASCADE
- `confidence` TEXT NOT NULL
- `source_id` INTEGER REFERENCES `sources`
- `verified_at` TEXT
- `notes` TEXT
- PRIMARY KEY (`shop_id`, `category_id`)

### `features`

Represents facilities or operational features.

Examples:

- parking
- accessible_entrance
- accessible_toilet
- cafe
- card_payment
- cash_payment
- outdoor_area
- loading_area
- large_store
- warehouse_style

### `shop_features`

Many-to-many relationship between shops and features.

Planned columns:

- `shop_id` INTEGER NOT NULL REFERENCES `shops` ON DELETE CASCADE
- `feature_id` INTEGER NOT NULL REFERENCES `features` ON DELETE CASCADE
- `value` TEXT
- `source_id` INTEGER REFERENCES `sources`
- `verified_at` TEXT
- `notes` TEXT
- PRIMARY KEY (`shop_id`, `feature_id`)

### `ratings`

Stores dated analytical assessments.

Planned columns:

- `rating_id` INTEGER PRIMARY KEY
- `shop_id` INTEGER NOT NULL REFERENCES `shops` ON DELETE CASCADE
- `rated_at` TEXT NOT NULL
- `rated_by` TEXT
- `furniture_score` INTEGER
- `electronics_score` INTEGER
- `tools_score` INTEGER
- `vinyl_score` INTEGER
- `mixed_inventory_score` INTEGER
- `bargain_potential_score` INTEGER
- `turnover_score` INTEGER
- `parking_score` INTEGER
- `route_value_score` INTEGER
- `total_score` REAL
- `rating_model_version` TEXT NOT NULL
- `rationale` TEXT NOT NULL

Scores remain `NULL` until assessed.

### `route_versions`

Represents one generated or manually curated version of a route.

Planned columns:

- `route_version_id` INTEGER PRIMARY KEY
- `route_id` INTEGER NOT NULL REFERENCES `routes`
- `name` TEXT NOT NULL
- `travel_date` TEXT
- `generated_at` TEXT NOT NULL
- `generator_version` TEXT
- `status` TEXT NOT NULL
- `notes` TEXT

### `route_stops`

Represents ordered stops in a route version.

Planned columns:

- `route_stop_id` INTEGER PRIMARY KEY
- `route_version_id` INTEGER NOT NULL REFERENCES `route_versions` ON DELETE CASCADE
- `shop_id` INTEGER NOT NULL REFERENCES `shops`
- `stop_order` INTEGER NOT NULL
- `planned_arrival` TEXT
- `planned_departure` TEXT
- `visit_minutes` INTEGER
- `conditional` INTEGER NOT NULL DEFAULT 0
- `reason` TEXT
- UNIQUE (`route_version_id`, `stop_order`)
- UNIQUE (`route_version_id`, `shop_id`)

## Controlled values

### Shop status

- `active`
- `temporarily_closed`
- `permanently_closed`
- `seasonal`
- `unknown`

### Tuesday status

- `verified_open`
- `verify_directly`
- `verified_closed`
- `seasonal`
- `appointment_only`
- `unknown`

### Verification level

- `official_current`
- `direct_current`
- `multi_source_current`
- `secondary_current`
- `stale`
- `conflicting`
- `unverified`

### Source type

- `official_website`
- `official_social_media`
- `direct_phone`
- `direct_email`
- `tourism_portal`
- `municipal_portal`
- `directory`
- `map_listing`
- `review_site`
- `news_article`
- `operator_observation`
- `other`

## Views

The schema should provide at least:

### `v_tuesday_candidates`

Active shops eligible for Tuesday-route consideration with route, locality, Tuesday status, verification level, and latest verification date.

### `v_needs_verification`

Shops requiring action because they are unverified, stale, conflicting, seasonal without current evidence, or marked `verify_directly`.

### `v_shop_summary`

One row per shop with route, address, current status, Tuesday status, category summary, feature summary, latest rating, and latest verification date.

### `v_source_freshness`

Shows latest mutable-fact verification dates and flags stale records.

## Indexes

Expected indexes include:

- shop name
- locality
- municipality
- route and Tuesday status
- verification events by shop and date
- sources by shop and access date
- opening hours by shop and weekday
- route stops by route version and order
- geospatial latitude/longitude lookup support where practical

## Timestamps and dates

- Store dates as ISO 8601 text.
- Use `YYYY-MM-DD` for dates.
- Use `HH:MM` for local opening times.
- Use timezone-aware ISO 8601 timestamps for events where practical.
- Swedish local context uses `Europe/Stockholm` unless explicitly documented otherwise.

## Migration policy

Every structural change requires a numbered migration in `database/migrations/`.

Naming convention:

```text
0001_initial_schema.sql
0002_add_opening_exceptions.sql
```

A migration must:

- state its purpose
- apply cleanly to the prior schema version
- preserve existing data unless explicitly approved otherwise
- update schema metadata
- include rollback guidance
- be validated on a clean database and a representative populated database

The canonical `database/schema.sql` must describe the latest complete schema after all migrations.

## Schema metadata

The executable schema should include a metadata table with at least:

- schema version
- dataset version
- created timestamp
- last migration timestamp
- generator version when applicable

## Integrity requirements

The following must pass after applicable changes:

```sql
PRAGMA foreign_keys = ON;
PRAGMA integrity_check;
PRAGMA foreign_key_check;
```

`integrity_check` must return `ok` and `foreign_key_check` must return no rows.

## Current state

This document defines the intended foundation. The executable schema and migrations are created in Patch 002 – Database Foundation.
