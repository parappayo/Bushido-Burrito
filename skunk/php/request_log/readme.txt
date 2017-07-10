
About

This project is a proof of concept request logger as a PHP script.  The idea is to accept HTTP requests and log relevant parameters (URI, remote IP, date, user-agent, etc.) in an efficient way.  This is redundant with features like Apache's access logs, but it does demonstrate basic PHP and MySQL features, and could be useful for web endpoints that want to perform custom request logging.


Install

It is assumed that you have a working HTTP server + PHP + MySQL stack ready to go.

First the MySQL server needs to be primed by running schema.sql to create the request_log database and relevant tables.  Feel free to rename the database, bearing in mind that you need to change the PHP script config to match.  It is recommended that you create a separate MySQL user specifically for use by the request log script, and give this user restricted db access so that it can only read and write the request_log database.

Next, configure the script by setting the variables at the top of request_log.php to match your MySQL access credentials and database name.  You can test the script by simply requesting it such as in a web browser or with curl:

	curl http://localhost/request_log.php

If the script is working correctly, requests will start showing up in the db tables.  Now request_log.php can be included by other scripts and the logging functions can be used.


Usage

Fair warning: if you are actually using this script, you probably want to go over it with a fine toothed comb first.  It is only intended as a demo.

Include request_log.php in your PHP scripts and add log entries using one of the following functions:

	- log_request() - easiest way to log the current request
	- log_request_smart() - if you want to manually give params for a new entry in the smart log table
	- log_request_simple() - if you want to manually give params for a new entry in the simple log table

The smart log table is more compact because it stores agent strings in a separate table, since they are often duplicated.


Known Caveats

IPV6 is not currently supported, however support can be added with a recent enough version of PHP.  First change the column type of remote_ip in the database tables to BINARY(16), and then replace usages of ip2long with inet_pton in the PHP script.
