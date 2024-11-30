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

    const pokeIdInt = parseInt(pokeId, 10);
    const pokeCatchRateInt = parseInt(pokeCatch, 10);
    const pokeFromIdInt = pokeFromId ? parseInt(pokeFromId, 10) : null;
    const pokeEvoItemVal = pokeEvoItem === "" ? null : pokeEvoItem;

    async function insertIntoTypes(type) {
      const typeInsertQuery = `
      INSERT INTO type(type_name)
      VALUES($1) 
      ON CONFLICT DO NOTHING;
    `;
      db.query(typeInsertQuery, [type]);
    }

    async function insertPokemonType(type) {
      const pokeHasTypeInsertQuery = `
      INSERT INTO pokemon_has_type(id, type_name)
      VALUES ($1, $2)
      ON CONFLICT DO NOTHING;
    `;
      await db.query(pokeHasTypeInsertQuery, [pokeId, type]);
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
    await db.query(pokeInsertQuery, [
      pokeIdInt,
      pokeName,
      pokeCategory,
      pokeEvoItemVal,
      pokeCatchRateInt,
      pokeRegion,
      pokeFromIdInt,
    ]);

    // removes whitespace, splits commas, inserts each one at a time into db
    pokeType.replace(/\s/g, "").split(",").map(insertIntoTypes);
    pokeType.replace(/\s/g, "").split(",").map(insertPokemonType);

    return res
      .status(201)
      .json({ message: "Pokemon and type successfully inserted." });
  } catch (err) {
    console.error(err.message);
    res.status(500).send(err.message);
  }
});

router.put("/pokemon", async (req, res) => {
  try {
    const {
      pokeId,
      pokeName,
      pokeCategory,
      pokeCatch,
      pokeRegion,
      pokeFromId,
      pokeEvoItem,
      pokeType,
    } = req.body;

    const pokeIdInt = parseInt(pokeId, 10);
    const pokeCatchRateInt = parseInt(pokeCatch, 10);
    const pokeFromIdInt = pokeFromId ? parseInt(pokeFromId, 10) : null;
    const pokeEvoItemVal = pokeEvoItem === "" ? null : pokeEvoItem;

    async function insertIntoTypes(type) {
      const typeInsertQuery = `
      INSERT INTO type(type_name)
      VALUES($1) 
      ON CONFLICT DO NOTHING;
    `;
      db.query(typeInsertQuery, [type]);
    }

    async function insertPokemonType(type) {
      const pokeHasTypeInsertQuery = `
      INSERT INTO pokemon_has_type(id, type_name)
      VALUES ($1, $2)
      ON CONFLICT DO NOTHING;
    `;
      await db.query(pokeHasTypeInsertQuery, [pokeId, type]);
    }

    const query = `
      UPDATE pokemon
      SET
        pokemon_name = $1,
        category = $2,
        evolution_item = $3,
        catch_rate = $4,
        region_name = $5,
        from_id = $6
      WHERE
        id = $7;
      `;
    const result = await db.query(query, [
      pokeName,
      pokeCategory,
      pokeEvoItemVal,
      pokeCatchRateInt,
      pokeRegion,
      pokeFromIdInt,
      pokeIdInt,
    ]);

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Pokemon not found." });
    }

    // removes type association with pokemon
    const deleteTypeQuery = `
    DELETE FROM pokemon_has_type 
    WHERE id = $1;
    `;
    await db.query(deleteTypeQuery, [pokeIdInt]);

    // removes whitespace, splits commas, inserts each one at a time into db
    pokeType.replace(/\s/g, "").split(",").map(insertIntoTypes);
    pokeType.replace(/\s/g, "").split(",").map(insertPokemonType);

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
    WHERE id = $1 RETURNING pokemon_name;
    `;

    const result = await db.query(query, [pokeId]);

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Pokemon not found." });
    }
    return res.status(200).json({ message: result.rows[0].pokemon_name });
  } catch (err) {
    console.error(err.message);
    res.status(500).send(err.message);
  }
});

router.get("/pokemon", async (req, res) => {
  try {
    const { pokeType, pokeType2 } = req.query;
    const query = `
    SELECT distinct pokemon.pokemon_name
    FROM pokemon, pokemon_has_type
    WHERE pokemon.id=pokemon_has_type.id AND type_name IN ($1, $2);
    `;

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
