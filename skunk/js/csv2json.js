'use strict';

var fs = require('fs');
var csv = require('papaparse');

var rowsOrCols = 'cols';
var inputEncoding = 'utf8';
var inputFilename = process.argv[2];

function rowToDoc(row, columns)
{
	var doc = {};
	for (var i = 1; i < row.length; i++) {
		doc[columns[i]] = row[i];
	}
	return doc;
}

function rowsToDoc(rows)
{
	var result = {};
	if (rows.length < 1) { return result; }
	var columns = rows[0];

	for (var i = 1; i < rows.length; i++) {
		var row = rows[i];
		result[row[0]] = rowToDoc(row, columns);
	}

	return result;
}

function addToColumnDocs(row, columns, columnDocs)
{
	for (var i = 1; i < columns.length; i++) {
		var doc = columnDocs[columns[i]];
		doc[row[0]] = row[i];
	}
}

function colsToDocs(rows)
{
	var result = {};
	if (rows.length < 1) { return result; }
	var columns = rows[0];

	for (var i = 1; i < columns.length; i++) {
		result[columns[i]] = {};
	}

	for (var i = 1; i < rows.length; i++) {
		var row = rows[i];
		addToColumnDocs(row, columns, result);
	}

	return result;
}

fs.readFile(inputFilename, inputEncoding, (err, inputStr) => {

	if (err) { throw err; }

	csv.parse(inputStr, {

		complete: (parsed) => {
			if (parsed.errors.length > 0) {
				throw JSON.stringify(parsed.errors);
			}

			var docs = null;

			if (rowsOrCols == 'cols') {
				docs = colsToDocs(parsed.data);
			} else {
				docs = rowsToDoc(parsed.data);
			}

			console.log(JSON.stringify(docs));
		}
	});
});
