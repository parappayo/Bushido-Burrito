
var chai = require('chai');
var userDB = require('../src/user');

var expect = chai.expect;

var db;

describe('User DB', () => {

	context('when a user record is present', () => {

		before((next) => {

			userDB.create({
				'email' : 'Test User',
				'pass' : 'the password'
			}, db, (err, user) => {
				if (err) { throw(err); }

			next();

		}); });

		after((next) => {

			userDB.get({
				'email' : 'Test User'
			}, db, (err, user) => {
				if (err) { throw(err); }

			userDB.delete({
				'_id' : user._id
			}, db, (err, result) => {
				if (err) { throw(err); }

			next();

		}); }); });

		it('can find user by email', (next) => {

			userDB.get({
				'email' : 'Test User'
			}, db, (err, user) => {
				if (err) { throw(err); }

			expect(user).to.not.be.null;
			expect(user).to.have.property('_id');
			expect(user).to.have.property('email').equals('Test User');
			next();

		}); });

		it('can find user by id', (next) => {

			userDB.get({
				'email' : 'Test User'
			}, db, (err, user) => {
				if (err) { throw(err); }

			expect(user).to.not.be.null;
			expect(user).to.have.property('_id');

			userDB.get({
				'_id' : user._id
			}, db, (err, user) => {
				if (err) { throw(err); }

			expect(user).to.not.be.null;
			expect(user).to.have.property('_id');
			expect(user).to.have.property('email').equals('Test User');
			next();

		}); }); });

		it('cannot find bogus user', (next) => {

			userDB.get({
				'email' : 'does not exist'
			}, db, (err, user) => {
				if (err) { throw(err); }

			expect(user).to.be.null;
			next();

		}); });

		it('can validate user password', (next) => {

			userDB.get({
				'email' : 'Test User'
			}, db, (err, user) => {
				if (err) { throw(err); }

			expect(user).to.not.be.null;
			expect(user).to.have.property('pass');

			userDB.validatePassword(user, 'the password', (err, result) => {

			expect(result).to.be.true;
			next();

		}); }); });
	});
});
