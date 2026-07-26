# Master Index

Detta är repositoryts officiella startpunkt för handoff och AI-assisterat arbete efter att `README.md` och `VERIFICATION_GUIDE.md` har lästs.

## Obligatorisk läsordning

Läs alltid i denna ordning:

1. `README.md`
2. `VERIFICATION_GUIDE.md`
3. `docs/handoff/MASTER_INDEX.md`
4. `docs/handoff/CURRENT_STATE.md`
5. `docs/handoff/HANDOFF.md`
6. `docs/history/PATCH_HISTORY.md`
7. `CHANGELOG.md`
8. `database/schema.sql`
9. samtliga filer i `database/seed/`, i numerisk ordning
10. berörda filer i `exports/csv/` och `exports/geojson/`

Vid en dataändring ska även samtliga filer för den berörda rundan läsas, inte bara filen som förväntas ändras.

## Dokumentens auktoritet

Vid konflikt gäller följande prioritet:

1. repositoryts faktiska Git- och filstatus,
2. `database/schema.sql`,
3. `database/seed/*.sql`,
4. `VERIFICATION_GUIDE.md`,
5. `docs/handoff/CURRENT_STATE.md`,
6. `docs/handoff/HANDOFF.md`,
7. `docs/history/PATCH_HISTORY.md`,
8. `CHANGELOG.md`,
9. exporter.

CSV och GeoJSON är härledda och får aldrig användas för att tyst skriva över normativ seed-data.

## Arbetsstart

Innan en patch föreslås eller byggs:

```bash
git branch --show-current
git status --short
git rev-parse HEAD
git rev-parse origin/main
```

Bekräfta:

- korrekt repository,
- rätt branch,
- ren working tree eller uttryckligen känd lokal ändring,
- synkronisering med rätt remote-baslinje,
- senaste relevanta PR och patchstatus.

Om verklig Git-status avviker från `CURRENT_STATE.md` ska avvikelsen redovisas och den faktiska repository-statusen användas.

## Läsordning per uppgift

### Ny eller ändrad runda

Efter den obligatoriska läsordningen:

1. berörd seed-fil,
2. motsvarande CSV,
3. motsvarande GeoJSON,
4. senaste relevanta avsnitt i `CHANGELOG.md`,
5. källorna för varje ändrad faktauppgift.

### Schemaändring

Schemaändringar kräver separat patch och särskild konsekvensanalys:

1. alla seeds,
2. alla exporter,
3. alla queries och vyer,
4. bakåtkompatibilitet,
5. migreringsbehov.

### Dokumentationspatch

Verifiera att dokumentationen:

- stämmer med faktiska filer och schema,
- inte påstår att overifierade data är verifierade,
- inte inför nya krav som motsäger befintlig data utan att avvikelsen dokumenteras,
- inte ändrar dataset, exporter eller funktionalitet utanför scope.

## Patchdisciplin

Varje patch ska ha:

- ett tydligt namn och nummer,
- en verifierad ingångsbaslinje,
- uttalat scope och uttryckliga avgränsningar,
- komplett implementation,
- reproducerbar lokal verifiering,
- granskad diff,
- dokumenterad historik.

Patchar ska vara atomiska. Blanda inte orelaterade data-, schema-, verktygs- och dokumentationsändringar.

## Publiceringsregel

Commit, push och PR får ske först efter lokal verifiering. Draft PR används tills diff, innehåll och verifiering är godkända. Normal merge-metod är squash merge.

## Uppdateringsansvar

- `CURRENT_STATE.md` uppdateras när den beständiga projektstatusen förändras.
- `HANDOFF.md` uppdateras när nästa rekommenderade arbete förändras.
- `PATCH_HISTORY.md` uppdateras i varje slutförd patch.
- `CHANGELOG.md` uppdateras vid betydande publicerade dataset- eller exportändringar, inte för varje administrativ dokumentationsändring.

Dynamiska merge-SHA-värden behöver inte skrivas tillbaka genom en separat state-lock-patch. Använd Git som källa för aktuell commitidentitet.
