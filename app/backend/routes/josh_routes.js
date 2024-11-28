import express from 'express';
import db from '../db.js';

const router = express.Router();

router.get('/gym-leader/:name', async (req, res) => {
  try {
    const gymLeaderName = req.params.name;
    const query = `SELECT 
        significant_trainer.name,
        significant_trainer.age,
        gym_leader.gym_location,
        gym_leader.gym_region,
        pokemon.pokemon_name
      FROM 
        significant_trainer, gym_leader, pokemon_roster, pokemon
      WHERE 
        significant_trainer.name = gym_leader.name
        AND significant_trainer.name = pokemon_roster.name
        AND pokemon_roster.id = Pokemon.id
        AND gym_leader.name = $1;`;
    const result = await db.query(query, [gymLeaderName]);
    return res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Error retrieving gym leader data');
  }
});

router.get('/move-stats/:type', async (req, res) => {
  try {
    const moveType = req.params.type;
    const query = `SELECT
        move_has_type.type_name,
        MIN(move.power),
        MAX(move.power),
        AVG(move.power)
      FROM 
        move
      JOIN move_has_type ON move.move_name = move_has_type.move_name
      GROUP BY move_has_type.type_name
      HAVING move_has_type.type_name = $1;`;
    const result = await db.query(query, [moveType]);
    return res.json(result.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Error retrieving move statistics');
  }
});

router.get('/trainers-with-pokemon', async (req, res) => {
  try {
    const pokemonIds = req.query.ids.split(',').map((id) => parseInt(id, 10));
    const placeholders = pokemonIds
      .map((_, index) => `$${index + 1}`)
      .join(', ');
    const query = `SELECT name
        FROM significant_trainer
        WHERE NOT EXISTS (
          SELECT id
          FROM pokemon
          WHERE id IN (${placeholders})
          EXCEPT
          SELECT pokemon.id
          FROM pokemon_roster
          JOIN pokemon ON pokemon_roster.id = pokemon.id
          WHERE pokemon_roster.name = significant_trainer.name
        );
      `;
    const result = await db.query(query, pokemonIds);
    return res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Error retrieving trainers with specified Pokémon');
  }
});

export default router;
