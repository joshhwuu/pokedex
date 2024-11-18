import axios from "axios";

const url = "http://localhost:8008";

export function apiTest() {
  axios
    .get(url)
    .then((data) => {
      console.log(data);
    })
    .catch((e) => {
      console.log("error received");
      console.log(e);
    });
}
