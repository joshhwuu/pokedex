-- 2.1.1 Implement INSERT on one relation
-- insert into pokemon table
INSERT INTO pokemon(
id, 
pokemon_name, 
category, 
evolution_item,
catch_rate, 
region_name, 
from_id
) 
VALUES (${pokeId}, ${pokeName}, ${pokeCategory}, ${pokeEvoItem}, ${pokeCatch}, ${pokeRegion}, ${pokeFromId})

-- insert into the type if it's new
INSERT INTO type(type_name)
VALUES(${pokeType}) 
ON CONFLICT DO NOTHING;


INSERT INTO pokemon_has_type (id, type_name)
VALUES (:pokeID, :pokeType);

-- 2.1.2 Implement UPDATE on one relation
-- Update onto the pokemon table
UPDATE Pokemon
SET pokemon_name = :pokeName, category = :pokeCategory, catch_rate = :pokeCatch, region_name = :pokeRegion, from_id = :pokeFromId;
WHERE id = :pokeId;

DELETE FROM pokemon_has_type 
WHERE id = $1;

-- 2.1.3 Implement DELETE on one relation
-- Delete relations in the pokemon table
DELETE from Pokemon
WHERE id = :pokeId;

-- 2.1.4 Implement Selection on one relation
-- Select pokemon based on types (can have multiple types)
SELECT distinct id
FROM Pokemon
WHERE type_name IN (:pokeType, :pokeType2)