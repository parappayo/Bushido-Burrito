
var chai = require('chai');
var projectDB = require('../src/project');

var expect = chai.expect;

var db;

describe('Project DB', () => {

	context('when a project record is present', () => {

		before((next) => {

			projectDB.create({
				'name' : 'Test Project'
			}, db, (err, project) => {
				if (err) { throw(err); }

			next();

		}); });

		after((next) => {

			projectDB.get({
				'name' : 'Test Project'
			}, db, (err, project) => {
				if (err) { throw(err); }

			projectDB.delete({
				'_id' : project._id
			}, db, (err, result) => {
				if (err) { throw(err); }

			next();

		}); }); });

		it('can find project', (next) => {

			projectDB.get({
				'name' : 'Test Project'
			}, db, (err, project) => {
				if (err) { throw(err); }

			expect(project).to.not.be.null;
			expect(project).to.have.property('_id');
			expect(project).to.have.property('name').equals('Test Project');
			next();

		}); });
	});
});
