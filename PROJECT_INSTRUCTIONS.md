# PROJECT_INSTRUCTIONS.md

## Project

- Name: `Loppisrundor-Sydsverige`
- Repository: `lillknurra/Loppisrundor-Sydsverige`
- Stable branch: `main`
- Primary database format: SQLite
- Primary language for user-facing material: Swedish

## Objective

Build and maintain a verified, traceable database for three practical Tuesday second-hand and flea-market routes in southern Sweden:

1. Söderrundan
2. Hallandsrundan
3. Blekingerundan

The database must support route selection, source verification, opening-hour validation, scoring, mapping, and reproducible exports.

## Initial geographic scope

### Söderrundan

Lund, Staffanstorp, Malmö, Burlöv/Åkarp, Svedala, Vellinge, Trelleborg, Skurup, and Ystad.

### Hallandsrundan

Höganäs, Ängelholm, Vejbystrand, Båstad, Förslöv, Laholm, Våxtorp, and Halmstad.

### Blekingerundan

Kristianstad, Bromölla, Sölvesborg, Mörrum, Asarum, and Karlshamn.

## Primary use case

The user wants car-based Tuesday routes with approximately 8–12 worthwhile stops per route. The database is built before final route optimization.

The preferred store profile is broad, practical, and bargain-oriented rather than fashion-led:

- large charity second-hand stores
- warehouse stores
- permanent flea markets
- mixed stock
- furniture
- tools
- electronics
- vinyl and media
- household goods
- antiques and curiosities

## Authoritative documents

- `AGENTS.md`: permanent operating rules for humans and agents
- `PROJECT_INSTRUCTIONS.md`: project scope, constraints, and completion rules
- `DATABASE_SCHEMA.md`: schema semantics and data contracts
- `VERIFICATION_GUIDE.md`: evidence and source-verification policy
- `docs/handoff/MASTER_INDEX.md`: mandatory reading order and navigation
- `docs/handoff/CURRENT_STATE.md`: exact current repository state
- `docs/handoff/HANDOFF.md`: continuation context
- `docs/history/PATCH_HISTORY.md`: durable patch history
- `CHANGELOG.md`: user-visible released changes

Do not duplicate detailed ownership across multiple documents. Link to the authoritative document instead.

## Patch workflow

Work is performed in bounded patches.

Each patch must define:

- purpose
- exact scope
- baseline
- affected files and data
- validation
- evidence boundaries
- non-goals
- rollback
- completion criteria

The initial roadmap is:

- Patch 001 – Repository Foundation
- Patch 002 – Database Foundation
- Patch 003 – Verification Framework
- Patch 004 – Initial Dataset
- Patch 005 – Route Engine
- Patch 006 – Maps and Mobile Exports

Later patch numbering must remain sequential and must not be selected implicitly by a patch that is still active.

## Data quality constraints

- Unknown facts remain unknown.
- Current facts require current sources.
- Every externally verified mutable fact must have a source and access date.
- Opening hours must preserve ordinary, seasonal, temporary, holiday, and appointment-only distinctions.
- A directory listing alone is not sufficient for the strongest verification class.
- Ratings must include rationale and date.
- Generated route order must not be treated as manually verified travel time unless the routing source is recorded.

## Local repository layout

Target layout:

```text
.
├── AGENTS.md
├── PROJECT_INSTRUCTIONS.md
├── README.md
├── CHANGELOG.md
├── DATABASE_SCHEMA.md
├── VERIFICATION_GUIDE.md
├── database/
│   ├── schema.sql
│   ├── migrations/
│   ├── seed/
│   └── sqlite/
├── docs/
│   ├── development/
│   ├── handoff/
│   └── history/
├── exports/
│   ├── csv/
│   ├── excel/
│   ├── geojson/
│   └── kml/
├── maps/
└── scripts/
```

Empty directories should be added only when they receive a tracked placeholder or real content.

## Database rules

- Use SQLite foreign keys.
- Schema changes require migrations.
- Do not edit generated database files manually.
- Keep a canonical `schema.sql` synchronized with migrations.
- Use stable identifiers for stores and routes.
- Preserve historical verification records.
- Prefer normalized tables for repeatable facts and relationships.
- Derived scores and exports must be reproducible from stored inputs.

## Evidence classes

Keep these classes distinct:

- documentation evidence
- schema evidence
- migration evidence
- data-integrity evidence
- source-verification evidence
- export evidence
- route-calculation evidence
- operator-observed evidence

A successful SQL query does not prove that source data is current. A current source does not prove route suitability. A route calculation does not prove the shop will actually be open on the travel date.

## Validation baseline

Applicable changes should validate at least:

- required files exist
- SQLite schema parses
- `PRAGMA foreign_key_check` returns no rows
- `PRAGMA integrity_check` returns `ok`
- migrations apply in order to a clean database
- migrations do not silently destroy data
- required views execute
- controlled values remain valid
- generated exports match the database snapshot
- Markdown links and references are not stale where practical
- `git diff --check` passes

## Publication and Git

- Keep patches narrow.
- Review exact scope before commit.
- Do not stage unrelated files.
- Do not rewrite published history.
- Record meaningful changes in patch history and changelog.
- Generated binary database files may be versioned only when the patch explicitly includes a published dataset snapshot.

## Security and privacy

Do not commit credentials, tokens, private API keys, or unrelated personal information.

Public business contact information may be stored when it supports the project, but private call notes must be limited to relevant verification facts.

## Definition of done

A patch is complete when:

- exact scope is implemented
- governing documentation is synchronized
- applicable validation passes
- evidence strength is stated honestly
- remaining uncertainty is documented
- rollback is understood
- current-state and handoff files reflect the resulting repository state

## Operator communication

When user action is needed, provide:

- complete copy/paste instructions
- expected result
- explicit PASS/FAIL criteria
- exact evidence to return

Every substantial work step should end with a complete continuation block under `## Nästa prompt` when the user is expected to continue in a new chat.
