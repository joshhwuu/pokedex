import express from "express";
import db from "../db.js";

const router = express.Router();

//2.1.1 INSERT
router.post("/pokemon", async (req, res) => {
  try {
    const {
      pokeId,
      pokeName,
      pokeCategory,
      pokeCatch,
      pokeRegion,
      pokeEvoItem,
      pokeFromId,
      pokeType,
    } = req.body;

    async function insertIntoTypes(type) {
      const typeInsertQuery = `
      INSERT INTO type(type_name)
      VALUES($1) 
      ON CONFLICT DO NOTHING;
    `;
      const typeInsertResult = await db.query(typeInsertQuery, [type]);
    }

    async function insertPokemonType(type) {
      const pokeHasTypeInsertQuery = `
      INSERT INTO pokemon_has_type(id, type_name)
      VALUES ($1, $2);
    `;
      const pokeHasTypeInsertResult = await db.query(pokeHasTypeInsertQuery, [
        pokeId,
        type,
      ]);
    }

    const pokeInsertQuery = `
      INSERT INTO pokemon(
        id, 
        pokemon_name, 
        category, 
        evolution_item,
        catch_rate, 
        region_name, 
        from_id
      ) 
      VALUES ($1, $2, $3, $4, $5, $6, $7)
    `;
    const pokeInsertResult = await db.query(pokeInsertQuery, [
      pokeId,
      pokeName,
      pokeCategory,
      pokeEvoItem,
      pokeCatch,
      pokeRegion,
      pokeFromId,
    ]);

    // removes whitespace, splits commas, inserts each one at a time into db
    pokeType.replace(/\s/g, "").split(",").map(insertIntoTypes);
    pokeType.replace(/\s/g, "").split(",").map(insertPokemonType);

    return res
      .status(201)
      .json({ message: "Pokemon and type successfully inserted." });
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Error adding new pokemon");
  }
});

router.put("/pokemon", async (req, res) => {
  try {
    const {
      pokeName,
      pokeCategory,
      pokeCatch,
      pokeRegion,
      pokeFromId,
      pokeId,
    } = req.body;
    const query = `
      UPDATE pokemon
      SET
        pokemon_name = $1,
        category = $2,
        catch_rate = $3,
        region_name = $4,
        from_id = $5
      WHERE
        id = $6;
      `;
    const result = await db.query(query, [
      pokeName,
      pokeCategory,
      pokeCatch,
      pokeRegion,
      pokeFromId,
      pokeId,
    ]);

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Pokemon not found." });
    }

    return res.status(200).json({ message: "Pokemon updated successfully." });
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Error updating Pokemon");
  }
});

router.delete("/pokemon", async (req, res) => {
  try {
    const { pokeId } = req.body;
    const query = `
    DELETE from pokemon
    WHERE id = $1;
    `;

    const result = await db.query(query, pokeId);

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Pokemon not found." });
    }

    return res.status(200).json({ message: "Pokemon deleted successfully." });
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Error deleting Pokemon");
  }
});

router.get("/pokemon", async (req, res) => {
  try {
    const { pokeType, pokeType2 } = req.params; // TODO: this needs to be req.query
    const query = `
    SELECT distinct id
    FROM pokemon
    WHERE type_name IN ($1, $2);
    `; // TODO: this query is incorrect: it should be a join with pokemon_has_type and we should return pokemon_name instead

    const result = await db.query(query, [pokeType, pokeType2]);

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Pokemon not found." });
    }

    return res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Error retrieving Pokemon of selected types");
  }
});

export default router;
