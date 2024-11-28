'use client'
import { useState } from 'react';
import { pokemonInRegion } from '../api-calls/matt_api';

export default function FindAllPokemon() {
  const [result, setResult] = useState(null);
  const [error, setError] = useState(null);

  function handleClick(e) {
    e.preventDefault();

      setError(null);
      pokemonInRegion().then((res) => {
        if (res.length === 0) {
          setError('No Pokemon in Database.');
        } else {
          setResult(res);
        }
      }).catch((err) => {
        setError(err.message);
      });
  }

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold text-gray-700">Number of Pokemon in Each Region</h1>
      <h1 className="mt-1 mb-3 text-m font-bold text-gray-700">Find how many pokemon are in each region</h1>

      <div>
      <button className="bg-blue-500 hover:bg-blue-700 text-gray-700 font-bold py-2 px-4 rounded" 
              onClick={handleClick}>
        Find
      </button>
      </div>

      {result && (
        <div className='mt-5'>
            <div className="grid grid-cols-1 gap-4">
            {result.map((entry, i) => <p className='text-gray-700' key={i}>{entry.region}: {entry.num_pokemon}</p>)}
            </div>
        </div>
      )}
      {error && <p className="text-red-500">Could not find Pokemon.</p>}
    </div>
  );
}