
var config = require('../config');
var database = require('./database');
var history = require('./history');

var Language = function() {};

Language.create = function(language, db, next) {

	// objects already assigned an id are presumed to be in the db
	if (language._id) { return next(null, language); }

	database.connect(db, (err, db) => {
		if (err) { return next(err); }

	db.collection('languages').insert(language, (err, result) => {
		if (err) { return next(err); }

	language._id = result.insertedIds[0];

	history.log('created language', result, db, (err) => {

	return next(err, language);

	}); }); });
};

Language.delete = function(language, db, next) {

	if (!language._id) {
		return next(new Error('no language id provided'));
	}

	database.connect(db, (err, db) => {
		if (err) { return next(err); }

	db.collection('languages').remove({ _id: language._id }, (err, result) => {
		if (err) { return next(err); }

	history.log('deleted language', language, db, (err) => {

	return next(err, result);

	}); }); });
};

Language.get = function(language, db, next) {

	if (!language) {
		return next(new Error('null query given'));
	}
	if (!language.name) {
		return next(null, null);
	}

	database.connect(db, (err, db) => {
		if (err) { return next(err); }

	db.collection('languages').findOne({'name' : language.name}, (err, result) => {

	return next(err, result);

	}); });
};

module.exports = Language;
