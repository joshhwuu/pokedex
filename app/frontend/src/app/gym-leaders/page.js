'use client';

import { useState } from 'react';

export default function GymLeaders() {
  const [name, setName] = useState('');
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setData(null);

    try {
      const response = await fetch(
        `http://localhost:8008/josh/gym-leader/${name}`
      );
      if (!response.ok) {
        throw new Error('Error retrieving data');
      }
      const data = await response.json();
      setData(groupByGymLeader(data));
      if (data.length === 0) {
        setError('Could not find Gym Leader.');
      }
    } catch (err) {
      setError(err.message);
    }
  };

  const groupByGymLeader = (data) => {
    const result = {};
    data.forEach((row) => {
      if (!result[row.name]) {
        result[row.name] = {
          name: row.name,
          age: row.age,
          gym_location: row.gym_location,
          gym_region: row.gym_region,
          pokemon_name: [],
        };
      }
      result[row.name].pokemon_name.push(row.pokemon_name);
    });
    return Object.values(result);
  };

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold text-gray-700">Gym Leaders</h1>
      <form onSubmit={handleSubmit} className="mb-4">
        <input
          type="text"
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Misty"
          className="border p-2 mr-2 text-gray-700"
        />
        <button
          type="submit"
          className="bg-blue-500 hover:bg-blue-700 text-gray-700 font-bold py-2 px-4 rounded"
        >
          Submit
        </button>
      </form>
      {error && <p className="text-red-500">Could not find Leader.</p>}
      {data && (
        <div>
          <h2 className="text-xl font-bold text-gray-700">
            Gym Leader Information
          </h2>
          <ul>
            {data.map((row, index) => (
              <li key={index}>
                <p className="text-gray-700">Gym Leader Name: {row.name}</p>
                <p className="text-gray-700">Age: {row.age} </p>
                <p className="text-gray-700">
                  Location: {row.gym_location} of {row.gym_region} region
                </p>
                <p className="text-gray-700">Pokémon:</p>
                <ul className="list-disc list-inside">
                  {row.pokemon_name.map((pokemon_name, idx) => (
                    <li className="text-gray-700" key={idx}>
                      {pokemon_name}
                    </li>
                  ))}
                </ul>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
