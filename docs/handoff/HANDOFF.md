# Handoff

## Sammanfattning

Patch 004 etablerar repositoryts permanenta styrdokumentation. Projektet har därefter en officiell läsordning, normativ verifieringsguide, dokumenterad patchmodell, aktuell beständig status och en samlad historik.

Patch 004 ändrar inga SQL-filer, seeds, exporter eller dataset.

## Verifiering av Patch 004

Före publicering ska följande bekräftas:

- exakt sex styrdokument har skapats,
- inga data-, schema- eller exportfiler har ändrats,
- samtliga interna filreferenser pekar på existerande eller samtidigt skapade filer,
- dokumenten stämmer med `database/schema.sql`, `CHANGELOG.md` och PR #1–#3,
- inga platshållare eller nya state-lock-krav finns,
- `git diff --check` passerar.

## Nästa rekommenderade arbete efter Patch 004

Nästa patch bör väljas som en separat, tydligt avgränsad datapatch. Rekommenderad beslutsordning:

1. välj nästa geografiska runda eller en uttryckligen prioriterad förbättring av en befintlig runda,
2. kontrollera att arbetet inte blandar ny datainsamling med schemaändring,
3. verifiera alla tidskänsliga källor på nytt,
4. bygg seed och båda exportformaten tillsammans,
5. följ `VERIFICATION_GUIDE.md` före publicering.

Ingen specifik nästa region låses i styrdokumentationen innan den har valts uttryckligen. Det förhindrar att en tillfällig plan framstår som ett beständigt krav.

## Startinstruktion för nästa arbetspass

1. Läs dokumenten i ordningen som anges i `docs/handoff/MASTER_INDEX.md`.
2. Kontrollera faktisk Git-status och aktuell `main`-SHA.
3. Bekräfta att Patch 004 finns på `main` och att working tree är ren.
4. Läs alla filer för den runda som ska ändras.
5. Definiera patchnummer, scope, avgränsningar och verifieringskrav innan implementation.

## Viktiga avgränsningar

- Skapa inte en separat patch enbart för att skriva tillbaka Patch 004:s merge-SHA.
- Behandla inte exporter som sanningskälla.
- Fyll inte saknade koordinater eller postnummer med antaganden.
- Ändra inte befintliga identifierare utan särskilt migreringsbeslut.
- Markera inte en datarunda som tidsoptimerad om den endast har en geografisk arbetsordning.

## Patch 005 – Tuesday Round Preview v1

Patch 005 skapar projektets första användarnära beslutsprodukt för planering
av en tisdagsrunda.

Previewn hjälper en grupp att jämföra Söderrundan, Hallandsrundan och
Blekingerundan innan någon detaljerad rutt planeras.

### Levererade filer

- `docs/tuesday/README.md`
- `docs/tuesday/TUESDAY_ROUND_PREVIEW.md`

### Produktprincip

Tuesday Round Preview fungerar som en startsida för ett framtida
planeringsflöde, inte som ett långt tekniskt dokument.

Informationsarkitekturen bygger på:

- jämförbara rundkort,
- snabbfakta,
- geografisk profil,
- faktiska exempelstopp,
- praktiska begränsningar,
- gemensamma diskussionsfrågor,
- ett tydligt överlämnande till nästa planeringssteg.

### Avgränsningar

Patch 005:

- ändrar inte schema, seeds, exporter eller dataset,
- skapar ingen ruttalgoritm,
- presenterar inte befintlig stoppordning som tidsoptimerad,
- inför inga stjärnbetyg eller andra poäng,
- ersätter inte kontroll av tidskänsliga uppgifter före resdagen.

### Verifiering före commit

- Samtliga tre rundor finns i previewn.
- Stoppantal och statusantal stämmer med seed-data.
- Namngivna exempelbutiker finns i respektive seed.
- Inga filer under `database/` eller `exports/` är ändrade.
- Alla lokala Markdown-länkar fungerar.
- `git diff --check` passerar.
