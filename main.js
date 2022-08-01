import { Elm } from "./src/Main.elm";

import { invoke } from "@tauri-apps/api";

import { Command } from "@tauri-apps/api/shell";

import "./style.css";
import "uno.css";
import "@unocss/reset/tailwind.css";

const root = document.querySelector("#app div");
const app = Elm.Main.init({ node: root });

// app.ports?.invokeFunction.subscribe(function (f) {
//   invoke(f.name, f.args).then((res) => app.ports?.addMessage.send(res));
// });

app.ports?.runShellCommand.subscribe(function (shellCommand) {
  console.log("yo");
  let c = new Command(shellCommand.program, shellCommand.args);
  console.log(c);
  c.execute();
});
