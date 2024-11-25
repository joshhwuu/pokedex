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
(10, 'Pikachu', 'Mouse', NULL, 190, 'Kanto', NULL),
(11, 'Raichu', 'Mouse', NULL, 75, 'Kanto', 10),
(12, 'Meowth', 'Scratch Cat', NULL, 255, 'Kanto', NULL),
(13, 'Koffing', 'Poison Gas', NULL, 190, 'Kanto', NULL),
(14, 'Weezing', 'Poison Gas', NULL, 60, 'Kanto', 13),
(15, 'Onix', 'Rock Snake', NULL, 45, 'Kanto', NULL),
(16, 'Staryu', 'Star Shape', NULL, 225, 'Kanto', NULL),
(17, 'Starmie', 'Mysterious', NULL, 60, 'Kanto', 16),
(18, 'Gyarados', 'Atrocious', NULL, 45, 'Kanto', NULL),
(19, 'Nidoking', 'Drill', NULL, 45, 'Kanto', NULL),
(20, 'Arbok', 'Cobra', NULL, 90, 'Kanto', NULL),
(21, 'Pidgeot', 'Bird', NULL, 45, 'Kanto', NULL),
(22, 'Alakazam', 'Psi', NULL, 50, 'Kanto', NULL),
(23, 'Rhydon', 'Drill', NULL, 45, 'Kanto', NULL),
(24, 'Machamp', 'Superpower', NULL, 45, 'Kanto', NULL),
(25, 'Gengar', 'Shadow', NULL, 45, 'Kanto', NULL),
(26, 'Dragonite', 'Dragon', NULL, 45, 'Kanto', NULL);

-- Insert example data into pokemon_roster table
-- James
INSERT INTO pokemon_roster (name, id) VALUES 
('James', 12),  -- Meowth
('James', 13),  -- Koffing
('James', 14);  -- Weezing

-- Giovanni
INSERT INTO pokemon_roster (name, id) VALUES 
('Giovanni', 19),  -- Nidoking
('Giovanni', 20);  -- Arbok

-- Misty
INSERT INTO pokemon_roster (name, id) VALUES 
('Misty', 16),  -- Staryu
('Misty', 17),  -- Starmie
('Misty', 18);  -- Gyarados

-- Brock
INSERT INTO pokemon_roster (name, id) VALUES 
('Brock', 15);  -- Onix

-- Ash
INSERT INTO pokemon_roster (name, id) VALUES 
('Ash', 1),  -- Bulbasaur
('Ash', 4),  -- Charmander
('Ash', 7),  -- Squirtle
('Ash', 10); -- Pikachu

-- Red
INSERT INTO pokemon_roster (name, id) VALUES 
('Red', 21),  -- Pidgeot
('Red', 22),  -- Alakazam
('Red', 23),  -- Rhydon
('Red', 24),  -- Machamp
('Red', 25),  -- Gengar
('Red', 26);  -- Dragonite

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
(10, 'Electric'),
(11, 'Electric'),
(12, 'Normal'),
(13, 'Poison'),
(14, 'Poison'),
(15, 'Rock'), (15, 'Ground'),
(16, 'Water'),
(17, 'Water'), (17, 'Psychic'),
(18, 'Water'), (18, 'Flying'),
(19, 'Poison'), (19, 'Ground'),
(20, 'Poison'),
(21, 'Normal'), (21, 'Flying'),
(22, 'Psychic'),
(23, 'Ground'), (23, 'Rock'),
(24, 'Fighting'),
(25, 'Ghost'), (25, 'Poison'),
(26, 'Dragon'), (26, 'Flying');

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
('Thunder Shock', 10);

-- Meowth
INSERT INTO learns (move_name, id) VALUES 
('Scratch', 12);

-- Koffing
INSERT INTO learns (move_name, id) VALUES 
('Poison Gas', 13);

-- Onix
INSERT INTO learns (move_name, id) VALUES 
('Rock Throw', 15);

-- Staryu
INSERT INTO learns (move_name, id) VALUES 
('Water Gun', 16);

-- Starmie
INSERT INTO learns (move_name, id) VALUES 
('Bubble Beam', 17),
('Psychic', 17);

-- Gyarados
INSERT INTO learns (move_name, id) VALUES 
('Hyper Beam', 18);

-- Nidoking
INSERT INTO learns (move_name, id) VALUES 
('Poison Gas', 19);

-- Arbok
INSERT INTO learns (move_name, id) VALUES 
('Poison Gas', 20);

-- Pidgeot
INSERT INTO learns (move_name, id) VALUES 
('Tackle', 21);

-- Alakazam
INSERT INTO learns (move_name, id) VALUES 
('Psychic', 22);

-- Rhydon
INSERT INTO learns (move_name, id) VALUES 
('Rock Throw', 23);

-- Machamp
INSERT INTO learns (move_name, id) VALUES 
('Tackle', 24);

-- Gengar
INSERT INTO learns (move_name, id) VALUES 
('Psychic', 25);

-- Dragonite
INSERT INTO learns (move_name, id) VALUES 
('Dragon Rage', 26);