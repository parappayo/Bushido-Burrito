var express = require('express');
var router = express.Router();

var passport = require('passport');
var userDB = require('../user');

function validateEmailAddress(email) {
	return /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/.test(email);
}

router.get('/', function(req, res, next) {
	res.render('signup', {
		title: 'Account Creation',
		flashMessage: req.flash('error'),
		user : req.user
	});
});

router.post('/', function(req, res, next) {
	var email = req.body.user;
	var pass = req.body.pass;
	var pass_repeat = req.body.pass_repeat;

	var db;
	userDB.get({ "email": email }, db, (err, result) => {
		if (err) { return next(err); }

	if (result) {
		req.flash('error', 'User already registered.')
		return res.redirect('/signup');
	}

	if (!validateEmailAddress(email)) {
		req.flash('error', 'Email address is not valid.')
		return res.redirect('/signup');
	}

	if (pass.length < 8) {
		req.flash('error', 'Password must be at least 8 characters long.')
		return res.redirect('/signup');
	}
	if (pass !== pass_repeat) {
		req.flash('error', 'Passwords did not match.');
		return res.redirect('/signup');
	}

	userDB.create({"email": email, "pass": pass}, db, (err, result) => {
		if (err) { return next(err); }

	return res.redirect('/login');

	}); });
});

module.exports = router;
