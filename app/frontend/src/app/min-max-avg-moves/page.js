"use client";
import { useState } from "react";
import { bestWorstMovesType } from "../api-calls/matt_api";

export default function MaxAndMinDamage() {
  const [result, setResult] = useState(null);
  const [error, setError] = useState(null);
  const [checked, setChecked] = useState(false);
  const [lastQueryMaxOrMin, setLastQueryMaxOrMin] = useState("MIN");

  function handleCheckbox() {
    setChecked(!checked);
  }

  function handleClick(e) {
    e.preventDefault();

    setError(null);
    bestWorstMovesType(checked)
      .then((res) => {
        if (res.length === 0) {
          setError("No moves in the database.");
        } else {
          setResult(res[0]);
          setLastQueryMaxOrMin(checked ? "MAX" : "MIN");
        }
      })
      .catch((err) => {
        setError(err.message);
      });
  }

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold text-gray-700">
        Max and Min Average Damage
      </h1>
      <hr className="my-4 border-gray-300"></hr>
      <p className="text-gray-700 w-3/5 pb-4">
        Find the move type with the highest or lowest average damage of all
        types
      </p>

      <div className="inline-flex items-center">
        <button
          className="bg-blue-500 hover:bg-blue-700 text-gray-700 font-bold py-2 px-4 rounded"
          onClick={handleClick}
        >
          Find
        </button>
        <p className="ml-4 text-center text-xl font-bold text-gray-700">
          {checked ? "MAX" : "MIN"}
        </p>
        <input className="ml-4" type="checkbox" onChange={handleCheckbox} />
      </div>

      {result && (
        <div>
          <h2 className="text-xl font-bold text-gray-700">
            Type with {lastQueryMaxOrMin} average move damage is:
          </h2>
          <p className="text-gray-700">Move Type: {result.type}</p>
          <p className="text-blue-700">
            Move Power: {Math.floor(result.power)}
          </p>
        </div>
      )}
      {error && <p className="text-red-500">Could not find moves.</p>}
    </div>
  );
}
