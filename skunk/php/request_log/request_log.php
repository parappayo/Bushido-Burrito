<?php

$mysql_server = 'localhost';
$mysql_user = 'request_log';
$mysql_password = '';

$request_log_db = 'request_log';
$simple_log_db_table = 'simple_log';

// note: inet_pton to support IP6, otherwise ip2long, see also table column of BINARY(16) versus INT
// function_exists('inet_pton') or die('PHP version does not support inet_pton');

function log_request_simple($db, $table_name, $uri, $date_str, $remote_ip, $user_agent) {
	$uri = mysql_real_escape_string($uri, $db);
	$date_str = mysql_real_escape_string($date_str);
	$remote_ip = ip2long($remote_ip);
	$user_agent = mysql_real_escape_string($user_agent);

	if (!$uri or !$date_str or !$remote_ip or !$user_agent) {
		return FALSE;
	}

	return mysql_query(sprintf(
		"INSERT INTO %s (uri, date, remote_ip, user_agent) VALUES('%s', '%s', '%s', '%s')",
		$table_name,
		$uri,
		$date_str,
		$remote_ip,
		$user_agent));
}

$db = mysql_connect($mysql_server, $mysql_user, $mysql_password)
	or die('error: failed to connect to database: ' . mysql_error());

mysql_select_db($request_log_db, $db)
	or die('error: failed to select db: ' . mysql_error());

log_request_simple(
	$db,
	$simple_log_db_table,
	$_SERVER['REQUEST_URI'],
	date('Y-m-d H:i:s'),
	$_SERVER['REMOTE_ADDR'],
	$_SERVER['HTTP_USER_AGENT'])
	or die('error: failed to log request' . mysql_error());

mysql_close($db);

?>
