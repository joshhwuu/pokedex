import axios from 'axios';
import { url } from './shared_api';

export function allPokemon() {
  axios
    .get(`${url}/matt/all-pokemon`)
    .then((res) => {
      console.log(res.data);
      alert(res.data);
    })
    .catch((e) => {
      console.log(e);
    });
}

export function pokemonInRegion() {
  axios
    .get(`${url}/matt/pokemon-in-region`)
    .then((res) => {
      console.log(res.data);
      alert(res.data);
    })
    .catch((e) => {
      console.log(e);
    });
}

export function bestWorstMovesType(max) {
  let extreme = max ? 'MAX' : 'MIN';
  axios
    .get(`${url}/matt/best-or-worst-avg-moves-by-type`, {
      params: {
        extreme: extreme,
      },
    })
    .then((res) => {
      console.log(res.data);
      alert(res.data);
    })
    .catch((e) => {
      console.log(e);
    });
}
