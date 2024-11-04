import express from "express";
import db from "./db.js"; 

const app = express();

const port = 5000;

app.get("/", async (req, res) => {
  const query = "SELECT * FROM public.pokemon";
  try {
    const result = await db.query(query);
    res.send(result.rows);
  } catch (err) {
    console.error(err);
  }
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
