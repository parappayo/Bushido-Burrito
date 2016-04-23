
var Config = function() {};

// set this to a unique value for each deployment
Config.sessionSecret = '68Sdb6JYW14GM9KKOo5C';

// point this at the MongoDB server to use
Config.connectionURL = "mongodb://localhost:27017/locdb";

module.exports = Config;
