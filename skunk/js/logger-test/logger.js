
var express = require('express');
const util = require('util');

var router = express.Router();

router.get('/logs', (request, response) => {
	response.setHeader('Content-Type', 'application/json');

	if (router.db) {
		router.db.find({}, (err, docs) => {
			response.send(JSON.stringify(docs));
		});
	} else {
		response.send(JSON.stringify({}));
	}
});

router.post('/logs', (request, response) => {
	var new_log_data = {
		'host': request.headers['host'],
		'user-agent': request.headers['user-agent'],
		'query': request.query,
		'timestamp': Date.now(),
	};

	if (router.db) {
		router.db.insert(new_log_data);
	}

	response.setHeader('Content-Type', 'application/json');
	response.send(JSON.stringify(new_log_data));
});

router.get('/reflection', (request, response) => {
	response.setHeader('Content-Type', 'application/json');
	response.send(util.inspect(request, { compact: false }));
});

module.exports = router;
