
var db_client = require('mongodb').MongoClient;

var config = require('../config');

var Database = function() {};

Database.connect = function(db, next) {
	if (db) { return next(null, db); }
	db_client.connect(config.connectionURL, (err, db) => {
		return next(err, db);
	});
};

module.exports = Database;
