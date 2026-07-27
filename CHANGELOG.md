# Changelog

Alla betydande ändringar av verifierade dataset och publicerade exporter dokumenteras här.

## 2026-07-26 – Blekingerundan version 1

### Färdigställd

- Publicerade Blekingerundan version 1 med 11 verifierade tisdagstopp i Bromölla, Kristianstad, Sölvesborg, Asarum och Karlshamn.
- Datasetet innehåller 8 valda stopp och 3 villkorade stopp.
- Samtliga koordinater lämnas `NULL`; version 1 är därför adressbaserad och inga kartpunkter har gissats.
- Stoppordningen är en första geografisk arbetsordning och är ännu inte fullständigt tidsoptimerad.
- Hållbarens publicerade ytterintervall är 10:00–15:30, men verksamheten har lunchstängt 12:00–13:00 och detta är dokumenterat i stoppets notering.
- Publicerade härledda exporter:
  - `exports/csv/blekingerundan_v1.csv`
  - `exports/geojson/blekingerundan_v1.geojson`

### Validering

Valideringen ska köras mot `database/schema.sql` och samtliga tre seed-filer i en ren SQLite-databas, med seed-filerna applicerade två gånger:

- `PRAGMA integrity_check;` → `ok`
- `PRAGMA foreign_key_check;` → inga rader
- dubbel seed-körning skapar inga dubbletter
- Blekingerundan innehåller 11 stopp: 8 `selected` och 3 `conditional`
- `v_route_candidates` och `v_needs_verification` körs utan fel
- CSV-exporten innehåller 11 datarader i databasens stoppordning
- GeoJSON-exporten innehåller 11 features i samma stoppordning
- GeoJSON använder `geometry: null` för samtliga stopp eftersom koordinaterna är avsiktligt overifierade

### Kända begränsningar

Blekingerundan version 1 är färdig som adressbaserad runda. Exakta koordinater kan kompletteras senare när de kan styrkas mot godkända källor. Bromölla, Norreboden och Hållbaren är villkorade främst på grund av snäva eller sena öppettider.

## 2026-07-26 – Hallandsrundan version 1

### Färdigställd

- Publicerade Hallandsrundan version 1, senare utökad genom Patch 006B till 11 tisdagstopp i Höganäs, Ängelholm, Våxtorp, Laholm och Halmstad.
- Datasetet innehåller efter Patch 006B 7 valda stopp och 4 villkorade stopp.
- Lade till Erikshjälpen Second Hand Halmstad och Myrorna Halmstad från respektive officiell butikssida.
- Samtliga koordinater lämnas `NULL`; version 1 är därför adressbaserad och inga kartpunkter har gissats.
- Kretsloppans publicerade ytterintervall är 10:00–15:30, men butiken har lunchstängt 12:30–13:00 och detta är dokumenterat i stoppets notering.
- Gjorde Hallandsseedens butiksinlägg återkörningsbara och lade genom Patch 006B till Kattens Loppis & Kuriosa som säsongsberoende `conditional`-stopp.
- Publicerade härledda exporter:
  - `exports/csv/hallandsrundan_v1.csv`
  - `exports/geojson/hallandsrundan_v1.geojson`

### Validering

Valideringen kördes mot `database/schema.sql` och båda seed-filerna i en ren SQLite-databas, med seed-filerna applicerade två gånger:

- `PRAGMA integrity_check;` → `ok`
- `PRAGMA foreign_key_check;` → inga rader
- dubbel seed-körning skapade inga dubbletter
- Hallandsrundan innehåller efter Patch 006B 11 stopp: 7 `selected` och 4 `conditional`
- `v_route_candidates` och `v_needs_verification` kördes utan fel
- CSV-exporten innehåller efter Patch 006B 11 datarader i databasens stoppordning
- GeoJSON-exporten innehåller efter Patch 006B 11 features i samma stoppordning
- GeoJSON använder `geometry: null` för samtliga stopp eftersom koordinaterna är avsiktligt overifierade

### Kända begränsningar

Hallandsrundan version 1 är färdig som adressbaserad runda. Exakta koordinater kan kompletteras senare när de kan styrkas mot godkända källor. Myrorna Halmstads postnummer är också `NULL` eftersom den använda officiella butikssidan inte anger det.

## 2026-07-26 – Söderrundan version 1

### Färdigställd

- Publicerade Söderrundan version 1 med 11 tisdagstopp i Lund, Malmö, Trelleborg och Ystad.
- Alla stopp har verifierad adress och verifierade ordinarie tisdagstider från angiven källa.
- Tio stopp har styrkta koordinater.
- Erikshjälpen Second Hand Trelleborg, Hedvägen 185, 231 66 Trelleborg, publiceras utan koordinater. `latitude` och `longitude` förblir `NULL`; adressen är tillräcklig för version 1 och ingen kartpunkt har gissats.
- Publicerade härledda exporter:
  - `exports/csv/soderrundan_v1.csv`
  - `exports/geojson/soderrundan_v1.geojson`
- GeoJSON representerar Trelleborgsstoppet med `geometry: null`.

### Validering

Valideringen kördes mot `database/schema.sql` och `database/seed/001_soderrundan.sql` i en ren SQLite-databas:

- `PRAGMA integrity_check;` → `ok`
- `PRAGMA foreign_key_check;` → inga rader
- `v_route_candidates` kördes och returnerade 11 rader
- `v_needs_verification` kördes och returnerade en rad: Trelleborgsstoppets avsiktligt saknade koordinater
- CSV-exporten innehåller 11 stopp i databasens stoppordning
- GeoJSON-exporten innehåller 11 features i samma stoppordning

### Känd begränsning

Söderrundan version 1 är färdig som adressbaserad runda. Den saknade koordinaten för Trelleborg kan kompletteras senare när en kartpunkt kan styrkas mot en godkänd källa, utan att detta blockerar version 1.

## Patch 006 – Navigation & Route Export

- Lägger till reproducerbara adressbaserade CSV-exporter för Google My Maps.
- Numrerar visningsnamn enligt publicerad `stop_order`.
- Lägger till Google Maps-ruttlänkar för hela rundor och mobilanpassade deletapper.
- Lägger till en mobilvänlig HTML-startsida för navigering.
- Kräver ingen API-nyckel och ändrar inga butiks- eller öppettidsuppgifter.
- Dokumenterar uttryckligen att stoppordningen är en geografisk arbetsordning, inte automatiskt tidsoptimerad.

## Patch 006B – Rundresor från Hofterup och utökad Hallandsrunda

- Lägger till `Hofterup, Sverige` som fast start och mål för samtliga rundor.
- Ändrar mobilsegmenteringen så att den utgår från hela rundresekedjan.
- Lägger till Kattens Loppis & Kuriosa som säsongsberoende och villkorat stopp i Hallandsrundan.
- Ordnar Hallandsrundan geografiskt via Höganäs, Ängelholm, Våxtorp, Laholm och Halmstad.
- Utökar manifestet och Patch 006-validatorn för rundresenavigering.
- Regenererar My Maps-, Markdown-, HTML- och manifestfiler.
