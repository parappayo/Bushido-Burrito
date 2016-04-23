var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
	res.render('index', {
		title: 'Welcome',
		flashMessage: req.flash('error'),
		user : req.user
	});
});

module.exports = router;
