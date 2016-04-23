
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

	database.get(language, 'languages', null, (err, result) => {

	return next(err, result);

	});
};

module.exports = Language;
