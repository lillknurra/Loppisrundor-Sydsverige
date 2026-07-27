# Current State

## Projektstatus

Repositoryt innehåller tre publicerade version 1-rundor och en etablerad styrmodell för fortsatt arbete.

| Runda | Route code | Stopp | Selected | Conditional | Koordinatstatus |
|---|---:|---:|---:|---:|---|
| Söderrundan | `SOUTH` | 11 | enligt seed | enligt seed | 10 verifierade, 1 avsiktligt `NULL` |
| Hallandsrundan | `HALLAND` | 11 | 7 | 4 | samtliga avsiktligt `NULL` |
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

- Patch 006 – Navigation & Route Export: **COMPLETE och publicerad**

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

## Patch 006B – publicerat slutläge

Patch 006B är **COMPLETE** och publicerad genom PR #6, `Patch 006B: Hofterup round-trip navigation exports`.

- Feature-commit: `54d07dc689c1d411ba833127abb8abd7db975c98`
- Squash-commit på `main`: `1b986073db68ac3a75de9e5073a81ff4afdcdd81`
- Samtliga rundor använder Hofterup som fast start och mål.
- Hallandsrundan innehåller 11 butiksstopp: 7 `selected` och 4 `conditional`.
- Kattens Loppis & Kuriosa är säsongsberoende och `conditional`; aktuell tisdagstid måste kontrolleras före avresa.
- Automatisk validator, `git diff --check` och manuell kontroll av Google Maps-länkar passerade före publicering.
- Den tidigare feature-branchen är borttagen lokalt och från `origin`.

## Patch 006C – Post-Merge State Reconciliation

Patch 006C är en ren dokumentationssynkronisering efter Patch 006B:s merge. Den rättar status, stoppantal, handoff och patchhistorik så att de motsvarar publicerat läge på `main`.

Patch 006C ändrar inte schema, seeds, ruttdata, scripts eller genererade exporter. Nästa produkt- eller datapatch är ännu inte vald.
