var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('express-session');
var flash = require('req-flash');
var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;

var config = require('./config')
var userDB = require('./src/user');
var history = require('./src/history');

var routes = require('./routes/index');
var signup = require('./routes/signup');
var login = require('./routes/login');

passport.use(new LocalStrategy({
		usernameField: 'user',
		passwordField: 'pass',
		passReqToCallback: true
	}, (req, username, password, next) => {

		userDB.get({ 'email': username }, null, (err, user) => {
			if (err) { return next(err); }

		if (!user) {
			return next(null, false, { message: 'User not registered.'})
		}

		userDB.validatePassword(user, password, req.connection, (err, result) => {
			if (err) { return next(err); }

		if (!result) {
			return next(null, false, { message: 'Incorrect password.'})
		}

		return next(null, user);

		}); });
}));

passport.serializeUser(function(user, next) {
 	next(null, user);
});

passport.deserializeUser(function(user, next) {
 	next(null, user);
});

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(session({
	secret: config.sessionSecret,
	resave: true,
	saveUninitialized: true }));
app.use(flash({ locals: 'flash' }));
app.use(passport.initialize());
app.use(passport.session());

app.use('/', routes);
app.use('/signup', signup);
app.use('/login', login);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
	var err = new Error('Not Found');
	err.status = 404;
	next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
	app.use(function(err, req, res, next) {
		res.status(err.status || 500);
		res.render('error', {
			message: err.message,
			error: err
		});
	});
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
	res.status(err.status || 500);
	res.render('error', {
		message: err.message,
		error: {}
	});
});

module.exports = app;
