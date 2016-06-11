
var chai = require('chai');
var projectDB = require('../src/project');
var loc = require('../src/loc');

var expect = chai.expect;

var db;
var projectId;

describe('Project DB', () => {

	context('when a project record is present', () => {

		before((next) => {

			projectDB.create({
				'name' : 'Test Project'
			}, db, (err, project) => {
				if (err) { throw(err); }

			expect(project).to.have.property('_id');
			projectId = project._id;

			// TODO: replace with a call that filters duplicates and validates project ID
			loc.create({
				'name' : 'Test Name',
				'source_text' : 'Test Data',
				'project' : projectId,
				'changed' : new Date(),
			}, null, (err, result) => {
				if (err) { return next(err); }

			next();

		}); }); });

		after((next) => {

			projectDB.delete({
				'_id' : projectId
			}, db, (err, result) => {
				if (err) { throw(err); }

			projectDB.get({
				'name' : 'Test Project'
			}, db, (err, project) => {
				if (err) { throw(err); }

			expect(project).to.be.null;

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

		it('has recent loc data', (next) => {

			var mostRecentCount = 5;
			loc.findMostRecent(projectId, mostRecentCount, null, (err, locResult) => {
				if (err) { return next(err); }

			expect(locResult).to.not.be.null;

			var firstResult = locResult[0];
			expect(firstResult).to.have.property('_id');
			expect(firstResult).to.have.property('name').equals('Test Name');
			expect(firstResult).to.have.property('source_text').equals('Test Data');
			expect(firstResult).to.have.property('changed');
			next();

		}); });
	});
});
