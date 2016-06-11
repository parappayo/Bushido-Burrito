
var config = require('../config');
var database = require('./database');

var History = function() {};

History.log = function(eventType, eventArgs, db, next) {

	database.connect(db, (err, db) => {
		if (err) { return next(err); }

	var history = {
		"type" : eventType,
		"args" : eventArgs,
		"date" : new Date()
	}

	db.collection('history').insert(history, (err, result) => {

	return next(err, result);

	}); });
};

History.find = function(query, db, next) {

	database.find(query, {}, 'history', db, next);
};

History.findMostRecent = function(query, limit, db, next) {

	var options = {
		"limit": limit,
		"sort": [["_id", "desc"]]
		};

	return database.find(query, options, 'history', db, next);
};

module.exports = History;
