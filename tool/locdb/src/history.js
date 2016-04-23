
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

History.get = function(query, db, next) {

	if (!query) {
		return next(new Error('null query given'));
	}

	database.connect(db, (err, db) => {
		if (err) { return next(err); }

	db.collection('history').find(query).toArray((err, result) => {

	return next(err, result);

	}); });
};

module.exports = History;
