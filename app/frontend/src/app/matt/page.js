"use client";

import { allPokemon, pokemonInRegion, bestWorstMovesType } from "../api-calls/matt_api";
import { useState } from "react";

export default function Home() {
  const [checked, setChecked] = useState(false);
  function handleCheckbox() {
    setChecked(!checked);
  }
  return (
    <div className="testButton">
      <button onClick={allPokemon}>All Pokemon</button>
      <button onClick={pokemonInRegion}>Pokemon In Region</button>
      <button
        onClick={() => {
          bestWorstMovesType(checked);
        }}
      >
        Best Worst Moves Type
      </button>
      <input type="checkbox" onChange={handleCheckbox} />
      {checked ? <div> Max average power </div> : <div> Min average power </div>}{" "}
    </div>
  );
}
