
var mongodb = require('mongodb');

var config = require('../config');

var Database = function() {};

Database.connect = function(db, next) {
	if (db) { return next(null, db); }
	mongodb.MongoClient.connect(config.connectionURL, (err, db) => {
		return next(err, db);
	});
};

Database.create = function(record, table, db, next) {

	// records already assigned an id are presumed to be in the db
	if (record._id) { return next(null, record); }

	Database.connect(db, (err, db) => {
		if (err) { return next(err); }

	db.collection(table).insert(record, (err, result) => {
		if (err) { return next(err); }

	record._id = result.insertedIds[0];

	return next(err, record);

	}); });
};

Database.createIfNotExists = function(search, record, table, db, next) {

	Database.connect(db, (err, db) => {
		if (err) { return next(err); }

	Database.get(search, table, db, (err, result) => {
		if (err) { return next(err); }

	if (result) { return next(null, result); }

	Database.create(record, table, db, (err, result) => {
		if (err) { return next(err); }

	return next(null, result);

	}); }); });
};

Database.delete = function(record, table, db, next) {

	if (!record._id) {
		return next(new Error('no record id provided'));
	}

	Database.connect(db, (err, db) => {
		if (err) { return next(err); }

	db.collection(table).remove({ _id: record._id }, (err, result) => {
		if (err) { return next(err); }

	return next(err, result);

	}); });
};

Database.get = function(record, table, db, next) {

	if (!record) {
		return next(new Error('null record query given'));
	}

	Database.connect(db, (err, db) => {
		if (err) { return next(err); }

	db.collection(table).findOne(record, (err, result) => {

	return next(err, result);

	}); });
};

Database.getByID = function(id, table, db, next) {

	if (!id) {
		return next(new Error('null id given'));
	}

	Database.connect(db, (err, db) => {
		if (err) { return next(err); }

	Database.convertId(id, (err, id) => {

	db.collection(table).findOne({'_id' : id}, (err, result) => {

	return next(err, result);

	}); }); });
};

Database.find = function(query, options, table, db, next) {

	Database.connect(db, (err, db) => {
		if (err) { return next(err); }

	db.collection(table).find(query, null, options).toArray((err, result) => {

	return next(err, result);

	}); });
};

Database.convertId = function(id, next) {
	return next(null, new mongodb.ObjectID.createFromHexString(id));
}

module.exports = Database;
