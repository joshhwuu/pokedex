"use client";
import { useState } from "react";
import { allPokemon } from "../api-calls/matt_api";

export default function FindAllPokemon() {
  const [result, setResult] = useState(null);
  const [error, setError] = useState(null);

  function handleClick(e) {
    e.preventDefault();

    setError(null);
    allPokemon()
      .then((res) => {
        if (res.length === 0) {
          setError("No Pokemon in Database.");
        } else {
          setResult(res);
        }
      })
      .catch((err) => {
        setError(err.message);
      });
  }

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold text-gray-700">Find The Names of All Pokemon</h1>
      <hr className="my-4 border-gray-300"></hr>
      <p className="text-gray-700 w-1/2 pb-4">
      Each pokemon registered in our database will be shown here      
      </p>
      <div>
        <button
          className="bg-blue-500 hover:bg-blue-700 text-gray-700 font-bold py-2 px-4 rounded"
          onClick={handleClick}
        >
          Find
        </button>
      </div>

      {result && (
        <div>
            <div className="grid mt-5 grid-cols-5 gap-4">
            {result.map((entry, i) => <p className='text-gray-700' key={i}>{entry.pokemon_name}</p>)}
            </div>
        </div>
      )}
      {error && <p className="text-red-500">Could not find Pokemon.</p>}
    </div>
  );
}
