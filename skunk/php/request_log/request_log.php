<?php

$mysql_server = 'localhost';
$mysql_user = 'request_log';
$mysql_password = '';

$request_log_db = 'request_log';
$smart_log_db_table = 'smart_log';
$simple_log_db_table = 'simple_log';
$user_agent_db_table = 'user_agent';

// note: inet_pton to support IP6, otherwise ip2long, see also table column of BINARY(16) versus INT
// function_exists('inet_pton') or die('PHP version does not support inet_pton');

function get_log_db_connection() {
	global $mysql_server, $mysql_user, $mysql_password, $request_log_db;

	$db = mysql_connect($mysql_server, $mysql_user, $mysql_password)
		or die('error: failed to connect to database: ' . mysql_error());

	mysql_select_db($request_log_db, $db)
		or die('error: failed to select db: ' . mysql_error());

	return $db;
}

function log_request_simple($db, $uri, $date_str, $remote_ip, $user_agent) {
	global $simple_log_db_table;

	$uri = mysql_real_escape_string($uri, $db);
	$date_str = mysql_real_escape_string($date_str, $db);
	$remote_ip = ip2long($remote_ip);
	$user_agent = mysql_real_escape_string($user_agent, $db);

	if (!$uri or !$date_str or !$remote_ip or !$user_agent) {
		return FALSE;
	}

	return mysql_query(sprintf(
			"INSERT INTO %s (uri, date, remote_ip, user_agent) VALUES('%s', '%s', '%s', '%s')",
			$simple_log_db_table,
			$uri,
			$date_str,
			$remote_ip,
			$user_agent),
		$db);
}

function query_log_simple($db, $table_name, $limit=20) {
	global $simple_log_db_table;

	$limit = mysql_real_escape_string($limit, $db);

	if (!$limit) {
		return FALSE;
	}

	return mysql_query(sprintf(
			"SELECT uri, date, remote_ip, user_agent FROM %s ORDER BY date DESC LIMIT %s",
			$simple_log_db_table,
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

function query_user_agent_id($db, $user_agent) {
	global $user_agent_db_table;

	$user_agent = mysql_real_escape_string($user_agent, $db);

	$query_result = mysql_query(sprintf(
			"SELECT id FROM %s WHERE user_agent = '%s'",
			$user_agent_db_table,
			$user_agent),
		$db);

	return mysql_fetch_array($query_result);
}

function create_user_agent_id($db, $user_agent) {
	global $user_agent_db_table;

	$row = query_user_agent_id($db, $user_agent);

	if ($row) {
		return $row['id'];
	}

	$query_result = mysql_query(sprintf(
			"INSERT INTO %s (user_agent) VALUES('%s')",
			$user_agent_db_table,
			mysql_real_escape_string($user_agent, $db)),
		$db);

	$row = query_user_agent_id($db, $user_agent);

	if ($row) {
		return $row['id'];
	}

	return FALSE;
}

function log_request_smart($db, $uri, $date_str, $remote_ip, $user_agent) {
	global $smart_log_db_table;

	$uri = mysql_real_escape_string($uri, $db);
	$date_str = mysql_real_escape_string($date_str, $db);
	$remote_ip = ip2long($remote_ip);

	$user_agent_id = create_user_agent_id($db, $user_agent);

	if (!$uri or !$date_str or !$remote_ip or !$user_agent_id) {
		return FALSE;
	}

	return mysql_query(sprintf(
			"INSERT INTO %s (uri, date, remote_ip, user_agent_id) VALUES('%s', '%s', '%s', '%s')",
			$smart_log_db_table,
			$uri,
			$date_str,
			$remote_ip,
			$user_agent_id),
		$db);
}

function query_log_smart($db, $table_name, $limit=20) {
	global $simple_log_db_table;

	$limit = mysql_real_escape_string($limit, $db);

	if (!$limit) {
		return FALSE;
	}

	return mysql_query(sprintf(
			"SELECT uri, date, remote_ip, user_agent FROM %s ORDER BY date DESC LIMIT %s",
			$simple_log_db_table,
			$limit),
		$db);
}

function print_html_log_smart($query_result) {
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


function log_request($db, $use_smart_log=TRUE, $use_simple_log=FALSE) {

	if ($use_smart_log) {
		log_request_smart(
			$db,
			$_SERVER['REQUEST_URI'],
			date('Y-m-d H:i:s'),
			$_SERVER['REMOTE_ADDR'],
			$_SERVER['HTTP_USER_AGENT'])
			or die('error: failed to log request: ' . mysql_error());
	}

	if ($use_simple_log) {
		log_request_simple(
			$db,
			$_SERVER['REQUEST_URI'],
			date('Y-m-d H:i:s'),
			$_SERVER['REMOTE_ADDR'],
			$_SERVER['HTTP_USER_AGENT'])
			or die('error: failed to log request: ' . mysql_error());
	}
}

if (basename(__FILE__) == basename($_SERVER["SCRIPT_FILENAME"])) {
	$db = get_log_db_connection();

	log_request($db, TRUE, TRUE);

	echo '<h3>Recent Log Entries</h3>';
	$query_result = query_log_smart($db, $smart_log_db_table)
		or die('error: failed to query log: ' . mysql_error());
	print_html_log_smart($query_result);

	echo '<h3>Recent Simple Log Entries</h3>';
	$query_result = query_log_simple($db, $simple_log_db_table)
		or die('error: failed to query log: ' . mysql_error());
	print_html_log_simple($query_result);

	mysql_close($db);
}

?>
