
var config = require('../config');
var database = require('./database');
var history = require('./history');

var Loc = function() {};

Loc.create = function(loc, db, next) {

	database.create(loc, 'locs', db, (err, loc) => {
		if (err) { return next(err); }

	history.log('created loc', loc, db, (err) => {

	return next(err, loc);

	}); });
};

Loc.delete = function(loc, db, next) {

	database.delete(loc, 'locs', db, (err) => {
		if (err) { return next(err); }

	history.log('deleted loc', loc, db, (err) => {

	return next(err);

	}); });
};

Loc.get = function(loc, db, next) {

	return database.get(loc, 'locs', db, next);
};

Loc.getByID = function(idString, db, next) {

	return database.getByID(idString, 'locs', db, next);
};

Loc.find = function(loc, db, next) {

	return database.find(loc, {}, 'locs', db, next);
};

Loc.findMostRecent = function(projectId, limit, db, next) {

	var options = {
		"limit": limit,
		"sort": [["changed", "desc"]]
		};

	return database.find({ "project": projectId }, options, 'locs', db, next);
};

module.exports = Loc;
