var express = require('express');
var router = express.Router();

var loc = require('../src/loc');
var project = require('../src/project');

router.get('/', function(req, res, next) {

	if (!req.user) {
		req.flash('error', 'Not logged in.')
		return res.redirect('/login');
	}

	return res.redirect('/project');
});

router.get('/view', function(req, res, next) {

	if (!req.user) {
		req.flash('error', 'Not logged in.')
		return res.redirect('/login');
	}

	if (!req.query.id) {
		req.flash('error', 'Loc ID not provided.')
		return res.redirect('/project');
	}

	loc.getByID(req.query.id, null, (err, result) => {
		if (err) { return next(err); }

	if (!result) {
		req.flash('error', 'Loc ID not known.')
		return res.redirect('/project');
	}

	res.render('loc_view', {
		title : 'Loc View',
		flashMessage : req.flash('error'),
		user : req.user,
		project : result
	});

	});
});

router.post('/add', function(req, res, next) {

	if (!req.user) {
		req.flash('error', 'Not logged in.')
		return res.redirect('/login');
	}

	if (!req.body.project) {
		req.flash('error', 'Project ID not provided.')
		return res.redirect('/project');
	}

	var projectURL = '/project/view?id='+req.body.project;

	if (!req.body.loc_name) {
		req.flash('error', 'Loc Name not provided.')
		return res.redirect(projectURL);
	}

	if (!req.body.source_text) {
		req.flash('error', 'Loc Text not provided.')
		return res.redirect(projectURL);
	}

	// TODO: replace with a call that filters duplicates and validates project ID
	loc.create({
		'name' : req.body.loc_name,
		'source_text' : req.body.source_text,
		'project' : req.body.project,
		'changed' : new Date(),
	}, null, (err, result) => {
		if (err) { return next(err); }

	return res.redirect(projectURL);

	});
});

router.get('/edits', function(req, res, next) {

	if (!req.user) {
		req.flash('error', 'Not logged in.')
		return res.redirect('/login');
	}

	if (!req.query.project) {
		req.flash('error', 'Project ID not provided.')
		return res.redirect('/project');
	}

	project.getByID(req.query.project, null, (err, result) => {
		if (err) { return next(err); }

	if (!result) {
		req.flash('error', 'Project ID not known.')
		return res.redirect('/project');
	}

	var mostRecentCount = 200; // TODO: expose as a user setting
	loc.findMostRecent(req.query.project, mostRecentCount, null, (err, locResult) => {
		if (err) { return next(err); }

	res.render('loc_edits', {
		title : 'Project Loc Edits',
		flashMessage : req.flash('error'),
		user : req.user,
		project : result,
		locs : locResult
	});

	}); });
});

module.exports = router;
