# Verification Guide

Detta dokument är projektets normativa verifieringsguide. Den gäller vid tillägg, ändring och publicering av rundor, butiker, öppettider, koordinater och exporter.

## 1. Verifieringsmål

En publicerad runda ska vara:

- källspårbar,
- explicit om osäkerhet,
- reproducerbar från schema och seeds,
- fri från databasfel och oavsiktliga dubbletter,
- konsekvent mellan SQLite, CSV och GeoJSON,
- läsbar utan tillgång till tidigare chattar.

Verifiering betyder inte att uppgifterna är permanenta. `checked_at` anger när källan senast kontrollerades.

## 2. Källhierarki

Källor ska prioriteras i följande ordning:

1. verksamhetens officiella webbplats,
2. kommunal, regional eller annan ansvarig organisations officiella webbplats,
3. verksamhetens officiella sociala medier,
4. direktkontakt med verksamheten,
5. sekundär källa, endast när starkare källa saknas och osäkerheten dokumenteras.

Tillåtna `source_type` definieras i schemat:

- `official_website`
- `official_social_media`
- `direct_contact`
- `secondary_source`

Karttjänsters automatiska sökträffar, katalogsidor och sökmotorsnippets ska inte ensamma användas för att verifiera ordinarie öppettider.

## 3. Uppgifter som ska verifieras

För varje stopp ska följande bedömas:

- verksamhetens aktuella namn,
- fullständig besöksadress,
- ort och, när källbelagt, postnummer,
- ordinarie tisdagsöppettid,
- källa och källtyp,
- datum för kontroll,
- verksamhetens relevans för rundan,
- urvalsstatus,
- planerad stoppordning och besökstid,
- koordinaternas verifieringsstatus.

Särskilda öppettider för helgdagar ska inte ersätta ordinarie tisdagstid. Lunchstängt eller delade öppettidsintervall ska dokumenteras i `notes`; om modellen bara rymmer ett intervall får ytterintervallet användas endast när avbrottet uttryckligen dokumenteras.

## 4. Hantering av okända och osäkra värden

Okända värden får inte fyllas med antaganden.

- Okänt postnummer: `NULL`.
- Overifierad latitud eller longitud: båda ska vara `NULL`.
- Overifierad tisdagstid: använd korrekt `tuesday_status`; använd inte `verified_open`.
- Osäker urvalsbedömning: använd `candidate` eller `conditional`.
- Kända begränsningar: skrivs i `notes` och vid behov i rundans `description` eller `CHANGELOG.md`.

Tom sträng ska inte användas i databasen för att representera okänt värde.

## 5. Koordinatpolicy

Koordinater får bara publiceras när kartpunkten kan knytas till rätt fysisk verksamhet genom en verifierbar källa.

Godtagbara underlag kan vara:

- koordinater publicerade av verksamheten eller ansvarig organisation,
- en officiell karta med tydlig verksamhetspunkt,
- en karttjänst där namn och fullständig adress entydigt matchar och punkten manuellt har kontrollerats.

Följande är inte tillåtet:

- att gissa koordinater utifrån ortens centrum,
- att använda en närliggande byggnad utan verifiering,
- att automatiskt geokoda och publicera resultatet utan manuell kontroll,
- att fylla bara den ena koordinaten.

När koordinater saknas ska GeoJSON använda `geometry: null`. Adressbaserad version 1 får publiceras utan koordinater när adress och övriga kärnuppgifter är verifierade.

## 6. Identifierare och ordning

### `route_code`

- ska vara stabilt,
- ska inte återanvändas för en annan runda,
- ska vara kort och maskinvänligt.

### `public_id`

- ska vara unikt i hela databasen,
- ska vara stabilt över tid,
- ska använda gemener, bindestreck och ASCII där det är praktiskt,
- ska inte ändras endast för kosmetiska namnändringar.

### `stop_order`

- ska vara unik inom rundan när den är satt,
- ska motsvara exporternas ordning,
- kan vara en geografisk arbetsordning och behöver inte vara tidsoptimerad om detta dokumenteras.

## 7. Seed-policy

Varje seed-fil ska:

- aktivera foreign keys,
- köras transaktionellt,
- skapa eller återanvända rundan utan dubbletter,
- lägga in butiker på ett återkörningsbart sätt,
- kunna köras minst två gånger i samma databas utan fel eller extra rader.

Projektets nuvarande seeds använder `INSERT OR IGNORE` för stabila unika identifierare. Ändringar ska inte dölja verkliga datakonflikter; kontrollera därför även att existerande raders innehåll är korrekt.

## 8. Ren databasverifiering

Kör från repositoryts rot:

```bash
set -euo pipefail
DB="$(mktemp -t loppisrundor.XXXXXX.sqlite)"
trap 'rm -f "$DB"' EXIT

sqlite3 "$DB" < database/schema.sql

for seed in database/seed/*.sql; do
  sqlite3 "$DB" < "$seed"
done

for seed in database/seed/*.sql; do
  sqlite3 "$DB" < "$seed"
done

sqlite3 "$DB" 'PRAGMA integrity_check;'
sqlite3 "$DB" 'PRAGMA foreign_key_check;'
sqlite3 "$DB" 'SELECT * FROM v_route_candidates;'
sqlite3 "$DB" 'SELECT * FROM v_needs_verification;'
```

Godkänt resultat:

- `PRAGMA integrity_check` returnerar exakt `ok`,
- `PRAGMA foreign_key_check` returnerar inga rader,
- den andra seed-körningen skapar inga dubbletter,
- båda vyerna kan läsas utan fel.

## 9. Obligatoriska SQL-kontroller

Exempel på kompletterande kontroller:

```sql
SELECT public_id, COUNT(*)
FROM shops
GROUP BY public_id
HAVING COUNT(*) > 1;

SELECT route_code, stop_order, COUNT(*)
FROM shops
WHERE stop_order IS NOT NULL
GROUP BY route_code, stop_order
HAVING COUNT(*) > 1;

SELECT route_code, COUNT(*) AS stops
FROM shops
GROUP BY route_code
ORDER BY route_code;

SELECT route_code, candidate_status, COUNT(*) AS stops
FROM shops
GROUP BY route_code, candidate_status
ORDER BY route_code, candidate_status;
```

Samtliga dubblettfrågor ska ge noll rader.

## 10. CSV-policy

En publicerad CSV ska:

- ha en rubrikrad,
- ha en datarad per publicerat stopp,
- följa databasens `stop_order`,
- återge `NULL` som tomt fält,
- använda korrekt CSV-escaping för kommatecken, citattecken och radbrytningar,
- inte innehålla beräknade eller gissade värden som saknas i databasen.

Kolumnordningen får vara exportformatspecifik men ska vara stabil inom en versionsserie. Teckenkodning ska vara UTF-8; eventuell BOM ska hanteras konsekvent av export- och valideringsverktyg.

## 11. GeoJSON-policy

En publicerad GeoJSON ska:

- vara giltig JSON,
- ha typen `FeatureCollection`,
- ha en feature per publicerat stopp,
- följa databasens `stop_order`,
- använda punktgeometri i ordningen `[longitude, latitude]` när båda koordinaterna är verifierade,
- använda `geometry: null` när koordinater saknas,
- återge centrala identitets-, adress-, status- och källfält som properties.

Exportformatet får innehålla ytterligare metadata, men får inte motsäga databasen.

## 12. Jämförelse mellan databas och exporter

För varje berörd runda ska följande stämma:

- antal databasrader,
- antal CSV-datarader,
- antal GeoJSON-features,
- `public_id` eller motsvarande stabil identifierare,
- stoppordning,
- namn och adress,
- öppettider och status,
- urvalsstatus,
- koordinater och null-geometri.

En export är inte godkänd enbart för att filen kan öppnas.

## 13. Patchverifiering

Före commit:

```bash
git status --short
git diff --check
git diff --stat
git diff --name-only
git diff
```

Kontrollera att:

- endast filer inom patchens uttalade scope har ändrats,
- inga temporära databaser, loggar eller lokala resultatfiler ingår,
- ingen befintlig data ändrats oavsiktligt,
- dokumentation och exporter beskriver samma slutläge,
- samtliga tester har körts efter den sista ändringen.

## 14. GitHub-flöde

1. Utgå från ren och synkroniserad `main`.
2. Skapa en avgränsad feature branch.
3. Applicera och verifiera patchen lokalt.
4. Commit med tydligt imperativt meddelande.
5. Push och skapa draft PR.
6. Dokumentera scope och verifieringsresultat i PR:n.
7. Markera PR redo först när diff och verifiering är godkända.
8. Squash-merga.
9. Uppdatera lokal `main` och ta bort lokal och remote feature branch.
10. Kontrollera att lokal `main`, `origin/main` och working tree är i förväntat tillstånd.

Ingen separat patch ska skapas enbart för att skriva in en merge-SHA. Dynamiska Git-uppgifter hämtas med Git-kommandon; dokumenten ska främst beskriva innehålls- och arbetsstatus.
