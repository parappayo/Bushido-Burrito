
var config = require('../config');
var database = require('./database');
var history = require('./history');

var Language = function() {};

Language.create = function(language, db, next) {

	database.create(language, 'languages', null, (err, language) => {
		if (err) { return next(err); }

	history.log('created language', language, db, (err) => {

	return next(err, language);

	}); });
};

Language.delete = function(language, db, next) {

	database.delete(language, 'languages', null, (err) => {
		if (err) { return next(err); }

	history.log('deleted language', language, db, (err) => {

	return next(err);

	}); });
};

Language.get = function(language, db, next) {

	return database.get(language, 'languages', db, next);
};

Language.getByID = function(idString, db, next) {

	return database.getByID(idString, 'languages', db, next);
};

Language.find = function(language, db, next) {

	return database.find(language, {}, 'languages', db, next);
};

Language.createDefaults = function(db, next) {

	var defaultLanguages = [
		{ "name" : "English" },
		{ "name" : "French" },
		{ "name" : "Italian" },
		{ "name" : "German" },
		{ "name" : "Spanish" },
		{ "name" : "Russian" },
		{ "name" : "Chinese" },
		{ "name" : "Korean" },
		{ "name" : "Japanese" },
	];

	var createdCount = 0;

	for (var i = 0; i < defaultLanguages.length; i++) {

		var language = defaultLanguages[i];

		database.createIfNotExists(language, language, 'languages', db, (err) => {
			if (err) { return next(err); }

		createdCount++;
		if (createdCount == defaultLanguages.length) {
			return next(err);
		}

		});
	}
}

module.exports = Language;
