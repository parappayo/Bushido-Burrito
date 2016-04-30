
var config = require('../config');
var database = require('./database');
var history = require('./history');

var Project = function() {};

Project.create = function(project, db, next) {

	database.create(project, 'projects', db, (err, project) => {
		if (err) { return next(err); }

	history.log('created project', project, db, (err) => {

	return next(err, project);

	}); });
};

Project.delete = function(project, db, next) {

	database.delete(project, 'projects', db, (err) => {
		if (err) { return next(err); }

	history.log('deleted project', project, db, (err) => {

	return next(err);

	}); });
};

Project.get = function(project, db, next) {

	return database.get(project, 'projects', db, next);
};

Project.getByID = function(idString, db, next) {

	return database.getByID(idString, 'projects', db, next);
};

Project.find = function(project, db, next) {

	return database.find(project, 'projects', db, next);
};

module.exports = Project;
