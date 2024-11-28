"use client";

import { useState } from "react";

export default function TrainerQuery() {
  const [names, setNames] = useState("");
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setData(null);

    try {
      if (!names) {
        throw new Error("Please enter a list of Pokémon names.");
      }
      const response = await fetch(
        `http://localhost:8008/josh/trainers-with-pokemon?names=${names.replace(/\s+/g, "")}`
      );
      if (!response.ok) {
        if (response.status === 404) {
          throw new Error("No trainers found with the specified Pokémon.");
        } else {
          throw new Error("Error retrieving data");
        }
      }
      const result = await response.json();
      setData(result);
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold text-gray-700">Trainer Query</h1>
      <hr className="my-4 border-gray-300"></hr>
      <p className="text-gray-700 w-1/2 p-4">
        This query tool allows you to see which trainers own the entirety of a
        certain list of Pokemon. Please enter Pokemon names as a comma-separated
        list.
      </p>
      <form onSubmit={handleSubmit} className="mb-4">
        <input
          type="text"
          value={names}
          onChange={(e) => setNames(e.target.value)}
          placeholder="Pikachu, Starmie"
          className="border p-2 mr-2 text-gray-700"
        />
        <button
          type="submit"
          className="bg-blue-500 hover:bg-blue-700 text-gray-700 font-bold py-2 px-4 rounded"
        >
          Submit
        </button>
      </form>
      {error && <p className="text-red-500">{error}</p>}
      {data && (
        <div>
          <h2 className="text-xl font-bold text-gray-700">Trainers</h2>
          <hr className="my-4 border-gray-300"></hr>
          <ul>
            {data.map((trainer, index) => (
              <li key={index} className="mb-4">
                <p className="text-gray-700">{trainer.name}</p>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
