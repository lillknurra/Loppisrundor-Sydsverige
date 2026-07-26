PRAGMA foreign_keys = ON;
BEGIN;

INSERT OR IGNORE INTO routes (route_code, name, description) VALUES
('SOUTH', 'Söderrundan', 'Tisdagsrunda i Lund och sydvästra Skåne.');

INSERT INTO shops (
    public_id, route_code, name, address, postcode, locality,
    latitude, longitude, tuesday_opens, tuesday_closes, tuesday_status,
    source_url, source_type, checked_at, assessment, candidate_status,
    stop_order, visit_minutes, notes
) VALUES
('south-erikshjalpen-lund-vasterbro', 'SOUTH', 'Erikshjälpen Second Hand Lund Västerbro', 'Åldermansgatan 2', '227 64', 'Lund', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://erikshjalpen.se/butiker/lund-vasterbro/', 'official_website', '2026-07-26', 'Stor butik med brett sortiment och kafé; mycket stark kandidat för rundan.', 'candidate', NULL, 60, 'Ordinarie tisdagstid verifierad på butikens officiella sida.'),
('south-erikshjalpen-lund-city', 'SOUTH', 'Erikshjälpen Second Hand Lund City', 'Stora Södergatan 25', '222 23', 'Lund', NULL, NULL, '11:00', '18:00', 'verified_open', 'https://erikshjalpen.se/butiker/second-hand-lund-city/', 'official_website', '2026-07-26', 'Centralt stopp med hem, hushåll, möbler, el, böcker och media; stark kandidat.', 'candidate', NULL, 45, 'Ordinarie tisdagstid verifierad på butikens officiella sida.'),
('south-erikshjalpen-malmo', 'SOUTH', 'Erikshjälpen Second Hand Malmö', 'Sallerupsvägen 88', '212 28', 'Malmö', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://erikshjalpen.se/butiker/second-hand-malmo/', 'official_website', '2026-07-26', 'Stor butik med möbler, hem, kläder och kafé; mycket stark kandidat.', 'candidate', NULL, 60, 'Ordinarie tisdagstid verifierad på butikens officiella sida.'),
('south-myrorna-malmo-centrum', 'SOUTH', 'Myrorna Malmö centrum', 'Södra Förstadsgatan 74A', NULL, 'Malmö', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://www.myrorna.se/butiker/malmo/malmo-centrum/', 'official_website', '2026-07-26', 'Centralt stopp med kläder, inredning och prylar; bra kompletterande kandidat.', 'candidate', NULL, 35, 'Postnummer saknas i den verifierade butikssidan och lämnas därför tomt.'),
('south-bjorkafrihet-malmo-city', 'SOUTH', 'Björkåfrihet Malmö City', 'Södra Förstadsgatan 14', NULL, 'Malmö', NULL, NULL, '11:00', '19:00', 'verified_open', 'https://bjorkafrihet.se/oppettider-bjorkafrihet-second-hand-butiker/', 'official_website', '2026-07-26', 'Centralt second hand-stopp; relevant men sannolikt mer klädtyngt än de största lagerbutikerna.', 'candidate', NULL, 35, 'Sommartiden 1 juli–30 augusti är också 11:00–19:00 på vardagar.'),
('south-bjorkafrihet-heleneholm', 'SOUTH', 'Björkåfrihet Malmö Heleneholm', 'Lantmannagatan 59', NULL, 'Malmö', NULL, NULL, '10:00', '19:00', 'verified_open', 'https://english.bjorkafrihet.se/oppettider-bjorkafrihet-second-hand-butiker/', 'official_website', '2026-07-26', 'Större stadsdelsbutik och troligen bättre rundvärde än citybutiken; stark kandidat.', 'candidate', NULL, 45, 'Uppgifterna finns på organisationens officiella engelska butikssida.'),
('south-skane-stadsmission-mobilia', 'SOUTH', 'Skåne Stadsmission Second Hand Mobilia', 'Per Albin Hanssons väg 40', NULL, 'Malmö', NULL, NULL, '10:00', '20:00', 'verified_open', 'https://www.skanestadsmission.se/second-hand/', 'official_website', '2026-07-26', 'Kläder, barnvaror, leksaker och hemprylar; användbart kompletterande stopp.', 'candidate', NULL, 35, 'Butiken ligger i Mobilia, södra huset, plan 1.'),
('south-skane-stadsmission-triangeln', 'SOUTH', 'Skåne Stadsmission Second Hand Triangeln', 'Södra Förstadsgatan 41', NULL, 'Malmö', NULL, NULL, '10:00', '20:00', 'verified_open', 'https://www.skanestadsmission.se/second-hand/', 'official_website', '2026-07-26', 'Främst vintage, märkeskläder och accessoarer; villkorat stopp på grund av lägre matchning mot rundans huvudprofil.', 'conditional', NULL, 25, 'Butiken ligger i Triangelns köpcentrum, plan 2.'),
('south-ab-smaland-malmo', 'SOUTH', 'AB Småland', 'Södra Förstadsgatan 25-27', NULL, 'Malmö', NULL, NULL, '10:00', '18:00', 'verified_open', 'https://www.skanestadsmission.se/second-hand/', 'official_website', '2026-07-26', 'Design- och hållbarhetsinriktat stopp med second hand och REMAKE; villkorat på grund av svagare loppisprofil.', 'conditional', NULL, 30, 'Listas av Skåne Stadsmission som samarbetsbutik.');

COMMIT;
