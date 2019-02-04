const http = require("http");
const fs = require("fs");
const html = fs.readFileSync("./index.html");

http
  .createServer((req, res) => {
    console.log(req.url);
    res.writeHeader(200, { "Content-Type": "text/html" });
    res.write(html);
    res.end();
  })
  .listen(8000);
