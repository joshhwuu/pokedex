import express from "express";
import db from "./db.js";

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

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
