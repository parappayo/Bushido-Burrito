
var language = require('./src/language');

language.createDefaults(null, (err, result) => {

	if (err)
	{
		console.log(err);
		process.exit(1);
	}
	else
	{
		console.log('finished');
		process.exit(0);
	}
});
