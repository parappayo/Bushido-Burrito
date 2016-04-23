var express = require('express');
var router = express.Router();

var project = require('../src/project');

router.get('/', function(req, res, next) {

	project.find(null, null, (err, result) => {

	res.render('project', {
		title: 'Project Settings',
		flashMessage: req.flash('error'),
		user : req.user,
		projects : result
	}); });
});

module.exports = router;
