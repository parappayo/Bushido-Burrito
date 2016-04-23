
var chai = require('chai');
var languageDB = require('../src/language');

var expect = chai.expect;

var db;

describe('Language DB', () => {

	context('when a language record is present', () => {

		before((next) => {

			languageDB.create({
				'name' : 'Test Language'
			}, db, (err, language) => {
				if (err) { throw(err); }

			next();

		}); });

		after((next) => {

			languageDB.get({
				'name' : 'Test Language'
			}, db, (err, language) => {
				if (err) { throw(err); }

			languageDB.delete({
				'_id' : language._id
			}, db, (err, result) => {
				if (err) { throw(err); }

			next();

		}); }); });

		it('can find language', (next) => {

			languageDB.get({
				'name' : 'Test Language'
			}, db, (err, language) => {
				if (err) { throw(err); }

			expect(language).to.not.be.null;
			expect(language).to.have.property('_id');
			expect(language).to.have.property('name').equals('Test Language');
			next();

		}); });
	});
});
