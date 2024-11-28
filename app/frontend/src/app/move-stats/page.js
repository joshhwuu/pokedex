"use client";

import { useState } from "react";

export default function MoveStats() {
  const [type, setType] = useState("");
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setData(null);

    try {
      const response = await fetch(
        `http://localhost:8008/josh/move-stats/${type}`
      );
      if (!response.ok) {
        throw new Error("Error retrieving data");
      }
      const result = await response.json();
      setData(result);
      console.log(result);
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold text-gray-700">Move Stats</h1>
      <hr className="my-4 border-gray-300"></hr>
      <p className="text-gray-700 w-1/2 p-4">
        See aggregated stats about Pokemon moves based on type.
      </p>
      <form onSubmit={handleSubmit} className="mb-4">
        <input
          type="text"
          value={type}
          onChange={(e) => setType(e.target.value)}
          placeholder="Water"
          className="border p-2 mr-2 text-gray-700 text-gray-700"
        />
        <button
          type="submit"
          className="bg-blue-500 hover:bg-blue-700 text-gray-700 font-bold py-2 px-4 rounded"
        >
          Submit
        </button>
      </form>
      {error && (
        <p className="text-red-500">
          Could not find type. Make sure it is formatted correctly.
        </p>
      )}
      {data && (
        <div>
          <h2 className="text-xl font-bold text-gray-700">Move Statistics</h2>
          <hr className="my-4 border-gray-300"></hr>
          <div className="mb-4">
            <p className="font-bold text-gray-700">Type: {data.type_name}</p>
            <p className="text-gray-700">Minimum Power: {data.min}</p>
            <p className="text-gray-700">
              Average Power: {parseFloat(data.avg).toFixed(2)}
            </p>
            <p className="text-gray-700">Maximum Power: {data.max}</p>
          </div>
        </div>
      )}
    </div>
  );
}
