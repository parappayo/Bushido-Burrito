
var chai = require('chai');
var languageDB = require('../src/language');

var expect = chai.expect;

var db;
var languageId;

describe('Language DB', () => {

	context('when a language record is present', () => {

		before((next) => {

			languageDB.create({
				'name' : 'Test Language'
			}, db, (err, language) => {
				if (err) { throw(err); }

			expect(language).to.have.property('_id');
			languageId = language._id;

			next();

		}); });

		after((next) => {

			languageDB.delete({
				'_id' : languageId
			}, db, (err, result) => {
				if (err) { throw(err); }

			languageDB.get({
				'name' : 'Test Language'
			}, db, (err, language) => {
				if (err) { throw(err); }

			expect(language).to.be.null;

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
