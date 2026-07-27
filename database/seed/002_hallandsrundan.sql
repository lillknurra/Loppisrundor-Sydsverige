PRAGMA foreign_keys = ON;
BEGIN;

INSERT INTO routes (route_code, name, description) VALUES
('HALLAND', 'Hallandsrundan', 'Hallandsrundan version 1: adressbaserad tisdagsrunda från Hofterup via Höganäs, Ängelholm, Våxtorp, Laholm och Halmstad tillbaka till Hofterup.')
ON CONFLICT(route_code) DO UPDATE SET
    name = excluded.name,
    description = excluded.description;

INSERT INTO shops (
    public_id, route_code, name, address, postcode, locality,
    latitude, longitude, tuesday_opens, tuesday_closes, tuesday_status,
    source_url, source_type, checked_at, assessment, candidate_status,
    stop_order, visit_minutes, notes
) VALUES
('halland-roda-korset-hoganas', 'HALLAND', 'Röda Korset Second hand Höganäs', 'Storgatan 21', '263 37', 'Höganäs', NULL, NULL, '13:00', '17:00', 'verified_open', 'https://www.rodakorset.se/ort/skane/hoganas-kommun/second-hand/roda-korset-second-hand-hoganas/', 'official_website', '2026-07-26', 'Villkorat inledande stopp med husgeråd, kläder, leksaker och mindre fynd.', 'conditional', 1, 35, 'Adress och tisdagstid verifierade på Röda Korsets officiella butikssida. Stoppet ligger först i den publicerade geografiska ordningen från Hofterup via Höganäs mot Ängelholm.'),
('halland-pmu-angelholm', 'HALLAND', 'PMU Second Hand Ängelholm', 'Transportgatan 5', '262 71', 'Ängelholm', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://pmu.se/butik/angelholm/', 'official_website', '2026-07-26', 'Hög prioritet: stor välgörenhetsbutik med brett sortiment.', 'selected', 2, 60, 'Adress och tisdagstid verifierade på PMU:s officiella butikssida. Koordinater lämnas NULL; adress är tillräcklig för version 1.'),
('halland-fyndhuset-angelholm', 'HALLAND', 'Fyndhuset Ängelholm', 'Heimdallgatan 42', '262 71', 'Ängelholm', NULL, NULL, '14:00', '18:00', 'verified_open', 'https://www.fyndhusetengelholm.se/', 'official_website', '2026-07-26', 'Hög prioritet: antikt, kuriosa, retro och möbler med tydlig loppisprofil.', 'selected', 3, 50, 'Adress och tisdagstid verifierade på verksamhetens officiella webbplats. Öppnar 14:00 och bör tidsplaneras därefter.'),
('halland-roda-korset-angelholm', 'HALLAND', 'Röda Korset Second hand Ängelholm', 'Storgatan 4A', '262 32', 'Ängelholm', NULL, NULL, '14:00', '17:00', 'verified_open', 'https://www.rodakorset.se/ort/skane/angelholms-kommun/second-hand/roda-korset-second-hand-angelholms/', 'official_website', '2026-07-26', 'Normal prioritet: diversehandel med kläder, skor, porslin och mindre prylar men utan möbler och böcker.', 'selected', 4, 35, 'Adress och tisdagstid verifierade på Röda Korsets officiella butikssida. Öppnar 14:00.'),
('halland-kattens-loppis-vaxtorp', 'HALLAND', 'Kattens Loppis & Kuriosa', 'Kristianstadsvägen 6', '312 75', 'Våxtorp', NULL, NULL, '13:00', '17:00', 'verify_directly', 'https://loppisportalen.se/biz/kattens-loppis-kuriosa/', 'secondary_source', '2026-07-27', 'Säsongsöppet loppis- och kuriosastopp med porslin, böcker, glas, möbler, retro, antikt och varierat bohag. Geografiskt naturligt mellan Ängelholm och Laholm.', 'conditional', 5, 45, 'Adressen stöds även av Visit Laholm. Loppisportalen anger tisdag 13:00–17:00 april–oktober och sommaröppet alla dagar 13:00–17:00 från midsommardagen till 15 augusti. Andra kataloguppgifter motsäger tisdagstiden. Öppettiden måste därför kontrolleras före avresa och posten ska förbli conditional tills en primär eller direkt verksamhetskälla har verifierats. Schemat saknar seasonal_unverified och directory; närmaste tillåtna värden verify_directly och secondary_source används.'),
('halland-roda-korset-laholm', 'HALLAND', 'Röda Korset Second hand Laholm', 'Östertullsgatan 24', '312 30', 'Laholm', NULL, NULL, '10:00', '17:00', 'verified_open', 'https://www.rodakorset.se/ort/halland/laholms-kommun/', 'official_website', '2026-07-26', 'Normal prioritet: centralt och stabilt tisdagstopp mellan Våxtorp och Halmstad.', 'selected', 6, 40, 'Adress och tisdagstid verifierade på Röda Korsets officiella Laholmssida.'),
('halland-kretsloppan-halmstad', 'HALLAND', 'Kretsloppan Halmstad', 'Knäredsgatan 23', '302 50', 'Halmstad', NULL, NULL, '10:00', '15:30', 'verified_open', 'https://www.halmstad.se/byggaboochmiljo/avfallochatervinning/aterbrukochateranvandning/kretsloppansecondhandbutik.n2299.html', 'official_website', '2026-07-26', 'Hög prioritet: kommunal återbruksbutik med möbler, cyklar, glas och porslin.', 'selected', 7, 50, 'Officiell kommunal sida visar tisdag 10:00–12:30 och 13:00–15:30. Exporten använder hela ytterintervallet; lunchstängningen måste beaktas i körplanen.'),
('halland-pmu-halmstad', 'HALLAND', 'PMU Second Hand Halmstad', 'Stormgatan 10', '302 63', 'Halmstad', NULL, NULL, '12:00', '18:00', 'verified_open', 'https://pmu.se/butik/halmstad/', 'official_website', '2026-07-26', 'Hög prioritet: bred butik med möbler, porslin, böcker, teknik, fritid och kafé.', 'selected', 8, 60, 'Adress, sortiment och tisdagstid verifierade på PMU:s officiella butikssida.'),
('halland-myrorna-halmstad', 'HALLAND', 'Myrorna Halmstad', 'Karl XI:s väg 47', NULL, 'Halmstad', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://www.myrorna.se/butiker/halmstad/halmstad/', 'official_website', '2026-07-26', 'Villkorat centralt stopp med kläder, inredning, böcker, skivor, hushållsvaror och mindre möbler.', 'conditional', 9, 40, 'Adress, sortiment och tisdagstid verifierade på Myrornas officiella butikssida. Postnummer och koordinater lämnas NULL eftersom de inte styrks av den använda officiella sidan.'),
('halland-erikshjalpen-halmstad', 'HALLAND', 'Erikshjälpen Second Hand Halmstad', 'Ryttarevägen 10', '302 62', 'Halmstad', NULL, NULL, '11:00', '18:00', 'verified_open', 'https://erikshjalpen.se/butiker/second-hand-halmstad/', 'official_website', '2026-07-26', 'Villkorat högvärdesstopp: över 2100 kvadratmeter med möbler, el, böcker, media, hem- och hushållssortiment samt kafé.', 'conditional', 10, 60, 'Adress, postnummer, sortiment och tisdagstid verifierade på Erikshjälpens officiella butikssida. Koordinater lämnas NULL tills en kartpunkt kan styrkas.'),
('halland-roda-korset-halmstad', 'HALLAND', 'Röda Korset Second hand Halmstad', 'Ryttarevägen 11', '302 62', 'Halmstad', NULL, NULL, '12:00', '18:00', 'verified_open', 'https://www.rodakorset.se/ort/halland/halmstads-kommun/second-hand/roda-korset-second-hand-halmstad/', 'official_website', '2026-07-26', 'Normal prioritet: etablerad second hand-butik med bra geografiskt slutläge i Halmstad.', 'selected', 11, 45, 'Adress och tisdagstid verifierade på Röda Korsets officiella butikssida.')
ON CONFLICT(public_id) DO UPDATE SET
    route_code = excluded.route_code,
    name = excluded.name,
    address = excluded.address,
    postcode = excluded.postcode,
    locality = excluded.locality,
    latitude = excluded.latitude,
    longitude = excluded.longitude,
    tuesday_opens = excluded.tuesday_opens,
    tuesday_closes = excluded.tuesday_closes,
    tuesday_status = excluded.tuesday_status,
    source_url = excluded.source_url,
    source_type = excluded.source_type,
    checked_at = excluded.checked_at,
    assessment = excluded.assessment,
    candidate_status = excluded.candidate_status,
    stop_order = excluded.stop_order,
    visit_minutes = excluded.visit_minutes,
    notes = excluded.notes;

COMMIT;
