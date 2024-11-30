import express from "express";
import db from "../db.js";

const router = express.Router();

router.get("/all-pokemon", async (req, res) => {
  try {
    const query = `
    SELECT Pokemon.pokemon_name AS pokemon_name
    FROM Pokemon;
    `;
    const result = await db.query(query);
    return res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Error retrieving pokemon data");
  }
});

router.get("/pokemon-in-region", async (req, res) => {
  try {
    const query = `
    SELECT Pokemon.region_name AS region, COUNT(Pokemon.id) AS num_pokemon
    FROM Pokemon
    GROUP BY Pokemon.region_name;
    `;
    const result = await db.query(query);
    return res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Error retrieving pokemon by region");
  }
});

router.get("/best-or-worst-avg-moves-by-type", async (req, res) => {
  try {
    const extreme = req.query.extreme;
    const ord = extreme === "MAX" ? "DESC" : "ASC";
    const query = `
    SELECT type, MAX(power)
    FROM (
        SELECT MT.type_name AS type, AVG(m.power) AS power
        FROM Move M INNER JOIN move_has_type MT
        ON M.move_name = MT.move_name
        GROUP BY MT.type_name
    ) AS avg_power
    ORDER BY power ${ord}
    LIMIT 1;
    `;
    const result = await db.query(query);
    return res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Error best/worst average moves by type");
  }
});

export default router;
