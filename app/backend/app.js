import express from 'express';
import db from './db.js';
import path from 'path';
import fs from 'fs';
import josh_routes from './routes/josh_routes.js';
import matt_routes from "./routes/matt_routes.js";
import albert_routes from "./routes/albert_routes.js";

import cors from "cors";

const app = express();

app.use(cors());

const port = 8008;

app.post('/reload', async (req, res) => {
  const pathToReloadSql = path.join('../../scripts/sql/insert_tables.sql');
  const query = fs.readFileSync(pathToReloadSql, 'utf-8');
  try {
    await db.query(query);
    res.send('Database reloaded successfully');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error reloading database');
  }
});

// @ team members, please add your routes here in similar fashion
=======
app.use('/josh', josh_routes);
app.use("/matt", matt_routes);
app.use("/albert", albert_routes);

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
