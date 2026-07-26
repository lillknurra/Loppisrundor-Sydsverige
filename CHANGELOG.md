# Changelog

Alla betydande ändringar av verifierade dataset och publicerade exporter dokumenteras här.

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
