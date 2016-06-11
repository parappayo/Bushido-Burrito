var express = require('express');
var router = express.Router();

var project = require('../src/project');
var loc = require('../src/loc');

router.get('/', function(req, res, next) {

	if (!req.user) {
		req.flash('error', 'Not logged in.')
		return res.redirect('/login');
	}

	project.find(null, null, (err, result) => {

	res.render('project', {
		title : 'Projects',
		flashMessage : req.flash('error'),
		user : req.user,
		projects : result
	});

	});
});

router.get('/view', function(req, res, next) {

	if (!req.user) {
		req.flash('error', 'Not logged in.')
		return res.redirect('/login');
	}

	if (!req.query.id) {
		req.flash('error', 'Project ID not provided.')
		return res.redirect('/project');
	}

	project.getByID(req.query.id, null, (err, result) => {
		if (err) { return next(err); }

	if (!result) {
		req.flash('error', 'Project ID not known.')
		return res.redirect('/project');
	}

	var mostRecentCount = 5; // TODO: expose as a user setting
	loc.findMostRecent(req.query.id, mostRecentCount, null, (err, locResult) => {
		if (err) { return next(err); }

	res.render('project_view', {
		title : 'Project Settings',
		flashMessage : req.flash('error'),
		user : req.user,
		project : result,
		locs : locResult
	});

	}); });
});

router.post('/add', function(req, res, next) {

	if (!req.user) {
		req.flash('error', 'Not logged in.')
		return res.redirect('/login');
	}

	var project_name = req.body.project_name;

	project.create({
		'name' : project_name
	}, null, (err, result) => {
		if (err) { return next(err); }

	return res.redirect('/project');

	});
});

module.exports = router;
