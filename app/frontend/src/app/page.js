"use client";

import React, { useState } from "react";

export default function Home() {
  const handleReload = async () => {
    try {
      const response = await fetch("http://localhost:8008/reload", {
        method: "POST",
      });
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      alert("Tables reloaded successfully");
    } catch (error) {
      console.error("Error reloading tables:", error);
      alert("Error reloading tables");
    }
  };

  const [pokeId, setPokeId] = useState("");
  const [pokeName, setPokeName] = useState("");
  const [pokeCategory, setPokeCategory] = useState("");
  const [pokeCatch, setPokeCatch] = useState("");
  const [pokeRegion, setPokeRegion] = useState("");
  const [pokeEvoItem, setPokeEvoItem] = useState("");
  const [pokeFromId, setPokeFromId] = useState("");
  const [pokeType, setPokeType] = useState("");

  const [updatePokeId, setUpdatePokeId] = useState("");
  const [updatePokeName, setUpdatePokeName] = useState("");
  const [updatePokeCategory, setUpdatePokeCategory] = useState("");
  const [updatePokeCatch, setUpdatePokeCatch] = useState("");
  const [updatePokeRegion, setUpdatePokeRegion] = useState("");
  const [updatePokeEvoItem, setUpdatePokeEvoItem] = useState("");
  const [updatePokeFromId, setUpdatePokeFromId] = useState("");
  const [updatePokeType, setUpdatePokeType] = useState("");

  const [deletePokeId, setDeletePokeId] = useState("");

  const [pokeType1, setPokeType1] = useState("");
  const [pokeType2, setPokeType2] = useState("");
  const [pokemonList, setPokemonList] = useState([]);

  const [activeTab, setActiveTab] = useState("reload");

  const handleAddPokemon = async (event) => {
    event.preventDefault();
    try {
      const pokeInfo = JSON.stringify({
        pokeId: pokeId,
        pokeName: pokeName,
        pokeCategory: pokeCategory,
        pokeCatch: pokeCatch,
        pokeRegion: pokeRegion,
        pokeEvoItem: pokeEvoItem,
        pokeFromId: pokeFromId,
        pokeType: pokeType,
      })

      const pokeIdInt = parseInt(pokeId, 10);
      const pokeCatchInt = parseInt(pokeCatch, 10);
      const pokeFromIdInt = pokeFromId ? parseInt(pokeFromId, 10) : null;

      // Validate types
      if (isNaN(pokeIdInt) || isNaN(pokeCatchInt) || (pokeFromId && isNaN(pokeFromIdInt))) {
        alert("Only valid numbers are allowed for ID, Catch Rate, and From ID.");
        return;
      }

      if (!(typeof pokeName == "string")) {
        alert("Pokemon name must be a string");
        return;
      }

      if (
      (!(typeof pokeCategory == "string") && pokeCategory != null) || 
      (!(typeof pokeRegion == "string") && pokeRegion != null) || 
      (!(typeof pokeEvoItem == "string") && pokeEvoItem != null) || 
      (!(typeof pokeType  == "string") && pokeType != null)
      ) {
        alert("Only valid strings are allowed for Category, Region, Evolution Item, and Type.");
        return;
      }


      const response = await fetch("http://localhost:8008/albert/pokemon", {
        method: "POST",
        headers: {
          "Content-Type": 'application/json',
        },
        body: pokeInfo,
      });


      if (!response.ok) {
        return response.text().then(text => { 
          if (text.includes("pokemon_pkey")) {
            alert("Pokemon with ID already exists.");
          } else if (text.includes("pokemon_pokemon_name_key")) {
            alert("Pokemon with name already exists.");
          } else if (text.includes("fk_from_id")) {
            alert("Pokemon From ID must belong to pokemon that exists in the database.");
          } else{
            alert("Failed to add Pokemon to database");
          }
         })
      }

      alert("Pokemon added successfully");
      setPokeId("");
      setPokeName("");
      setPokeCategory("");
      setPokeCatch("");
      setPokeRegion("");
      setPokeEvoItem("");
      setPokeFromId("");
      setPokeType("");
    } catch (err) {
      //console.error("Error adding Pokemon:", err);
      alert(`Error: ${err.message}`);
    }
  };

  const handleUpdateSubmit = async (event) => {
    event.preventDefault();
    try {
      const pokeInfo = JSON.stringify({
        pokeId: updatePokeId,
        pokeName: updatePokeName,
        pokeCategory: updatePokeCategory,
        pokeCatch: updatePokeCatch,
        pokeRegion: updatePokeRegion,
        pokeEvoItem: updatePokeEvoItem,
        pokeFromId: updatePokeFromId,
        pokeType: updatePokeType,
      })

      const pokeIdInt = parseInt(updatePokeId, 10);
      const pokeCatchInt = parseInt(updatePokeCatch, 10);
      const pokeFromIdInt = updatePokeFromId ? parseInt(updatePokeFromId, 10) : null;

      // Validate types
      if (isNaN(pokeIdInt) || isNaN(pokeCatchInt) || (pokeFromId && isNaN(pokeFromIdInt))) {
        alert("Only valid numbers are allowed for ID, Catch Rate, and From ID.");
        return;
      }

      if (!(typeof updatePokeName == "string")) {
        alert("Pokemon name must be a string");
        return;
      }

      if (
      (!(typeof pokeCategory == "string") && pokeCategory != null) || 
      (!(typeof pokeRegion == "string") && pokeRegion != null) || 
      (!(typeof pokeEvoItem == "string") && pokeEvoItem != null) || 
      (!(typeof pokeType  == "string") && pokeType != null)
      ) {
        alert("Only valid strings are allowed for Category, Region, Evolution Item, and Type.");
        return;
      }

      const response = await fetch("http://localhost:8008/albert/pokemon", {
        method: "PUT",
        headers: {
          "Content-Type": 'application/json',
        },
        body: pokeInfo,
      });

      if (!response.ok) {
        if (response.status === 404) {
          alert("Pokemon not found.");
          return;
        } else {
          response.text().then(text => { 
            if (text.includes("pokemon_pkey")) {
              alert("Pokemon with ID already exists.");
            } else if (text.includes("pokemon_pokemon_name_key")) {
              alert("Pokemon with name already exists.");
            } else if (text.includes("fk_from_id")) {
              alert("Pokemon From ID must belong to pokemon that exists in the database.");
            } else{
              alert("Failed to update Pokemon.");}
            })
            return;
          }
        }
      alert("Pokemon updated successfully");
      setUpdatePokeId("");
      setUpdatePokeName("");
      setUpdatePokeCategory("");
      setUpdatePokeCatch("");
      setUpdatePokeRegion("");
      setUpdatePokeEvoItem("");
      setUpdatePokeFromId("");
      setUpdatePokeType("");

    } catch (err) {
      alert(`Error: ${err.message}`);
    }
  };

  const handleDeleteSubmit = async (event) => {
    event.preventDefault();
    try {
      if (isNaN(parseInt(deletePokeId))) {
        alert("Must input number");
        return;
      }

      const response = await fetch("http://localhost:8008/albert/pokemon", {
        method: "DELETE",
        headers: {
          "Content-Type": 'application/json',
        },
        body: JSON.stringify({ pokeId: parseInt(deletePokeId) }),
      });

      if (!response.ok) {
        if (response.status === 404) {
          alert("Pokemon not found.");
          return;
        } else {
        alert("Failed to delete Pokemon");
        return;
        }
      }
      response.text().then(text => { 
        alert(`${JSON.parse(text).message} was deleted successfully!`)
      })

    } catch (err) {
      //console.error("Error deleting Pokemon:", err);
      alert(`Error: ${err.message}`);
    }
  };

  const handleGetSubmit = async (event) => {
    event.preventDefault();
    try {
      if (!(typeof pokeType1 == "string") || !(typeof pokeType2 == "string")) {
        alert("Only letters are allowed as types.");
        return;
      }

      const response = await fetch(
        `http://localhost:8008/albert/pokemon?pokeType=${pokeType1}&pokeType2=${pokeType2}`,
        {
          method: "GET",
        }
      );


      if (!response.ok) {
        if (response.status === 404) {
          throw new Error("Pokemon not found.");
        } else {
        throw new Error("Failed to return Pokemon data");
        }
      }

      const data = await response.json();
      setPokemonList(data);
      alert("Search complete");
    } catch (err) {
      alert(`Error: ${err.message}`);
    }
  };

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold text-gray-700">Home Page</h1>

      {/* Tab navigation */}
      <div className="flex space-x-4 mt-4">
        <button
          onClick={() => setActiveTab("reload")}
          className={`px-4 py-2 rounded ${activeTab === "reload" ? "bg-blue-500 text-white" : "bg-gray-500"}`}
        >
          Reload Tables
        </button>

        <button
          onClick={() => setActiveTab("add")}
          className={`px-4 py-2 rounded ${activeTab === "add" ? "bg-blue-500 text-white" : "bg-gray-500"}`}
        >
          Add Pokemon
        </button>

        <button
          onClick={() => setActiveTab("update")}
          className={`px-4 py-2 rounded ${activeTab === "update" ? "bg-blue-500 text-white" : "bg-gray-500"}`}
        >
          Update Pokemon
        </button>

        <button
          onClick={() => setActiveTab("delete")}
          className={`px-4 py-2 rounded ${activeTab === "delete" ? "bg-blue-500 text-white" : "bg-gray-500"}`}
        >
          Delete Pokemon
        </button>

        <button
          onClick={() => setActiveTab("fetch")}
          className={`px-4 py-2 rounded ${activeTab === "fetch" ? "bg-blue-500 text-white" : "bg-gray-500"}`}
        >
          Search by Type
        </button>
      </div>
f
      {/* Tab Content */}
      {activeTab === "reload" && (
        <div>
          <button
            onClick={handleReload}
            className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mt-4"
          >
            Reload Tables
          </button>
        </div>
      )}

      {activeTab === "add" && (
        <div>
          <h2 className="text-xl font-semibold text-gray-700 mt-2">Add a Pokemon</h2>
          <form onSubmit={handleAddPokemon} className="mt-4">

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm text-gray-600 font-semibold">*Pokemon ID</label>
                <input
                  type="text"
                  value={pokeId}
                  placeholder="385"
                  onChange={(e) => setPokeId(e.target.value)}
                  className="border px-3 py-2 text-blue-700 mt-1 w-full"
                  required
                />
              </div>
              <div>
                <label className="block text-sm text-gray-600 font-semibold">*Pokemon Name</label>
                <input
                  type="text"
                  value={pokeName}
                  placeholder="Jirachi"
                  onChange={(e) => setPokeName(e.target.value)}
                  className="border px-3 py-2 text-blue-700 mt-1 w-full"
                  required
                />
              </div>

              <div>
                <label className="block text-sm text-gray-600 font-semibold">*Pokemon Category</label>
                <input
                  type="text"
                  value={pokeCategory}
                  placeholder="Wish Pokemon"
                  onChange={(e) => setPokeCategory(e.target.value)}
                  className="border px-3 py-2 text-blue-700 mt-1 w-full"
                  required
                />
              </div>
              <div>
                <label className="block text-sm text-gray-600 font-semibold">*Pokemon Catch Rate</label>
                <input
                  type="text"
                  value={pokeCatch}
                  placeholder="3"
                  onChange={(e) => setPokeCatch(e.target.value)}
                  className="border px-3 py-2 text-blue-700 mt-1 w-full"
                  required
                />
              </div>

              <div>
                <label className="block text-sm text-gray-600 font-semibold">*Pokemon Region</label>
                <input
                  type="text"
                  value={pokeRegion}
                  placeholder="Kanto"
                  onChange={(e) => setPokeRegion(e.target.value)}
                  className="border px-3 py-2 text-blue-700 mt-1 w-full"
                  required
                />
              </div>
              <div>
                <label className="block text-sm text-gray-600 font-semibold">Pokemon Evolution Item</label>
                <input
                  type="text"
                  value={pokeEvoItem}
                  onChange={(e) => setPokeEvoItem(e.target.value)}
                  className="border px-3 py-2 text-blue-700 mt-1 w-full"
                />
              </div>

              <div>
                <label className="block text-sm text-gray-600 font-semibold">Pokemon From ID</label>
                <input
                  type="text"
                  value={pokeFromId}
                  onChange={(e) => setPokeFromId(e.target.value)}
                  className="border px-3 py-2 text-blue-700 mt-1 w-full"
                />
              </div>
              <div>
                <label className="block text-sm text-gray-600 font-semibold">Pokemon Type</label>
                <input
                  type="text"
                  value={pokeType}
                  placeholder="Steel, Psychic"
                  onChange={(e) => setPokeType(e.target.value)}
                  className="border px-3 py-2 text-blue-700 mt-1 w-full"
                />
              </div>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded mt-4"
            >
              Add Pokemon
            </button>
          </form>
        </div>
      )}

      {activeTab === "update" && (
        <div>
          <h2 className="text-xl font-semibold text-gray-700 mt-2">Update Pokemon Based on ID</h2>
          <form onSubmit={handleUpdateSubmit} className="mt-4">
            <div>
              <label className="block text-sm text-gray-600 font-semibold">*Pokemon ID</label>
              <input
                type="text"
                value={updatePokeId}
                onChange={(e) => setUpdatePokeId(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
                required
              />
            </div>
            <div>
              <label className="block text-sm text-gray-600 font-semibold">*Pokemon Name</label>
              <input
                type="text"
                value={updatePokeName}
                onChange={(e) => setUpdatePokeName(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
                required
              />
            </div>
            <div>
              <label className="block text-sm text-gray-600 font-semibold">*Pokemon Category</label>
              <input
                type="text"
                value={updatePokeCategory}
                onChange={(e) => setUpdatePokeCategory(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
                required
              />
            </div>
            <div>
              <label className="block text-sm text-gray-600 font-semibold">*Pokemon Catch Rate</label>
              <input
                type="text"
                value={updatePokeCatch}
                onChange={(e) => setUpdatePokeCatch(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
                required
              />
            </div>
            <div>
              <label className="block text-sm text-gray-600 font-semibold">*Pokemon Region</label>
              <input
                type="text"
                value={updatePokeRegion}
                onChange={(e) => setUpdatePokeRegion(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
                required
              />
            </div>
            <div>
              <label className="block text-sm text-gray-600 font-semibold">Pokemon Evolution Item</label>
              <input
                type="text"
                value={updatePokeEvoItem}
                onChange={(e) => setUpdatePokeEvoItem(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
              />
            </div>
            <div>
              <label className="block text-sm text-gray-600 font-semibold">Pokemon From ID</label>
              <input
                type="text"
                value={updatePokeFromId}
                onChange={(e) => setUpdatePokeFromId(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
              />
            </div>
            <div>
              <label className="block text-sm text-gray-600 font-semibold">Pokemon Type</label>
              <input
                type="text"
                value={updatePokeType}
                onChange={(e) => setUpdatePokeType(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
              />
            </div>
            <button
              type="submit"
              className="bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-2 px-4 rounded mt-4"
            >
              Update Pokemon
            </button>
          </form>
        </div>
      )}

      {activeTab === "delete" && (
        <div>
          <h2 className="text-xl font-semibold text-gray-700 mt-2">Delete Pokemon</h2>
          <form onSubmit={handleDeleteSubmit} className="mt-4">
            <div>
              <label className="block text-sm text-gray-600 font-semibold">*Pokemon ID</label>
              <input
                type="text"
                value={deletePokeId}
                onChange={(e) => setDeletePokeId(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
                required
              />
            </div>
            <button
              type="submit"
              className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded mt-4"
            >
              Delete Pokemon
            </button>
          </form>
        </div>
      )}

      {activeTab === "fetch" && (
        <div>
          <h2 className="text-xl font-semibold text-gray-700 mt-2">Pokemon Lookup</h2>
          <form onSubmit={handleGetSubmit} className="mt-4">
            <div>
              <label className="block text-sm text-gray-600 font-semibold">*Pokemon Type 1</label>
              <input
                type="text"
                value={pokeType1}
                onChange={(e) => setPokeType1(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
                required
              />
            </div>
            <div>
              <label className="block text-sm text-gray-600 font-semibold">Pokemon Type 2</label>
              <input
                type="text"
                value={pokeType2}
                onChange={(e) => setPokeType2(e.target.value)}
                className="border px-3 py-2 text-blue-700 mt-1 w-full"
              />
            </div>
            <button
              type="submit"
              className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mt-4"
            >
              Search
            </button>
          </form>
          {/* Display Pokemon List */}
          {pokemonList.length > 0 && (
            <div className="mt-4">
              <h3 className="font-semibold">Fetched Pokemon:</h3>
              <ul>
                {pokemonList.map((pokemon, i) => (
                  <li key={i} className="text-gray-700">
                    {pokemon.pokeName} (Name: {pokemon.pokemon_name})
                  </li>
                ))}
              </ul>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
