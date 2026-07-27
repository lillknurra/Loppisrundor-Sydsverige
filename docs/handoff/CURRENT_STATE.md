# Current State

## Projektstatus

Repositoryt innehåller tre publicerade version 1-rundor och en etablerad styrmodell för fortsatt arbete.

| Runda | Route code | Stopp | Selected | Conditional | Koordinatstatus |
|---|---:|---:|---:|---:|---|
| Söderrundan | `SOUTH` | 11 | enligt seed | enligt seed | 10 verifierade, 1 avsiktligt `NULL` |
| Hallandsrundan | `HALLAND` | 10 | 7 | 3 | samtliga avsiktligt `NULL` |
| Blekingerundan | `BLEKINGE` | 11 | 8 | 3 | samtliga avsiktligt `NULL` |

Exakta statusantal för Söderrundan ska vid behov hämtas direkt ur databasen; detta dokument duplicerar inte värden som inte behövdes för Patch 004.

## Normativa filer

- Schema: `database/schema.sql`
- Seeds:
  - `database/seed/001_soderrundan.sql`
  - `database/seed/002_hallandsrundan.sql`
  - `database/seed/003_blekingerundan.sql`
- Verifieringsregler: `VERIFICATION_GUIDE.md`
- Officiell läsordning: `docs/handoff/MASTER_INDEX.md`

- Tuesday Planning:
  - `docs/tuesday/README.md`
  - `docs/tuesday/TUESDAY_ROUND_PREVIEW.md`
## Publicerade exporter

Varje publicerad runda har motsvarande CSV- och GeoJSON-export under:

- `exports/csv/`
- `exports/geojson/`

Exporter är härledda. Seed-data är normativ vid avvikelse.

## Senast verifierade ingångsbaslinje för governance-arbetet

- Branch: `main`
- Commit före Patch 004: `a69103e146022cc7fbcfe8ae08ec74f6f35602ff`
- Senaste mergade PR före Patch 004: PR #3, **Add Blekingerundan version 1**
- PR #3 byggde på commit `7ee55f62e8cc7ca39dbe39de9e7df6a2dbff8599` och squash-mergades till ovanstående `main`-commit.

Aktuell commit efter att dokumentet har publicerats ska alltid verifieras med Git och behöver inte skrivas tillbaka genom en separat patch.

## Patchstatus

- Patch 001 – Söderrundan version 1: **COMPLETE**
- Patch 002 – Hallandsrundan version 1: **COMPLETE**
- Patch 003 – Blekingerundan version 1: **COMPLETE**
- Patch 004 – Repository Governance Foundation: **COMPLETE när dessa sex styrdokument är verifierade och finns på `main`**
- Patch 005 – Tuesday Round Preview v1: **COMPLETE**

- Patch 006 – Navigation & Route Export: **COMPLETE lokalt; automatisk och manuell verifiering PASS, ännu ej committad eller publicerad**

## Navigeringsexporter

- My Maps: `exports/mymaps/`
- Google Maps och mobil startsida: `exports/routes/`
- Generator: `scripts/export_navigation.py`
- Validering: `scripts/validate_patch_006.sh`

Navigeringslänkar följer publicerad stoppordning men utgör inte en tidsoptimerad eller verifierad körplan.

## Kända beständiga begränsningar

- Öppettider är tidskänsliga och gäller endast utifrån respektive `checked_at`.
- Hallandsrundan och Blekingerundan är adressbaserade versioner utan verifierade koordinater.
- Söderrundan har ett stopp med avsiktligt saknade koordinater.
- Vissa stopp har delade öppettider eller lunchstängt, modellerat som ytterintervall med förklarande notering.
- Stoppordning kan vara geografisk arbetsordning snarare än fullständigt tidsoptimerad körplan.

## Styrande principer

- Inga fakta gissas.
- `NULL` är ett giltigt och avsiktligt tillstånd.
- Officiella källor prioriteras.
- Seeds ska kunna köras två gånger utan dubbletter.
- Databas och exporter ska valideras tillsammans.
- Lokal verifiering föregår publicering.

## Patch 006B – aktuellt lokalt tillstånd

Patch 006B är implementerad och verifierad på den lokala branchen `patch-006-navigation-route-export` men är ännu inte committad eller publicerad. Automatisk validering, `git diff --check` och manuell kontroll av de genererade Google Maps-länkarna har passerat.

Samtliga rundor använder Hofterup som fast start och mål. Hallandsrundan innehåller elva butiksstopp och inkluderar Kattens Loppis & Kuriosa som säsongsberoende `conditional`-stopp.
