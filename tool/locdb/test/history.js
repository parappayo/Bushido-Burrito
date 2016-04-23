
var chai = require('chai');
var history = require('../src/history');

var expect = chai.expect;

var db;

describe('History DB', () => {

	it('can log an event', (next) => {

		history.log('ran tests', null, db, (err, result) => {
			if (err) { throw(err); }

		expect(result).to.not.be.null;
		expect(result).to.have.property('ops');
		expect(result).to.have.property('insertedCount').equals(1);
		expect(result).to.have.property('insertedIds');

		var newLog = result.ops[0];
		expect(newLog).to.have.property('_id');
		expect(newLog).to.have.property('date').lessThan(new Date());
		next();

	}); });
});
