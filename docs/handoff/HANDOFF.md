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

## Patch 006 – Navigation & Route Export

Patch 006 bygger vidare på Tuesday Round Preview med reproducerbara navigeringsexporter.

### Leveranser

- `scripts/export_navigation.py`
- `scripts/validate_patch_006.sh`
- `docs/navigation/README.md`
- `exports/mymaps/`
- `exports/routes/`

### Verifiering före publicering

1. Kör `bash scripts/validate_patch_006.sh`.
2. Öppna `exports/routes/index.html` lokalt.
3. Prova minst en hel ruttlänk på dator.
4. Prova samtliga deletapper för en runda på mobil.
5. Kontrollera att My Maps-importen använder `Adress` och `Namn`.
6. Granska att inga schema-, seed- eller datasetändringar finns.
7. Kör `git diff --check`.

### Avgränsningar

Patch 006 innehåller inte automatisk ruttoptimering, restidsberäkning, GPX, PDF eller Google Cloud-integration.

## Patch 006B – Hofterup och utökad Hallandsrunda

Patch 006B är **COMPLETE** och publicerad genom PR #6, `Patch 006B: Hofterup round-trip navigation exports`.

- Feature-commit: `54d07dc689c1d411ba833127abb8abd7db975c98`
- Squash-commit på `main`: `1b986073db68ac3a75de9e5073a81ff4afdcdd81`
- Navigeringsmodellen är `Hofterup → samtliga butiker i publicerad stop_order → Hofterup`.
- Hofterup är inte ett butiksstopp.
- Mobildeletapper innehåller högst fem navigeringsplatser och delar en gemensam överlappningspunkt.
- Hallandsrundans publicerade geografi är `Hofterup → Höganäs → Ängelholm → Våxtorp → Laholm → Halmstad → Hofterup`.
- Hallandsrundan innehåller 11 butiksstopp: 7 `selected` och 4 `conditional`.
- Kattens Loppis & Kuriosa är `conditional` och säsongsberoende; aktuell tisdagstid måste kontrolleras före avresa.
- Den tidigare feature-branchen är borttagen lokalt och från `origin`.

## Patch 006C – Post-Merge State Reconciliation

Patch 006C synkroniserar endast styrande dokumentation med det publicerade slutläget efter Patch 006B.

### Omfattning

- rätta Patch 006 och 006B till publicerad `COMPLETE`-status,
- dokumentera PR #6 samt feature- och squash-commit,
- rätta Hallandsrundans stopp- och statusantal,
- ersätta inaktuella commit-, push- och publiceringsinstruktioner,
- synkronisera patchhistorik och changelog.

### Avgränsningar

Patch 006C ändrar inte:

- schema,
- seeds,
- ruttdata,
- scripts,
- genererade exporter,
- verifieringspolicy.

## Nästa rekommenderade arbete efter Patch 006C

Nästa produkt- eller datapatch är ännu inte vald. Den ska väljas uttryckligen som ett separat beslut efter att Patch 006C är granskad och publicerad.

Före nästa implementation ska arbetspasset:

1. verifiera ren och uppdaterad `main`,
2. läsa den officiella dokumentordningen,
3. välja exakt produkt- eller datamål,
4. definiera patchnummer, scope, evidensgränser, berörda filer och verifieringskrav,
5. undvika att blanda ny datainsamling, schemaändring och produktutveckling i samma patch utan uttryckligt beslut.
