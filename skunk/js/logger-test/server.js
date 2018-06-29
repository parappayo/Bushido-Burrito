
var express = require('express');
var nedb = require('nedb');

var logger = require('./logger.js');
logger.db = new nedb({ filename: 'data.db', autoload: true });

var port = 8080;
var server = express();

server.use('/logger', logger);

server.listen(port, () => {
	console.log('now listening on port', port);
});
