import express from "express";
import db from "./db.js";
import path from "path";
import fs from "fs";

import cors from "cors";
const app = express();

app.use(cors());

const port = 8008;

app.get("/", async (req, res) => {
  const query = "SELECT * FROM test";
  console.log("query received");
  try {
    const result = await db.query(query);
    console.log(result);
    res.send(result.rows);
  } catch (err) {
    console.error(err);
  }
});

app.post("/reload", async (req, res) => {
  const pathToReloadSql = path.join("../../scripts/sql/insert_tables.sql");
  const query = fs.readFileSync(pathToReloadSql, "utf-8");
  try {
    await db.query(query);
    res.send("Database reloaded successfully");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error reloading database");
  }
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
