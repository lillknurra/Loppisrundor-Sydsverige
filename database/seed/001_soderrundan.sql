PRAGMA foreign_keys = ON;
BEGIN;

INSERT OR IGNORE INTO routes (route_code, name, description) VALUES
('SOUTH', 'Söderrundan', 'Tisdagsrunda i Lund, Malmö och Ystad.');

INSERT INTO shops (
    public_id, route_code, name, address, postcode, locality,
    latitude, longitude, tuesday_opens, tuesday_closes, tuesday_status,
    source_url, source_type, checked_at, assessment, candidate_status,
    stop_order, visit_minutes, notes
) VALUES
('south-erikshjalpen-lund-vasterbro', 'SOUTH', 'Erikshjälpen Second Hand Lund Västerbro', 'Åldermansgatan 2', '227 64', 'Lund', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://erikshjalpen.se/butiker/lund-vasterbro/', 'official_website', '2026-07-26', 'Hög prioritet: stor butik med brett sortiment och kafé.', 'selected', 1, 60, 'Startstopp. Ordinarie tisdagstid verifierad på butikens officiella sida.'),
('south-erikshjalpen-lund-city', 'SOUTH', 'Erikshjälpen Second Hand Lund City', 'Stora Södergatan 25', '222 23', 'Lund', NULL, NULL, '11:00', '18:00', 'verified_open', 'https://erikshjalpen.se/butiker/second-hand-lund-city/', 'official_website', '2026-07-26', 'Hög prioritet: hem, hushåll, möbler, el, böcker och media.', 'selected', 2, 45, 'Ordinarie tisdagstid verifierad på butikens officiella sida.'),
('south-erikshjalpen-malmo', 'SOUTH', 'Erikshjälpen Second Hand Malmö', 'Sallerupsvägen 88', '212 28', 'Malmö', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://erikshjalpen.se/butiker/second-hand-malmo/', 'official_website', '2026-07-26', 'Hög prioritet: stor butik med möbler, hem, kläder och kafé.', 'selected', 3, 60, 'Ordinarie tisdagstid verifierad på butikens officiella sida.'),
('south-bjorkafrihet-heleneholm', 'SOUTH', 'Björkåfrihet Malmö Heleneholm', 'Lantmannagatan 59', NULL, 'Malmö', NULL, NULL, '10:00', '19:00', 'verified_open', 'https://english.bjorkafrihet.se/oppettider-bjorkafrihet-second-hand-butiker/', 'official_website', '2026-07-26', 'Hög prioritet: större stadsdelsbutik med bättre rundvärde än citybutikerna.', 'selected', 4, 45, 'Uppgifterna finns på organisationens officiella engelska butikssida.'),
('south-skane-stadsmission-mobilia', 'SOUTH', 'Skåne Stadsmission Second Hand Mobilia', 'Per Albin Hanssons väg 40', NULL, 'Malmö', NULL, NULL, '10:00', '20:00', 'verified_open', 'https://www.skanestadsmission.se/second-hand/', 'official_website', '2026-07-26', 'Normal prioritet: kläder, barnvaror, leksaker och hemprylar.', 'selected', 5, 35, 'Butiken ligger i Mobilia, södra huset, plan 1.'),
('south-myrorna-malmo-centrum', 'SOUTH', 'Myrorna Malmö centrum', 'Södra Förstadsgatan 74A', NULL, 'Malmö', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://www.myrorna.se/butiker/malmo/malmo-centrum/', 'official_website', '2026-07-26', 'Normal prioritet: centralt stopp med kläder, inredning och prylar.', 'selected', 6, 35, 'Postnummer saknas i den verifierade butikssidan och lämnas därför tomt.'),
('south-bjorkafrihet-malmo-city', 'SOUTH', 'Björkåfrihet Malmö City', 'Södra Förstadsgatan 14', NULL, 'Malmö', NULL, NULL, '11:00', '19:00', 'verified_open', 'https://bjorkafrihet.se/oppettider-bjorkafrihet-second-hand-butiker/', 'official_website', '2026-07-26', 'Normal prioritet: centralt stopp men mer klädtyngt än lagerbutikerna.', 'selected', 7, 35, 'Sommartiden 1 juli–30 augusti är också 11:00–19:00 på vardagar.'),
('south-ab-smaland-malmo', 'SOUTH', 'AB Småland', 'Södra Förstadsgatan 25-27', NULL, 'Malmö', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://www.skanestadsmission.se/second-hand/', 'official_website', '2026-07-26', 'Låg prioritet: design- och hållbarhetsinriktat, med svagare loppisprofil.', 'conditional', 8, 30, 'Hoppa över först vid tidsbrist. Listas av Skåne Stadsmission som samarbetsbutik.'),
('south-skane-stadsmission-triangeln', 'SOUTH', 'Skåne Stadsmission Second Hand Triangeln', 'Södra Förstadsgatan 41', NULL, 'Malmö', NULL, NULL, '10:00', '20:00', 'verified_open', 'https://www.skanestadsmission.se/second-hand/', 'official_website', '2026-07-26', 'Låg prioritet: främst vintage, märkeskläder och accessoarer.', 'conditional', 9, 25, 'Hoppa över först vid tidsbrist. Butiken ligger i Triangelns köpcentrum, plan 2.'),
('south-roda-korset-ystad', 'SOUTH', 'Röda Korset Second hand Ystad', 'Skansgatan 2', '271 43', 'Ystad', NULL, NULL, '12:00', '17:00', 'verified_open', 'https://www.rodakorset.se/ort/skane/ystads-kommun/second-hand/roda-korset-second-hand-ystad/', 'official_website', '2026-07-26', 'Normal prioritet och geografiskt slutstopp: kläder, glas, porslin och prydnadssaker; inga skrymmande möbler.', 'selected', 10, 35, 'Slutstopp. Officiella sidan anger tisdag–fredag 12:00–17:00.');

COMMIT;
