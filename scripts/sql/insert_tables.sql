-- Drop tables if they exist
DROP TABLE IF EXISTS learns CASCADE;
DROP TABLE IF EXISTS move_has_type CASCADE;
DROP TABLE IF EXISTS move CASCADE;
DROP TABLE IF EXISTS pokemon_has_type CASCADE;
DROP TABLE IF EXISTS effective_against CASCADE;
DROP TABLE IF EXISTS type CASCADE;
DROP TABLE IF EXISTS pokemon CASCADE;
DROP TABLE IF EXISTS pokemon_roster CASCADE;
DROP TABLE IF EXISTS villain_bases CASCADE;
DROP TABLE IF EXISTS organization_goal CASCADE;
DROP TABLE IF EXISTS villain_organization CASCADE;
DROP TABLE IF EXISTS protagonist CASCADE;
DROP TABLE IF EXISTS gym_leader CASCADE;
DROP TABLE IF EXISTS villain CASCADE;
DROP TABLE IF EXISTS significant_trainer CASCADE;
DROP TABLE IF EXISTS in_game_location CASCADE;
DROP TABLE IF EXISTS region CASCADE;
DROP TABLE IF EXISTS game CASCADE;

-- Create first without foreign keys
CREATE TABLE pokemon (
   id INT PRIMARY KEY,
   pokemon_name VARCHAR(255) NOT NULL UNIQUE,
   category VARCHAR(255),
   evolution_item VARCHAR(255),
   catch_rate INT,
   region_name VARCHAR(255),
   from_id INT,
   CONSTRAINT fk_from_id FOREIGN KEY (from_id)
       REFERENCES pokemon(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE significant_trainer (
   name VARCHAR(255),
   age INT,
   PRIMARY KEY (name)
);

CREATE TABLE villain (
   name VARCHAR(255),
   villain_organization_name VARCHAR(255),
   PRIMARY KEY (name)
);

CREATE TABLE gym_leader (
   name VARCHAR(255),
   gym_location VARCHAR(255),
   gym_region VARCHAR(255),
   type VARCHAR(50),
   PRIMARY KEY (name)
);

CREATE TABLE protagonist (
   name VARCHAR(255),
   hometown_location VARCHAR(255),
   hometown_region VARCHAR(255),
   rival VARCHAR(255),
   PRIMARY KEY (name)
);

CREATE TABLE villain_organization (
   organization_name VARCHAR(255),
   leader VARCHAR(255) NOT NULL,
   PRIMARY KEY (organization_name)
);

CREATE TABLE organization_goal (
   leader VARCHAR(255),
   goal VARCHAR(255),
   PRIMARY KEY (leader)
);

CREATE TABLE villain_bases (
   organization_name VARCHAR(255),
   base_location VARCHAR(255),
   base_region VARCHAR(255),
   PRIMARY KEY (organization_name, base_location, base_region)
);

CREATE TABLE pokemon_roster (
   name VARCHAR(255),
   id INT,
   PRIMARY KEY (name, id)
);

CREATE TABLE type (
   type_name VARCHAR(50),
   PRIMARY KEY (type_name)
);

CREATE TABLE effective_against (
   strong_name VARCHAR(50),
   weak_name VARCHAR(50),
   PRIMARY KEY (strong_name, weak_name)
);

CREATE TABLE pokemon_has_type (
   id INT,
   type_name VARCHAR(50),
   PRIMARY KEY (id, type_name)
);

CREATE TABLE move_has_type (
   move_name VARCHAR(255),
   type_name VARCHAR(50),
   PRIMARY KEY (move_name, type_name)
);

CREATE TABLE move (
   move_name VARCHAR(255),
   power INT NOT NULL,
   pp INT NOT NULL,
   physical_contact BOOLEAN NOT NULL,
   category VARCHAR(50) NOT NULL,
   accuracy INT NOT NULL,
   PRIMARY KEY (move_name)
);

CREATE TABLE learns (
   move_name VARCHAR(255),
   id INT,
   PRIMARY KEY (move_name, id)
);

CREATE TABLE game (
   game_name VARCHAR(255),
   platform VARCHAR(255),
   release_year INT,
   PRIMARY KEY (game_name)
);

CREATE TABLE region (
   region_name VARCHAR(255),
   introduced_by_game VARCHAR(255),
   league VARCHAR(255),
   PRIMARY KEY (region_name)
);

CREATE TABLE in_game_location (
   in_game_location_name VARCHAR(255),
   region_name VARCHAR(255),
   PRIMARY KEY (in_game_location_name, region_name)
);

-- Add foreign key constraints
ALTER TABLE villain
ADD CONSTRAINT fk_significant_trainer FOREIGN KEY (name)
    REFERENCES significant_trainer(name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_villain_organization FOREIGN KEY (villain_organization_name)
    REFERENCES villain_organization(organization_name) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE gym_leader
ADD CONSTRAINT fk_significant_trainer FOREIGN KEY (name)
    REFERENCES significant_trainer(name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_in_game_location FOREIGN KEY (gym_location, gym_region)
    REFERENCES in_game_location(in_game_location_name, region_name) ON DELETE SET NULL ON UPDATE CASCADE,
ADD CONSTRAINT fk_type FOREIGN KEY (type)
    REFERENCES type(type_name) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE protagonist
ADD CONSTRAINT fk_significant_trainer FOREIGN KEY (name)
    REFERENCES significant_trainer(name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_hometown FOREIGN KEY (hometown_location, hometown_region)
    REFERENCES in_game_location(in_game_location_name, region_name) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE villain_organization
ADD CONSTRAINT fk_villain FOREIGN KEY (leader)
    REFERENCES villain(name) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE organization_goal
ADD CONSTRAINT fk_villain FOREIGN KEY (leader)
    REFERENCES villain(name) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE villain_bases
ADD CONSTRAINT fk_villain_organization FOREIGN KEY (organization_name)
    REFERENCES villain_organization(organization_name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_base_location FOREIGN KEY (base_location, base_region)
    REFERENCES in_game_location(in_game_location_name, region_name) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pokemon_roster
ADD CONSTRAINT fk_significant_trainer FOREIGN KEY (name)
    REFERENCES significant_trainer(name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_pokemon_id FOREIGN KEY (id)
    REFERENCES pokemon(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE effective_against
ADD CONSTRAINT fk_strong_name FOREIGN KEY (strong_name)
    REFERENCES type(type_name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_weak_name FOREIGN KEY (weak_name)
    REFERENCES type(type_name) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pokemon_has_type
ADD CONSTRAINT fk_pokemon_id FOREIGN KEY (id)
    REFERENCES pokemon(id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_type_name FOREIGN KEY (type_name)
    REFERENCES type(type_name) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE move_has_type
ADD CONSTRAINT fk_move_name FOREIGN KEY (move_name)
    REFERENCES move(move_name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_type_name FOREIGN KEY (type_name)
    REFERENCES type(type_name) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE learns
ADD CONSTRAINT fk_move_name FOREIGN KEY (move_name)
    REFERENCES move(move_name) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_pokemon_id FOREIGN KEY (id)
    REFERENCES pokemon(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE region
ADD CONSTRAINT fk_game_name FOREIGN KEY (introduced_by_game)
    REFERENCES game(game_name) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE in_game_location
ADD CONSTRAINT fk_region_name FOREIGN KEY (region_name)
    REFERENCES region(region_name) ON DELETE CASCADE ON UPDATE CASCADE;

-- types
INSERT INTO type (type_name) VALUES 
('None'),
('Normal'),
('Fire'),
('Water'),
('Electric'),
('Grass'),
('Ice'),
('Fighting'),
('Poison'),
('Ground'),
('Flying'),
('Psychic'),
('Bug'),
('Rock'),
('Ghost'),
('Dragon'),
('Dark'),
('Steel'),
('Fairy');

-- effective against
INSERT INTO effective_against (strong_name, weak_name) VALUES 
-- Normal
('Normal', 'None'),

-- Fire
('Fire', 'Grass'),
('Fire', 'Ice'),
('Fire', 'Bug'),
('Fire', 'Steel'),

-- Water
('Water', 'Fire'),
('Water', 'Ground'),
('Water', 'Rock'),

-- Electric
('Electric', 'Water'),
('Electric', 'Flying'),

-- Grass
('Grass', 'Water'),
('Grass', 'Ground'),
('Grass', 'Rock'),

-- Ice
('Ice', 'Grass'),
('Ice', 'Ground'),
('Ice', 'Flying'),
('Ice', 'Dragon'),

-- Fighting
('Fighting', 'Normal'),
('Fighting', 'Ice'),
('Fighting', 'Rock'),
('Fighting', 'Dark'),
('Fighting', 'Steel'),

-- Poison
('Poison', 'Grass'),
('Poison', 'Fairy'),

-- Ground
('Ground', 'Fire'),
('Ground', 'Electric'),
('Ground', 'Poison'),
('Ground', 'Rock'),
('Ground', 'Steel'),

-- Flying
('Flying', 'Grass'),
('Flying', 'Fighting'),
('Flying', 'Bug'),

-- Psychic
('Psychic', 'Fighting'),
('Psychic', 'Poison'),

-- Bug
('Bug', 'Grass'),
('Bug', 'Psychic'),
('Bug', 'Dark'),

-- Rock
('Rock', 'Fire'),
('Rock', 'Ice'),
('Rock', 'Flying'),
('Rock', 'Bug'),

-- Ghost
('Ghost', 'Psychic'),
('Ghost', 'Ghost'),

-- Dragon
('Dragon', 'Dragon'),

-- Dark
('Dark', 'Psychic'),
('Dark', 'Ghost'),

-- Steel
('Steel', 'Ice'),
('Steel', 'Rock'),
('Steel', 'Fairy'),

-- Fairy
('Fairy', 'Fighting'),
('Fairy', 'Dragon'),
('Fairy', 'Dark');

INSERT INTO significant_trainer(name, age) VALUES ('Red', 11);
INSERT INTO significant_trainer(name, age) VALUES ('Misty', 10);
INSERT INTO significant_trainer(name, age) VALUES ('Brock', 15);
INSERT INTO significant_trainer(name, age) VALUES ('Giovanni', NULL);
INSERT INTO significant_trainer(name, age) VALUES ('James', 25);
INSERT INTO significant_trainer(name, age) VALUES ('Ash', 10);
INSERT INTO significant_trainer(name, age) VALUES ('Maxie', NULL);

-- Circular dependency
INSERT INTO villain (name, villain_organization_name) VALUES ('Giovanni', NULL);
INSERT INTO villain_organization (organization_name, leader) VALUES ('Team Rocket', 'Giovanni');
UPDATE villain
SET villain_organization_name = 'Team Rocket'
WHERE name = 'Giovanni';

INSERT INTO villain (name, villain_organization_name) VALUES ('Maxie', NULL);
INSERT INTO villain_organization (organization_name, leader) VALUES ('Team Magma', 'Maxie');
UPDATE villain
SET villain_organization_name = 'Team Magma'
WHERE name = 'Maxie';

INSERT INTO organization_goal (leader, goal) VALUES ('Giovanni', 'Steal and exploit pokemon for profit, world domination');
INSERT INTO organization_goal (leader, goal) VALUES ('Maxie', 'Expand the amount of landmass in the world');

INSERT INTO villain (name, villain_organization_name) VALUES ('James', 'Team Rocket');

INSERT INTO game (game_name, platform, release_year) VALUES ('Pokemon Red', 'Gameboy', 1996);
INSERT INTO game (game_name, platform, release_year) VALUES ('Pokemon Gold', 'Gameboy Colour', 1999);
INSERT INTO game (game_name, platform, release_year) VALUES ('Pokemon Ruby', 'Gameboy Advance', 2002);
INSERT INTO game (game_name, platform, release_year) VALUES ('Pokemon Shining Pearl', 'Nintendo Switch', 2021);
INSERT INTO game (game_name, platform, release_year) VALUES ('Pokemon Violet', 'Nintendo Switch', 2022);

INSERT INTO region (region_name, introduced_by_game, league) VALUES ('Kanto', 'Pokemon Red', 'Indigo League');
INSERT INTO region (region_name, introduced_by_game, league) VALUES ('Hoenn', 'Pokemon Ruby', 'Johto League');

INSERT INTO in_game_location (in_game_location_name, region_name) VALUES ('Pewter City', 'Kanto');
INSERT INTO in_game_location (in_game_location_name, region_name) VALUES ('Cerulean City', 'Kanto');
INSERT INTO in_game_location(in_game_location_name, region_name) VALUES ('Pallet Town', 'Kanto');
INSERT INTO in_game_location(in_game_location_name, region_name) VALUES ('Mahogany Town', 'Kanto');
INSERT INTO in_game_location(in_game_location_name, region_name) VALUES ('Lilycove City', 'Hoenn');

INSERT INTO villain_bases(organization_name, base_location, base_region) VALUES ('Team Rocket', 'Mahogany Town', 'Kanto');
INSERT INTO villain_bases(organization_name, base_location, base_region) VALUES ('Team Magma', 'Lilycove City', 'Hoenn');

INSERT INTO gym_leader (name, gym_location, gym_region, type) VALUES ('Brock', 'Pewter City', 'Kanto', 'Rock');
INSERT INTO gym_leader (name, gym_location, gym_region, type) VALUES ('Misty', 'Cerulean City', 'Kanto', 'Water');

INSERT INTO protagonist (name, hometown_location, hometown_region, rival) VALUES ('Red', 'Pallet Town', 'Kanto', 'Blue');
INSERT INTO protagonist (name, hometown_location, hometown_region, rival) VALUES ('Ash', 'Pallet Town', 'Kanto', 'Gary');

INSERT INTO pokemon (id, pokemon_name, category, evolution_item, catch_rate, region_name, from_id) VALUES 
(1, 'Bulbasaur', 'Seed', NULL, 45, 'Kanto', NULL),
(2, 'Ivysaur', 'Seed', NULL, 45, 'Kanto', 1),
(3, 'Venusaur', 'Seed', NULL, 45, 'Kanto', 2),
(4, 'Charmander', 'Lizard', NULL, 45, 'Kanto', NULL),
(5, 'Charmeleon', 'Flame', NULL, 45, 'Kanto', 4),
(6, 'Charizard', 'Flame', NULL, 45, 'Kanto', 5),
(7, 'Squirtle', 'Tiny Turtle', NULL, 45, 'Kanto', NULL),
(8, 'Wartortle', 'Turtle', NULL, 45, 'Kanto', 7),
(9, 'Blastoise', 'Shellfish', NULL, 45, 'Kanto', 8),
(10, 'Caterpie', 'Worm', NULL, 255, 'Kanto', NULL),
(11, 'Metapod', 'Cocoon', NULL, 120, 'Kanto', 10),
(12, 'Butterfree', 'Butterfly', NULL, 45, 'Kanto', 11),
(13, 'Weedle', 'Hairy Bug', NULL, 255, 'Kanto', NULL),
(14, 'Kakuna', 'Cocoon', NULL, 120, 'Kanto', 13),
(15, 'Beedrill', 'Poison Bee', NULL, 45, 'Kanto', 14),
(16, 'Pidgey', 'Tiny Bird', NULL, 255, 'Kanto', NULL),
(17, 'Pidgeotto', 'Bird', NULL, 120, 'Kanto', 16),
(18, 'Pidgeot', 'Bird', NULL, 45, 'Kanto', 17),
(19, 'Rattata', 'Mouse', NULL, 255, 'Kanto', NULL),
(20, 'Raticate', 'Mouse', NULL, 127, 'Kanto', 19),
(21, 'Spearow', 'Tiny Bird', NULL, 255, 'Kanto', NULL),
(22, 'Fearow', 'Beak', NULL, 90, 'Kanto', 21),
(23, 'Ekans', 'Snake', NULL, 255, 'Kanto', NULL),
(24, 'Arbok', 'Cobra', NULL, 90, 'Kanto', 23),
(25, 'Pikachu', 'Mouse', NULL, 190, 'Kanto', NULL),
(26, 'Raichu', 'Mouse', NULL, 75, 'Kanto', 25),
(27, 'Sandshrew', 'Mouse', NULL, 255, 'Kanto', NULL),
(28, 'Sandslash', 'Mouse', NULL, 90, 'Kanto', 27),
(29, 'Nidoran♀', 'Poison Pin', NULL, 235, 'Kanto', NULL),
(30, 'Nidorina', 'Poison Pin', NULL, 120, 'Kanto', 29),
(31, 'Nidoqueen', 'Drill', NULL, 45, 'Kanto', 30),
(32, 'Nidoran♂', 'Poison Pin', NULL, 235, 'Kanto', NULL),
(33, 'Nidorino', 'Poison Pin', NULL, 120, 'Kanto', 32),
(34, 'Nidoking', 'Drill', NULL, 45, 'Kanto', 33),
(35, 'Clefairy', 'Fairy', NULL, 150, 'Kanto', NULL),
(36, 'Clefable', 'Fairy', NULL, 25, 'Kanto', 35),
(37, 'Vulpix', 'Fox', NULL, 190, 'Kanto', NULL),
(38, 'Ninetales', 'Fox', NULL, 75, 'Kanto', 37),
(39, 'Jigglypuff', 'Balloon', NULL, 170, 'Kanto', NULL),
(40, 'Wigglytuff', 'Balloon', NULL, 50, 'Kanto', 39),
(41, 'Zubat', 'Bat', NULL, 255, 'Kanto', NULL),
(42, 'Golbat', 'Bat', NULL, 90, 'Kanto', 41),
(43, 'Oddish', 'Weed', NULL, 255, 'Kanto', NULL),
(44, 'Gloom', 'Weed', NULL, 120, 'Kanto', 43),
(45, 'Vileplume', 'Flower', NULL, 45, 'Kanto', 44),
(46, 'Paras', 'Mushroom', NULL, 190, 'Kanto', NULL),
(47, 'Parasect', 'Mushroom', NULL, 75, 'Kanto', 46),
(48, 'Venonat', 'Insect', NULL, 190, 'Kanto', NULL),
(49, 'Venomoth', 'Poison Moth', NULL, 75, 'Kanto', 48),
(50, 'Diglett', 'Mole', NULL, 255, 'Kanto', NULL),
(120, 'Staryu', 'Star Shape', NULL, 225, 'Kanto', NULL),
(121, 'Starmie', 'Mysterious', NULL, 60, 'Kanto', 120),
(95, 'Onix', 'Rock Snake', NULL, 45, 'Kanto', NULL),
(109, 'Koffing', 'Poison Gas', NULL, 190, 'Kanto', NULL),
(110, 'Weezing', 'Poison Gas', NULL, 60, 'Kanto', 109)
(152, 'Chikorita', 'Leaf', NULL, 45, 'Johto', NULL),
(153, 'Bayleef', 'Herb', NULL, 45, 'Johto', 152),
(154, 'Meganium', 'Herb', NULL, 45, 'Johto', 153),
(155, 'Cyndaquil', 'Fire Mouse', NULL, 45, 'Johto', NULL),
(156, 'Quilava', 'Fire', NULL, 45, 'Johto', 155),
(157, 'Typhlosion', 'Volcano', NULL, 45, 'Johto', 156),
(158, 'Totodile', 'Big Jaw', NULL, 45, 'Johto', NULL),
(159, 'Croconaw', 'Big Jaw', NULL, 45, 'Johto', 158),
(160, 'Feraligatr', 'Big Jaw', NULL, 45, 'Johto', 159),
(161, 'Sentret', 'Scout', NULL, 255, 'Johto', NULL),
(162, 'Furret', 'Long Body', NULL, 127, 'Johto', 161),
(163, 'Hoothoot', 'Owl', NULL, 255, 'Johto', NULL),
(164, 'Noctowl', 'Owl', NULL, 90, 'Johto', 163),
(165, 'Ledyba', 'Five Star', NULL, 255, 'Johto', NULL),
(166, 'Ledian', 'Five Star', NULL, 90, 'Johto', 165),
(167, 'Spinarak', 'String Spit', NULL, 255, 'Johto', NULL),
(168, 'Ariados', 'String Spit', NULL, 90, 'Johto', 167)
(252, 'Treecko', 'Wood Gecko', NULL, 45, 'Hoenn', NULL),
(253, 'Grovyle', 'Wood Gecko', NULL, 45, 'Hoenn', 252),
(254, 'Sceptile', 'Forest', NULL, 45, 'Hoenn', 253),
(255, 'Torchic', 'Chick', NULL, 45, 'Hoenn', NULL),
(256, 'Combusken', 'Blaze', NULL, 45, 'Hoenn', 255),
(257, 'Blaziken', 'Blaze', NULL, 45, 'Hoenn', 256),
(258, 'Mudkip', 'Mud Fish', NULL, 45, 'Hoenn', NULL),
(259, 'Marshtomp', 'Mud Fish', NULL, 45, 'Hoenn', 258),
(260, 'Swampert', 'Mud Fish', NULL, 45, 'Hoenn', 259),
(261, 'Zigzagoon', 'Tiny Raccoon', NULL, 255, 'Hoenn', NULL),
(262, 'Linoone', 'Raccoon', NULL, 90, 'Hoenn', 261),
(263, 'Wurmple', 'Worm', NULL, 255, 'Hoenn', NULL),
(264, 'Silcoon', 'Cocoon', NULL, 120, 'Hoenn', 263),
(265, 'Beautifly', 'Butterfly', NULL, 45, 'Hoenn', 264),
(266, 'Cascoon', 'Cocoon', NULL, 120, 'Hoenn', 263),
(267, 'Dustox', 'Poison Moth', NULL, 45, 'Hoenn', 266)
(387, 'Turtwig', 'Tiny Leaf', NULL, 45, 'Sinnoh', NULL),
(388, 'Grotle', 'Forest', NULL, 45, 'Sinnoh', 387),
(389, 'Torterra', 'Continent', NULL, 45, 'Sinnoh', 388),
(390, 'Chimchar', 'Chimp', NULL, 45, 'Sinnoh', NULL),
(391, 'Monferno', 'Flame', NULL, 45, 'Sinnoh', 390),
(392, 'Infernape', 'Flame', NULL, 45, 'Sinnoh', 391),
(393, 'Piplup', 'Penguin', NULL, 45, 'Sinnoh', NULL),
(394, 'Prinplup', 'Penguin', NULL, 45, 'Sinnoh', 393),
(395, 'Empoleon', 'Penguin', NULL, 45, 'Sinnoh', 394),
(398, 'Starly', 'Starling', NULL, 255, 'Sinnoh', NULL),
(399, 'Staravia', 'Starling', NULL, 120, 'Sinnoh', 398),
(400, 'Staraptor', 'Starling', NULL, 45, 'Sinnoh', 399),
(406, 'Budew', 'Flower', NULL, 255, 'Sinnoh', NULL),
(407, 'Roselia', 'Flower', NULL, 120, 'Sinnoh', 406),
(408, 'Roserade', 'Bouquet', NULL, 45, 'Sinnoh', 407)
(495, 'Snivy', 'Grass Snake', NULL, 45, 'Unova', NULL),
(496, 'Servine', 'Serpentine', NULL, 45, 'Unova', 495),
(497, 'Serperior', 'Regal Snake', NULL, 45, 'Unova', 496),
(498, 'Tepig', 'Fire Pig', NULL, 45, 'Unova', NULL),
(499, 'Pignite', 'Fire Pig', NULL, 45, 'Unova', 498),
(500, 'Emboar', 'Fire Pig', NULL, 45, 'Unova', 499),
(501, 'Oshawott', 'Sea Otter', NULL, 45, 'Unova', NULL),
(502, 'Dewott', 'Discipline', NULL, 45, 'Unova', 501),
(503, 'Samurott', 'Formidable', NULL, 45, 'Unova', 502),
(510, 'Lillipup', 'Dog', NULL, 255, 'Unova', NULL),
(511, 'Herdier', 'Dog', NULL, 120, 'Unova', 510),
(512, 'Stoutland', 'Big-Hearted', NULL, 45, 'Unova', 511),
(521, 'Blitzle', 'Thunder', NULL, 255, 'Unova', NULL),
(522, 'Zebstrika', 'Thunder', NULL, 90, 'Unova', 521),
(523, 'Roggenrola', 'Rock', NULL, 255, 'Unova', NULL),
(524, 'Boldore', 'Ore', NULL, 120, 'Unova', 523),
(525, 'Gigalith', 'Mineral', NULL, 45, 'Unova', 524);

-- Insert example data into pokemon_roster table
-- James
INSERT INTO pokemon_roster (name, id) VALUES 
('James', 23),  -- Ekans
('James', 24),  -- Arbok
('James', 109),  -- Koffing
('James', 110);  -- Weezing

-- Giovanni
INSERT INTO pokemon_roster (name, id) VALUES 
('Giovanni', 34),  -- Nidoking
('Giovanni', 24);  -- Arbok

-- Misty
INSERT INTO pokemon_roster (name, id) VALUES 
('Misty', 120),  -- Staryu
('Misty', 121);  -- Starmie

-- Brock
INSERT INTO pokemon_roster (name, id) VALUES 
('Brock', 95);  -- Onix

-- Ash
INSERT INTO pokemon_roster (name, id) VALUES 
('Ash', 1),  -- Bulbasaur
('Ash', 4),  -- Charmander
('Ash', 7),  -- Squirtle
('Ash', 25), -- Pikachu
('Ash', 121); -- Starmie

-- Professor Oak
INSERT INTO pokemon_roster (name, id) VALUES 
('Oak', 25),    -- Pikachu
('Oak', 1),     -- Bulbasaur
('Oak', 4),     -- Charmander
('Oak', 7),     -- Squirtle
('Oak', 151);   -- Mew

-- May 
INSERT INTO pokemon_roster (name, id) VALUES 
('May', 252),   -- Treecko
('May', 255),   -- Torchic
('May', 258),   -- Mudkip
('May', 319),   -- Sharpedo
('May', 328),   -- Trapinch
('May', 334);   -- Altaria

-- Brendan
INSERT INTO pokemon_roster (name, id) VALUES 
('Brendan', 252),   -- Treecko
('Brendan', 255),   -- Torchic
('Brendan', 258),   -- Mudkip
('Brendan', 295),   -- Roselia
('Brendan', 319),   -- Sharpedo
('Brendan', 334);   -- Altaria

-- Insert example data into pokemon_has_type table
INSERT INTO pokemon_has_type (id, type_name) VALUES
(1, 'Grass'), (1, 'Poison'),
(2, 'Grass'), (2, 'Poison'),
(3, 'Grass'), (3, 'Poison'),
(4, 'Fire'),
(5, 'Fire'),
(6, 'Fire'), (6, 'Flying'),
(7, 'Water'),
(8, 'Water'),
(9, 'Water'),
(10, 'Bug'),
(11, 'Bug'),
(12, 'Bug'), (12, 'Flying'),
(13, 'Bug'), (13, 'Poison'),
(14, 'Bug'), (14, 'Poison'),
(15, 'Bug'), (15, 'Poison'),
(16, 'Normal'), (16, 'Flying'),
(17, 'Normal'), (17, 'Flying'),
(18, 'Normal'), (18, 'Flying'),
(19, 'Normal'),
(20, 'Normal'),
(21, 'Normal'), (21, 'Flying'),
(22, 'Normal'), (22, 'Flying'),
(23, 'Poison'),
(24, 'Poison'),
(25, 'Electric'),
(26, 'Electric'),
(27, 'Ground'),
(28, 'Ground'),
(29, 'Poison'),
(30, 'Poison'),
(31, 'Poison'), (31, 'Ground'),
(32, 'Poison'),
(33, 'Poison'),
(34, 'Poison'), (34, 'Ground'),
(35, 'Fairy'),
(36, 'Fairy'),
(37, 'Fire'),
(38, 'Fire'),
(39, 'Normal'), (39, 'Fairy'),
(40, 'Normal'), (40, 'Fairy'),
(41, 'Poison'), (41, 'Flying'),
(42, 'Poison'), (42, 'Flying'),
(43, 'Grass'), (43, 'Poison'),
(44, 'Grass'), (44, 'Poison'),
(45, 'Grass'), (45, 'Poison'),
(46, 'Bug'), (46, 'Grass'),
(47, 'Bug'), (47, 'Grass'),
(48, 'Bug'), (48, 'Poison'),
(49, 'Bug'), (49, 'Poison'),
(50, 'Ground'),
(152, 'Grass'),
(153, 'Grass'),
(154, 'Grass'),
(155, 'Fire'),
(156, 'Fire'),
(157, 'Fire'),
(158, 'Water'),
(159, 'Water'),
(160, 'Water'),
(161, 'Normal'),
(162, 'Normal'),
(163, 'Normal'),
(164, 'Normal'),
(165, 'Bug'),
(166, 'Bug'),
(167, 'Bug'),
(168, 'Bug'),
(252, 'Grass'),
(253, 'Grass'),
(254, 'Grass'),
(255, 'Fire'),
(256, 'Fire'),
(257, 'Fire'),
(258, 'Water'),
(259, 'Water'),
(260, 'Water'),
(261, 'Normal'),
(262, 'Normal'),
(263, 'Bug'),
(264, 'Bug'),
(265, 'Bug'),
(266, 'Bug'),
(267, 'Bug'),
(387, 'Grass'),
(388, 'Grass'),
(389, 'Grass'),
(390, 'Fire'),
(391, 'Fire'),
(392, 'Fire'),
(393, 'Water'),
(394, 'Water'),
(395, 'Water'),
(398, 'Normal'), (398, 'Flying'),
(399, 'Normal'), (399, 'Flying'),
(400, 'Normal'), (400, 'Flying'),
(406, 'Grass'), (406, 'Poison'),
(407, 'Grass'), (407, 'Poison'),
(408, 'Grass'), (408, 'Poison'),
(495, 'Grass'),
(496, 'Grass'),
(497, 'Grass'),
(498, 'Fire'),
(499, 'Fire'),
(500, 'Fire'),
(501, 'Water'),
(502, 'Water'),
(503, 'Water'),
(510, 'Normal'),
(511, 'Normal'),
(512, 'Normal'),
(521, 'Electric'),
(522, 'Electric'),
(523, 'Rock'),
(524, 'Rock'),
(525, 'Rock');

INSERT INTO move (move_name, power, pp, physical_contact, category, accuracy) VALUES 
('Tackle', 40, 35, TRUE, 'Physical', 100),
('Vine Whip', 45, 25, TRUE, 'Physical', 100),
('Ember', 40, 25, TRUE, 'Special', 100),
('Water Gun', 40, 25, TRUE, 'Special', 100),
('Thunder Shock', 40, 30, TRUE, 'Special', 100),
('Scratch', 40, 35, TRUE, 'Physical', 100),
('Poison Gas', 0, 40, FALSE, 'Status', 90),
('Rock Throw', 50, 15, TRUE, 'Physical', 90),
('Bubble Beam', 65, 20, TRUE, 'Special', 100),
('Psychic', 90, 10, FALSE, 'Special', 100),
('Hyper Beam', 150, 5, FALSE, 'Special', 90),
('Dragon Rage', 0, 10, FALSE, 'Special', 100);

INSERT INTO move_has_type (move_name, type_name) VALUES 
('Tackle', 'Normal'),
('Vine Whip', 'Grass'),
('Ember', 'Fire'),
('Water Gun', 'Water'),
('Thunder Shock', 'Electric'),
('Scratch', 'Normal'),
('Poison Gas', 'Poison'),
('Rock Throw', 'Rock'),
('Bubble Beam', 'Water'),
('Psychic', 'Psychic'),
('Hyper Beam', 'Normal'),
('Dragon Rage', 'Dragon');

-- Insert example data into learns table
-- Bulbasaur
INSERT INTO learns (move_name, id) VALUES 
('Tackle', 1),
('Vine Whip', 1);

-- Charmander
INSERT INTO learns (move_name, id) VALUES 
('Scratch', 4),
('Ember', 4);

-- Squirtle
INSERT INTO learns (move_name, id) VALUES 
('Tackle', 7),
('Water Gun', 7);

-- Pikachu
INSERT INTO learns (move_name, id) VALUES 
('Thunder Shock', 25);

-- Pidgeot
INSERT INTO learns (move_name, id) VALUES 
('Tackle', 18);
