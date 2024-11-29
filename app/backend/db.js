import dotenv from "dotenv";
import pkg from "pg";

dotenv.config();

const { Pool } = pkg;

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "local",
  password: "postgres",
  port: 5432,
});


const query = (text, params) => pool.query(text, params);

export default pool;
