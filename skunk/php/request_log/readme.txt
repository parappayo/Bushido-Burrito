
About

This project is a proof of concept request logger as a PHP script.  The idea is to accept HTTP requests and log relevant parameters (URI, remote IP, date, user-agent, etc.) in an efficient way.  This is redundant with features like Apache's access logs, but it does demonstrate basic PHP and MySQL features, and could be useful for web endpoints that want to perform custom request logging.

Install

It is assumed that you have a working HTTP server + PHP + MySQL stack ready to go.

First the MySQL server needs to be primed by running schema.sql to create the request_log database and relevant tables.  Feel free to rename the database, bearing in mind that you need to change the PHP script config to match.  It is recommended that you create a separate MySQL user specifically for use by the request log script, and give this user restricted db access so that it can only read and write the request_log database.

Next, configure the script by setting the variables at the top of request_log.php to match your MySQL access credentials and database name.  You can test the script by simply requesting it such as in a web browser or with curl:

	curl http://localhost/request_log.php

If the script is working correctly, requests will start showing up in the db tables.  Now request_log.php can be included by other scripts and the logging functions can be used.
