/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Setup code for this example server.
*/

var express = require('express');
var bodyParser = require('body-parser');

var index = require('./routes/index');

var app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use('/', index);

module.exports = app;

// const http = require('http');
// const hostname = '127.0.0.1';
// const port = 3000;
// const server = http.createServer((req, res) => {
//   res.statusCode = 200;
//   res.setHeader('Content-Type', 'application/json');
//   res.end('Hello World\n');
// });
// server.listen(port, hostname, () => {
//   console.log(`Server running at http://${hostname}:${port}/`);
// });
