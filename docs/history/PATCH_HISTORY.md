# Patch History

Detta dokument sammanfattar repositoryts beständiga patchhistorik. Datasetdetaljer finns även i `CHANGELOG.md`; Git och GitHub är källa för exakta commits, diffar och PR-händelser.

## Patch 001 – Söderrundan version 1

**Status:** COMPLETE
**Publicering:** Ursprunglig projektbaslinje och senare dokumenterad som Söderrundan version 1.

### Resultat

- Etablerade SQLite-schema för `routes` och `shops`.
- Publicerade Söderrundan med 11 verifierade tisdagstopp i Lund, Malmö, Trelleborg och Ystad.
- Publicerade CSV- och GeoJSON-exporter.
- Verifierade koordinater för 10 stopp.
- Lämnade Erikshjälpen Second Hand Trelleborgs koordinater som `NULL` i stället för att gissa.

### Beständiga beslut

- Seed-data är normativ.
- Adressbaserad publicering får ske när koordinater saknas men kärnuppgifterna är verifierade.
- GeoJSON använder `geometry: null` för stopp utan verifierade koordinater.

## Patch 002 – Hallandsrundan version 1

**Status:** COMPLETE
**PR:** #1 – `Complete Hallandsrundan version 1`
**Efterföljande korrigering:** PR #2 – `Make Söderrundan seed safely rerunnable`

### Resultat

- Publicerade Hallandsrundan med 10 stopp: 7 `selected` och 3 `conditional`.
- Omfattade Ängelholm, Laholm, Halmstad och Höganäs.
- Publicerade CSV- och GeoJSON-exporter.
- Lämnade samtliga koordinater `NULL` eftersom versionen är adressbaserad.
- Dokumenterade Kretsloppans lunchstängning inom publicerat ytterintervall.
- Gjorde Hallandsseedens butiksinlägg återkörningsbara.

### Korrigering i PR #2

Söderrundans shop-inlägg ändrades från `INSERT INTO` till `INSERT OR IGNORE INTO` så att samtliga seeds kan köras två gånger i samma testdatabas. Ingen datasetuppgift ändrades.

### Beständiga beslut

- Alla seeds ska vara säkert återkörningsbara.
- Dubbel seed-körning ingår i standardvalideringen.
- Postnummer och koordinater får förbli `NULL` när den använda källan inte styrker dem.

## Patch 003 – Blekingerundan version 1

**Status:** COMPLETE
**PR:** #3 – `Add Blekingerundan version 1`
**Feature commit:** `7ee55f62e8cc7ca39dbe39de9e7df6a2dbff8599`
**Stabil main efter squash merge:** `a69103e146022cc7fbcfe8ae08ec74f6f35602ff`

### Resultat

- Publicerade Blekingerundan med 11 stopp: 8 `selected` och 3 `conditional`.
- Omfattade Bromölla, Kristianstad, Sölvesborg, Asarum och Karlshamn.
- Publicerade CSV- och GeoJSON-exporter.
- Lämnade samtliga koordinater `NULL`.
- Dokumenterade Hållbarens lunchstängning och Blekingerundans preliminära geografiska arbetsordning.

### Beständiga beslut

- Villkorade stopp används för snäva öppettider, sena öppningar, geografiska avstickare eller svagare profil.
- En runda får vara färdig som adressbaserad version trots avsiktligt overifierade koordinater.

## Patch 004 – Repository Governance Foundation

**Status:** COMPLETE när dokumenten är lokalt verifierade och publicerade på `main`
**Scope:** Endast styrande dokumentation.

### Resultat

Skapar:

- `README.md`
- `VERIFICATION_GUIDE.md`
- `docs/handoff/MASTER_INDEX.md`
- `docs/handoff/CURRENT_STATE.md`
- `docs/handoff/HANDOFF.md`
- `docs/history/PATCH_HISTORY.md`

### Beständiga beslut

- En officiell läsordning gäller för framtida arbetspass.
- Schema och seeds är normativ datakälla; exporter är härledda.
- Verifieringsregler, källhierarki, koordinatpolicy och GitHub-flöde är dokumenterade.
- Lokal verifiering krävs före commit, push och PR.
- Dynamiska merge-SHA-värden hämtas ur Git och kräver inte separata state-lock-patchar.
- `CHANGELOG.md` reserveras för betydande dataset- och exportändringar; administrativ dokumentation hör hemma i patchhistoriken.
