import axios from 'axios';
export const url = 'http://localhost:8008';

export function apiTest() {
  axios
    .get(url)
    .then((data) => {
      console.log(data);
    })
    .catch((e) => {
      console.log('error received');
      console.log(e);
    });
}
export function loadData() {
  axios
    .post(`${url}/reload`)
    .then((data) => {
      console.log(data);
    })
    .catch((e) => {
      console.log(e);
    });
}
