import axios from "axios";
export const url = "http://localhost:8008";

export async function allPokemon() {
  let res = await axios.get(`${url}/matt/all-pokemon`).catch((e) => {
    console.log(e);
  });
  return res.data;
}

export async function pokemonInRegion() {
  let res = await axios.get(`${url}/matt/pokemon-in-region`).catch((e) => {
    console.log(e);
  });
  return res.data;
}

export async function bestWorstMovesType(max) {
  let extreme = max ? "MAX" : "MIN";
  let res = await axios
    .get(`${url}/matt/best-or-worst-avg-moves-by-type`, {
      params: {
        extreme: extreme,
      },
    })
    .catch((e) => {
      console.log(e);
    });
  return res.data;
}
