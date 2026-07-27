# Loppisrundor Sydsverige

Ett versionshanterat datarepository för verifierade loppis- och second hand-rundor i södra Sverige. Projektet samlar källbelagda butiksuppgifter, modellerar dem i SQLite och publicerar härledda CSV- och GeoJSON-exporter.

Repositoryt är i första hand en spårbar datakälla. Det ska vara möjligt att se var varje uppgift kommer från, när den kontrollerades, vilka begränsningar som finns och hur publicerade exporter kan återskapas och verifieras.

## Planera nästa tisdag

När flera personer tillsammans ska välja vilken runda de vill köra börjar
planeringen här:

- [`docs/tuesday/TUESDAY_ROUND_PREVIEW.md`](docs/tuesday/TUESDAY_ROUND_PREVIEW.md)

Previewn jämför Söderrundan, Hallandsrundan och Blekingerundan som tre tydliga
alternativ. Den är ett beslutsunderlag innan exakt körordning, tidsschema,
raster och navigering planeras.

En översikt över arbetsflödet finns i
[`docs/tuesday/README.md`](docs/tuesday/README.md).

## Officiell läsordning

Allt arbete ska börja med följande dokument:

1. `README.md`
2. `VERIFICATION_GUIDE.md`
3. `docs/handoff/MASTER_INDEX.md`

`MASTER_INDEX.md` anger därefter den fullständiga läsordningen för aktuell typ av arbete.

## Projektets omfattning

Projektet hanterar:

- rundor med stabila `route_code`-identifierare,
- butiker och stopp med stabila `public_id`-identifierare,
- verifierade tisdagsöppettider,
- källor och kontrolltidpunkt,
- urvalsstatus och stoppordning,
- uppskattad besökstid,
- koordinater endast när de kan styrkas,
- härledda CSV- och GeoJSON-exporter.

Projektet är inte en realtidsdatabas. Öppettider och verksamhetsuppgifter kan ändras efter angivet `checked_at` och ska därför kontrolleras på nytt före faktisk körning.

## Repositorystruktur

```text
.
├── README.md
├── VERIFICATION_GUIDE.md
├── CHANGELOG.md
├── database/
│   ├── schema.sql
│   └── seed/
│       ├── 001_soderrundan.sql
│       ├── 002_hallandsrundan.sql
│       └── 003_blekingerundan.sql
├── exports/
│   ├── csv/
│   └── geojson/
└── docs/
    ├── handoff/
    │   ├── MASTER_INDEX.md
    │   ├── CURRENT_STATE.md
    │   └── HANDOFF.md
    └── history/
        └── PATCH_HISTORY.md
```

## Datamodell

### `routes`

En rad per runda:

- `route_code`: stabil maskinidentifierare och primärnyckel,
- `name`: unikt visningsnamn,
- `description`: beständig beskrivning av rundans omfattning och kända begränsningar.

### `shops`

En rad per butik eller stopp. Viktiga fält:

- `public_id`: stabil, unik och URL-/exportvänlig identifierare,
- `route_code`: koppling till runda,
- `name`, `address`, `postcode`, `locality`: adressuppgifter,
- `latitude`, `longitude`: verifierade koordinater eller `NULL`,
- `tuesday_opens`, `tuesday_closes`, `tuesday_status`: tisdagstillgänglighet,
- `source_url`, `source_type`, `checked_at`: verifieringsspår,
- `assessment`: kvalitativ bedömning,
- `candidate_status`: urvalsstatus,
- `stop_order`: ordning inom rundan,
- `visit_minutes`: planerad besökstid,
- `notes`: begränsningar och kompletterande verifieringsinformation.

Schemat och tillåtna enumvärden definieras normativt i `database/schema.sql`.

## Statusfält

### `tuesday_status`

- `verified_open`: öppettid på tisdag är verifierad och både öppnings- och stängningstid finns,
- `verify_directly`: uppgiften måste bekräftas direkt med verksamheten,
- `verified_closed`: verksamheten är verifierat stängd på tisdag,
- `unknown`: tillräckligt underlag saknas.

### `candidate_status`

- `selected`: ingår normalt i rundan,
- `candidate`: kandidat som ännu inte är slutligt bedömd,
- `conditional`: kan ingå beroende på tid, geografi eller profil,
- `excluded`: ska inte ingå i publicerad runda men kan behållas för spårbarhet.

## Sanningskälla och härledda filer

Normativ data finns i:

1. `database/schema.sql`
2. `database/seed/*.sql`

CSV- och GeoJSON-filer i `exports/` är härledda publiceringsformat. Vid motsägelse gäller databasens schema och seed-data, tills avvikelsen har rättats och exporterna genererats om.

`CHANGELOG.md` dokumenterar betydande publicerade datasetändringar. Patchhistorik och arbetsstatus dokumenteras separat under `docs/`.

## Grundprinciper

- Uppgifter ska vara källbelagda.
- Officiella primärkällor ska prioriteras.
- Okända värden ska representeras som `NULL` eller rätt statusvärde, aldrig gissas.
- Koordinater får inte härledas från en adress utan verifierbar kartkälla.
- Seeds ska vara säkert återkörningsbara.
- Exporter ska överensstämma med databasen i antal, ordning och innehåll.
- En patch ska vara avgränsad, granskningsbar och lokalt verifierad innan publicering.

## Lokal SQLite-verifiering

Se den normativa processen i `VERIFICATION_GUIDE.md`. Minimikravet är en ren temporär databas, schemaimport, samtliga seeds två gånger, integritetskontroll, foreign-key-kontroll, dubblettkontroll och jämförelse mot exporter.

## Arbetsmodell

Projektet använder små, atomiska patchar:

1. verifiera stabil `main`,
2. avgränsa patchens scope,
3. undersök och dokumentera källor,
4. skapa eller ändra data och härledda exporter,
5. kör lokal verifiering,
6. granska diffen,
7. commit och push på separat branch,
8. skapa draft PR,
9. markera redo först när verifieringen passerat,
10. squash-merga och ta bort feature-branchen.

Dynamisk projektstatus finns i `docs/handoff/CURRENT_STATE.md`. Nästa rekommenderade arbete finns i `docs/handoff/HANDOFF.md`.
