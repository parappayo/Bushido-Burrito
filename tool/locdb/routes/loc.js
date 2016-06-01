var express = require('express');
var router = express.Router();

var loc = require('../src/loc');

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

	var loc_name = req.body.loc_name;

	project.create({
		'name' : loc_name
	}, null, (err, result) => {
		if (err) { return next(err); }

	return res.redirect('/project');

	});
});

module.exports = router;
