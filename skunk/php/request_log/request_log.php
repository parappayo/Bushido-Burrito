<?php

$mysql_server = 'localhost';
$mysql_user = 'request_log';
$mysql_password = '';

$request_log_db = 'request_log';
$simple_log_db_table = 'simple_log';

// note: inet_pton to support IP6, otherwise ip2long, see also table column of BINARY(16) versus INT
// function_exists('inet_pton') or die('PHP version does not support inet_pton');

function log_request_simple($db, $table_name, $uri, $date_str, $remote_ip, $user_agent) {
	$table_name = mysql_real_escape_string($table_name, $db);
	$uri = mysql_real_escape_string($uri, $db);
	$date_str = mysql_real_escape_string($date_str);
	$remote_ip = ip2long($remote_ip);
	$user_agent = mysql_real_escape_string($user_agent);

	if (!$table_name or !$uri or !$date_str or !$remote_ip or !$user_agent) {
		return FALSE;
	}

	return mysql_query(sprintf(
			"INSERT INTO %s (uri, date, remote_ip, user_agent) VALUES('%s', '%s', '%s', '%s')",
			$table_name,
			$uri,
			$date_str,
			$remote_ip,
			$user_agent),
		$db);
}

function query_log_simple($db, $table_name, $limit=20) {
	$table_name = mysql_real_escape_string($table_name, $db);
	$limit = mysql_real_escape_string($limit, $db);

	return mysql_query(sprintf(
			"SELECT uri, date, remote_ip, user_agent FROM %s ORDER BY date DESC LIMIT %s",
			$table_name,
			$limit),
		$db);
}

function print_html_log_simple($query_result) {
	echo('<table>');
	while ($row = mysql_fetch_array($query_result)) {
		echo(sprintf(
			'<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>',
			$row['uri'],
			$row['date'],
			long2ip($row['remote_ip']),
			$row['user_agent']));
	}
	echo('</table>');
}

function log_request($use_smart_log=TRUE, $use_simple_log=FALSE) {
	global $mysql_server, $mysql_user, $mysql_password;
	global $request_log_db, $simple_log_db_table;

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
		or die('error: failed to log request: ' . mysql_error());

	$query_result = query_log_simple($db, $simple_log_db_table)
		or die('error: failed to query log: ' . mysql_error());

	print_html_log_simple($query_result);

	mysql_close($db);
}

if (basename(__FILE__) == basename($_SERVER["SCRIPT_FILENAME"])) {
	log_request(TRUE, TRUE);
}

?>
