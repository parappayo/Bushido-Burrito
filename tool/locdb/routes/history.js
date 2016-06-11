var express = require('express');
var router = express.Router();

var history = require('../src/history');

router.get('/', function(req, res, next) {

	if (!req.user) {
		req.flash('error', 'Not logged in.')
		return res.redirect('/login');
	}

	var limit = 200; // TODO: expose as user setting
	history.findMostRecent({}, limit, null, (err, result) => {
		if (err) { return next(err); }

	res.render('history', {
		title : 'History',
		flashMessage : req.flash('error'),
		user : req.user,
		history : result,
	});

	});
});

module.exports = router;
