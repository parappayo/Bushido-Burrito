
var crypto = require('crypto');

var config = require('../config');
var database = require('./database');
var history = require('./history');

function hashPasswordWithSalt(pass, salt, next) {

	crypto.pbkdf2(pass, salt, 20000, 512, 'sha512', (err, hash) => {
		return next(err, hash);
	});
}

function hashPassword(pass, next) {

	crypto.randomBytes(32, (err, salt) => {
		if (err) { return next(err); }

	hashPasswordWithSalt(pass, salt, (err, hash) => {
		return next(err, hash, salt);

	}); });
}

var User = function() {};

User.create = function(user, db, next) {

	// users already assigned an id are presumed to be in the db
	if (user._id) { return next(null, user); }

	database.connect(db, (err, db) => {
		if (err) { return next(err); }

	hashPassword(user.pass, (err, hash, salt) => {
		if (err) { return next(err); }

	user.pass = hash.toString('base64');
	user.salt = salt.toString('base64');

	db.collection('users').insert(user, (err, result) => {
		if (err) { return next(err); }

	user._id = result.insertedIds[0];

	history.log('created user', user, db, (err) => {
	
	return next(err, user);

	}); }); }); });
};

User.delete = function(user, db, next) {

	if (!user._id) {
		return next(new Error('no user id provided'));
	}

	database.connect(db, (err, db) => {
		if (err) { return next(err); }

	db.collection('users').remove({ _id: user._id }, (err, result) => {
		if (err) { return next(err); }

	history.log('deleted user', user, db, (err) => {

	return next(err, result);

	}); }); });
};

User.get = function(user, db, next) {

	if (!user) {
		return next(new Error('null user query given'));
	}

	database.connect(db, (err, db) => {
		if (err) { return next(err); }

	if (user._id) {
		db.collection('users').findOne({ _id: user._id }, (err, result) => {
			return next(err, result);
		});

	} else if (user.email) {
		db.collection('users').findOne({ email: user.email }, (err, result) => {
			return next(err, result);
		});

	} else {
		return next(null, null);
	}

	});
};

User.validatePassword = function(user, pass, next) {

	hashPasswordWithSalt(pass, new Buffer(user.salt, 'base64'), (err, hash, salt) => {
		if (err) { return next(err); }

	return next(null, hash.equals(new Buffer(user.pass, 'base64')));

	});
};

module.exports = User;
