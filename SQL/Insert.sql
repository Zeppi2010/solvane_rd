USE solvane_rd;
-- Facilities
INSERT INTO Facilities (Name, Region, Type) VALUES
('Stormgaard 1', 'Stormgaard', 'Aerodynamics and Avionics'),
('Drayseria 1', 'Drayseria', 'Naval Engineering'),
('Soleria 1', 'Solvane Central Plateau', 'Civilian'),
('Karathi 1', 'Karathi', 'Land Warfare');

-- Scientists (diverse names, type matches facility)
INSERT INTO Scientists (Name, FacilityID, Type) VALUES
('Erik Stormveld', 1, 'Aerodynamics and Avionics'),
('Hilde Bauer', 1, 'Aerodynamics and Avionics'),
('Kenji Nakamura', 1, 'Aerodynamics and Avionics'),
('Lars Dawnmere', 2, 'Naval Engineering'),
('Sigrid Halvorsen', 2, 'Naval Engineering'),
('Wei Zhang', 2, 'Naval Engineering'),
('Bjorn Aldrath', 3, 'Civilian'),
('Astrid Müller', 3, 'Civilian'),
('Yuna Park', 3, 'Civilian'),
('Ragnar Kolvik', 4, 'Land Warfare'),
('Gertrude Eisenberg', 4, 'Land Warfare'),
('Tariq Al-Rashid', 4, 'Land Warfare');

-- Testers (diverse names, type matches facility)
INSERT INTO Testers (Name, FacilityID, Type) VALUES
('Gunnar Vestergaard', 1, 'Aerodynamics and Avionics'),
('Ingrid Solmund', 1, 'Aerodynamics and Avionics'),
('Ulf Brynjarsson', 2, 'Naval Engineering'),
('Mei-Lin Chen', 2, 'Naval Engineering'),
('Thyra Fenwick', 3, 'Civilian'),
('Otto Steinberg', 3, 'Civilian'),
('Leif Haldvard', 4, 'Land Warfare'),
('Sven Moritz', 4, 'Land Warfare');

-- Projects
INSERT INTO Projects (Name, FacilityID, Version, Changes, Type) VALUES
('Project Grimm', 1, 1, 'Initial design of variable sweep wing mechanism begun', 'Aerodynamics and Avionics'),
('Project Wraith', 1, 1, 'Preliminary stealth rotor blade research initiated', 'Aerodynamics and Avionics'),
('Project Hearthstone', 3, 1, 'Feasibility study for modular reactor core started', 'Civilian'),
('Project Leviathan', 2, 1, 'Submarine carrier hull design and submerged launch system conceptualised', 'Naval Engineering'),
('Project Thunderline', 4, 1, 'Electromagnetic rail propulsion research begun', 'Land Warfare'),
('Project Ironstrider', 4, 1, 'Theoretical framework for bipedal armoured platform established', 'Land Warfare');

-- Assign Scientist
INSERT INTO ScientistProjects (ScientistID, ProjectID) VALUES
(1, 1),  -- Erik Stormveld -> Grimm
(3, 1),  -- Kenji Nakamura -> Grimm
(2, 2),  -- Hilde Bauer -> Wraith
(1, 2),  -- Erik Stormveld -> Wraith
(7, 3),  -- Bjorn Aldrath -> Hearthstone
(9, 3),  -- Yuna Park -> Hearthstone
(8, 3),  -- Astrid Müller -> Hearthstone
(4, 4),  -- Lars Dawnmere -> Leviathan
(5, 4),  -- Sigrid Halvorsen -> Leviathan
(6, 4),  -- Wei Zhang -> Leviathan
(10, 5), -- Ragnar Kolvik -> Thunderline
(12, 5), -- Tariq Al-Rashid -> Thunderline
(11, 6); -- Gertrude Eisenberg -> Ironstrider

-- Assign Tester
INSERT INTO TesterProjects (TesterID, ProjectID) VALUES
(1, 1),  -- Gunnar Vestergaard -> Grimm
(2, 2),  -- Ingrid Solmund -> Wraith
(5, 3),  -- Thyra Fenwick -> Hearthstone
(6, 3),  -- Otto Steinberg -> Hearthstone
(3, 4),  -- Ulf Brynjarsson -> Leviathan
(4, 4),  -- Mei-Lin Chen -> Leviathan
(7, 5);  -- Leif Haldvard -> Thunderline
