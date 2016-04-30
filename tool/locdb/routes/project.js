var express = require('express');
var router = express.Router();

var project = require('../src/project');

router.get('/', function(req, res, next) {

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

	project.getByID(req.query.id, null, (err, result) => {
		if (err) { return next(err); }

	if (!result) {
		req.flash('error', 'Project ID not known.')
		return res.redirect('/project');
	}

	res.render('project_view', {
		title : 'Project Settings',
		flashMessage : req.flash('error'),
		user : req.user,
		project : result
	});

	});
});

router.post('/add', function(req, res, next) {

	var project_name = req.body.project_name;

	project.create({
		'name' : project_name
	}, null, (err, result) => {
		if (err) { return next(err); }

	return res.redirect('/project');

	});
});

module.exports = router;
