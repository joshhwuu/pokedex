-- 2.1.6 User should be able to see the gym leader's name, where they are located
--       and their Pokemon Roster. Brock is an example gym leader.
SELECT 
    SignificantTrainer.name,
    SignificantTrainer.age,
    GymLeader.gym_location,
    GymLeader.gym_region,
    Pokemon.name
FROM 
    SignificantTrainer, GymLeader, PokemonRoster, PokemonHasType
WHERE 
    SignificantTrainer.name = GymLeader.name
    AND SignificantTrainer.name = PokemonRoster.name
    AND PokemonRoster.id = Pokemon.id
    AND GymLeader.name = 'Brock'; -- !!! Delete

-- 2.1.8 Find the min/max/avg power of moves of a specific Type
SELECT 
    move_has_type.type_name,
    MIN(move.power),
    MAX(move.power),
    AVG(move.power)
FROM 
    move
JOIN move_has_type ON move.move_name = move_has_type.move_name
GROUP BY move_has_type.type_name
HAVING move_has_type.type_name = 'Fire';

-- 2.1.10 User should be able to find if a given list of Pokemon are ALL used in
--        a trainer's roster.
SELECT name
    FROM significant_trainer
WHERE NOT EXISTS (
SELECT id
FROM pokemon
WHERE id IN (1, 2, ...) -- replace with pokemon ids
EXCEPT
SELECT pokemon.id
FROM pokemon_roster
JOIN pokemon ON pokemon_roster.id = pokemon.id
WHERE pokemon_roster.name = significant_trainer.name
);
