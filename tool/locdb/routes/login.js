var express = require('express');
var router = express.Router();

var passport = require('passport');

router.get('/', function(req, res, next) {
	req.logout();
	res.render('login', {
		title: 'Log In',
		flashMessage: req.flash('error'),
		user : req.user
	});
});

router.post('/', passport.authenticate('local', {
		successRedirect: '/project',
		failureRedirect: '/login',
		failureFlash: true
	})
);

module.exports = router;
