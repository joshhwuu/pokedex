
/*
(2.1.5) One relation to project on
Users should be able to find the name of every single Pokemon in the game.
*/

SELECT Pokemon.pokemon_name AS pokemon_name
FROM Pokemon;


/*
(2.1.7) Aggregation with group by
Users should be able to count the number of pokemon by region to be able to figure out how many new pokemon they’re able to find in a given region.
*/

SELECT Pokemon.region_name AS region, COUNT(Pokemon.id) AS num_pokemon
FROM Pokemon
GROUP BY Pokemon.region_name;

/*
(2.1.9) Nested aggregation with group by
Users should be able to find the Pokemon type with the strongest/weakest average power of their moves.
*/

SELECT type, MAX(power) AS power -- !! should be able to select min or max
FROM (
    SELECT MT.type_name AS type, AVG(m.power) AS power
    FROM Move M INNER JOIN move_has_type MT
    ON M.move_name = MT.move_name
    GROUP BY MT.type_name
) AS avg_power
GROUP BY type;
