"use client";

import { apiTest } from "./api-calls/api";
export default function Home() {
  return (
    <div className="testButton">
      <button onClick={apiTest}>Click to test backend</button>
    </div>
  );
}
