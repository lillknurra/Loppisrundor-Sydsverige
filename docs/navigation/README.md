# Navigation och ruttlänkar

Patch 006 publicerar navigeringsunderlag utan Google Cloud, API-nyckel eller betald routingtjänst.

## Produkter

- `exports/mymaps/*.csv`: tre adressbaserade lager för Google My Maps.
- `exports/routes/index.html`: mobilvänlig startsida med Google Maps-knappar.
- `exports/routes/*.md`: en läsbar färdplan per runda.
- `exports/routes/manifest.json`: maskinläsbar exportmetadata.

## Ruttsemantik

Länkarna använder databasens publicerade `stop_order`. Ordningen är en geografisk arbetsordning och ska inte beskrivas som automatiskt tidsoptimerad.

Google Maps väljer faktisk väg längs vägnätet när länken öppnas. Trafik, vägavstängningar och aktuellt vägval bestäms då av Google Maps och lagras inte som verifierad projektdokumentation.

## Dator och mobil

Varje runda har en fullständig länk samt mobilanpassade deletapper med högst fem navigeringsplatser totalt, inklusive segmentets start och mål. Deletapperna överlappar i en gemensam brytpunkt så att föregående etapps destination blir nästa etapps start.

## Generering

```bash
python3 scripts/export_navigation.py
```

## Validering

```bash
bash scripts/validate_patch_006.sh
```

## Begränsningar

- Inga länkar bevisar att en butik är öppen på resdagen.
- Adresserna hämtas från normativ seed-data.
- Ingen automatisk geokodning skriver koordinater till databasen.
- Ingen ruttoptimering eller körsträcka publiceras i Patch 006.

## Patch 006B

Alla helrutter startar och slutar i `Hofterup, Sverige`. Hofterup används endast som navigeringspunkt och förekommer därför inte i My Maps-CSV:n eller den numrerade butikslistan.

Mobildeletapperna byggs från kedjan `Hofterup → samtliga butiker i stop_order → Hofterup`. Varje deletapp får innehålla högst fem navigeringsplatser och delar en överlappningspunkt med nästa deletapp.

Kattens Loppis & Kuriosa i Våxtorp är `conditional` och säsongsberoende. Tisdagsöppettiden måste kontrolleras före avresa.
