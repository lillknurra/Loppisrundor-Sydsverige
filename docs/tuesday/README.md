# Tuesday Planning

Denna katalog innehåller dokument som används vid planering av en
tisdagsrunda.

Arbetsflödet är uppdelat i två steg.

## Steg 1 – välj runda

Läs:

- [`TUESDAY_ROUND_PREVIEW.md`](TUESDAY_ROUND_PREVIEW.md)

Syftet är att gruppen tillsammans ska jämföra alternativen och välja vilken
runda som ska köras.

Previewn är ett beslutsunderlag. Den ska inte användas som en färdig
körordning eller ett tidsschema.

## Steg 2 – planera den valda rundan

När en runda har valts används kommande planeringsdokument för att skapa
dagens faktiska rutt.

Den planeringen behöver bland annat hantera:

- aktuellt resdatum,
- startplats,
- öppettider,
- villkorade stopp,
- stoppordning,
- restider,
- raster,
- önskad sluttid,
- kart- och navigeringsunderlag.

I Patch 005 finns endast steg 1 implementerat.

## Datagrund

Previewn är härledd från repositoryts nuvarande schema och seed-data.

Normativ information finns i:

1. `database/schema.sql`
2. `database/seed/*.sql`

Om previewn motsäger schema eller seed-data gäller schema och seed-data.
