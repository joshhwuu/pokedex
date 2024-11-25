"use client";

import { apiTest, loadData } from "./api-calls/shared_api";
import Link from "next/link";

export default function Home() {
  return (
    <div className="testButton">
      <button onClick={apiTest}>Test Backend</button>
      <button onClick={loadData}>Load Data</button>
      <Link href="/matt/page">Matt</Link>
    </div>
  );
}
