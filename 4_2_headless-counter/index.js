const { Elm } = require("./elm.js");

const app = Elm.Main.init();
// Elm プログラムからカウント中の数値を受け取る
app.ports.tick.subscribe(count => {
  console.log(count); // 1, 2, 3, ...
});
