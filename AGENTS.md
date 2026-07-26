# AGENTS.md

## Purpose

This file defines mandatory operating rules for humans and AI agents working in this repository.

The repository contains a verified database and route-planning material for three Tuesday second-hand and flea-market routes in southern Sweden:

1. Söderrundan
2. Hallandsrundan
3. Blekingerundan

The primary goal is accuracy, traceability, and practical usefulness. The repository must never present guessed opening hours, addresses, ratings, or route suitability as verified facts.

## Required reading order

Before making changes, read these files in order:

1. `AGENTS.md`
2. `PROJECT_INSTRUCTIONS.md`
3. `DATABASE_SCHEMA.md`
4. `VERIFICATION_GUIDE.md`
5. `CHANGELOG.md`
6. `README.md`

If a later handoff or workflow index is added, follow the reading order stated there.

## Source of truth

The SQLite database in `database/` is the authoritative structured data source.

Generated files in `exports/`, `maps/`, or `reports/` are derived artifacts and must not be edited manually unless explicitly documented.

When database content conflicts with a generated export, the database wins.

## Non-negotiable data rules

- Never invent missing facts.
- Use `NULL`, `unknown`, or an explicit pending status when evidence is insufficient.
- Separate verified facts from assessments and personal preferences.
- Store the source URL and access date for every externally verified fact that can change.
- Prefer official sources over directories, tourism portals, social media, and review sites.
- Do not treat search-result snippets as final verification when the underlying source can be opened.
- Do not mark a shop as Tuesday-open without evidence that applies to the relevant season or date.
- Preserve conflicting source information in notes or verification logs rather than silently choosing one.
- Never delete historical verification evidence merely because a newer value exists.

## Scope rules

Current scope is limited to stores that have a realistic chance of appearing in one of the three planned Tuesday routes.

The project is not currently intended to become a general national flea-market directory.

Sunday-only stores may be recorded for future work, but they must not be mixed into Tuesday route candidates.

## User preference model

Route selection should prioritize:

- large second-hand stores
- warehouse-style stores
- classic flea markets
- mixed and less curated shops with genuine bargain potential
- furniture
- tools
- electronics
- vinyl records and other media
- household goods
- antiques and curiosities

Fashion-only vintage shops have lower default relevance unless they add exceptional route value.

Known reference stores and user favorites should be marked explicitly in the database and must not be used as unexamined proof that similar stores are equally suitable.

## Change workflow

Before editing:

1. Inspect current repository state.
2. Identify the exact files and tables affected.
3. Confirm whether the change is source data, schema, documentation, or generated output.
4. Avoid unrelated changes.

During editing:

- Keep commits focused.
- Use clear commit messages.
- Update `CHANGELOG.md` for meaningful data-model, workflow, or published-dataset changes.
- Update `DATABASE_SCHEMA.md` whenever schema semantics change.
- Update `VERIFICATION_GUIDE.md` whenever verification policy changes.

After editing:

- Run SQLite integrity checks.
- Validate foreign keys.
- Confirm required views still execute.
- Regenerate affected exports.
- Summarize what changed and what remains unverified.

## Database safety

- Never modify the SQLite file with a text editor.
- Prefer migrations or reproducible scripts for structural changes.
- Enable `PRAGMA foreign_keys = ON` during writes.
- Run `PRAGMA integrity_check` after non-trivial updates.
- Back up the database before destructive migrations.
- Do not reuse primary keys for different real-world stores.
- Do not merge two store records without documenting why they represent the same physical business.

## Verification status semantics

Use the documented controlled values consistently.

Examples:

- `verified_open`: current evidence supports Tuesday opening.
- `verify_directly`: direct confirmation is still required.
- `verified_closed`: current evidence shows closed on Tuesday.
- `unknown`: evidence is insufficient or contradictory.

A status is not permanent. It must be revisited when seasons, holidays, ownership, or published opening hours change.

## Ratings

Ratings are analytical fields, not facts.

- Leave rating fields `NULL` until there is a documented basis.
- Distinguish shop-category suitability from route suitability.
- Do not infer high bargain potential solely from Google ratings.
- Store rating rationale and rating date.
- Recalculate total scores when weighting rules change.

## Route generation

Do not optimize route order until the candidate set has acceptable verification coverage.

A route must consider:

- Tuesday opening windows
- seasonal hours
- driving time
- parking
- expected visit duration
- geographical backtracking
- store type diversity
- meal and rest opportunities
- the user's stated preferences

The final route must not include an unverified shop without clearly labeling it as conditional.

## Security and privacy

Do not commit:

- personal access tokens
- API keys
- private phone notes not intended for the project
- credentials
- private user data unrelated to store verification

Use environment variables or local ignored files for secrets.

## Completion standard

A task is complete only when:

- the requested content exists in the repository
- data status is honest and traceable
- affected documentation is synchronized
- validation has been performed where applicable
- remaining uncertainty is explicitly documented
