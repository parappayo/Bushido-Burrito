
var config = require('../config');
var database = require('./database');
var history = require('./history');

var Project = function() {};

Project.create = function(project, db, next) {

	database.create(project, 'projects', null, (err, project) => {
		if (err) { return next(err); }

	history.log('created project', project, db, (err) => {
	
	return next(err, project);

	}); });
};

Project.delete = function(project, db, next) {

	database.delete(project, 'projects', null, (err) => {
		if (err) { return next(err); }

	history.log('deleted project', project, db, (err) => {

	return next(err);

	}); });
};

Project.get = function(project, db, next) {

	database.get(project, 'projects', null, (err, result) => {
		if (err) { return next(err); }

	return next(err, result);

	});
};

module.exports = Project;
