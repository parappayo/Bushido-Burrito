
import sys, re

usage = """
C++ Includes Tool by Jason Estey

> cpp_includes [root file] [project include dirs]

The root file is typically a C or C++ header or source file. A report is generated.
If run without arguments, this message is displayed along with any test output.
"""

# determines what counts as an include line
include_regex = "^\#include[ \t]*[\<\"](.+)[\>\"].*"

# project directories to resolve include paths against
include_dirs = []

# caches results so that redundant recursive branches are not followed
file_cache = dict()

def process_line(line):
	match = re.search(include_regex, line)
	if not match:
		return False
	return match.group(1)

def process_lines(lines):
	includes = []
	for line in lines.splitlines():
		line = process_line(line)
		if (line):
			includes.append(line)
	return includes

def process_file(path):
	if path in file_cache:
		return file_cache[path]
	try:
		with open(path, "r") as input_file:
			result = process_lines(input_file.read())
			file_cache[path] = result
			return result
	except IOError:
		return False
	return False

def process_file_recursive(path, result):
	file_result = process_file(path)
	if not file_result:
		return False
	result[path] = file_result
	for path in file_result:
		if not process_file_recursive(path, result):
			for include_dir in include_dirs:
				include_path = include_dir + path
				if process_file_recursive(include_path, result):
					break
			print "warning: could not find path for include ", path

def run_tests(tests, test_method):
	passed, failed = 0, 0
	for test in tests:
		source = test[0]
		expected = test[1]
		result = test_method(source)
		if result != expected:
			failed += 1
			print("failed %s: expected %s but got %s" % (source, expected, result))
		else:
			passed += 1
	return (passed, failed)

def print_report(result):
	include_counts = map(lambda x: (x[0], len(x[1])), result.iteritems())
	#print result
	for include_count in sorted(include_counts, key=lambda x: int(x[1]), reverse=True):
		print include_count[1], include_count[0]

process_line_tests = [
	[ "#include <narf.h>",		"narf.h" ],
	[ "#include \"narf.h\"",	"narf.h" ],
	[ "#include <../narf.h>",	"../narf.h" ],
]

process_lines_tests = [
	[ """
#include "myself.h"

#include <somestuff.h>
#include <other/stuff.h>

code goes here
	""",
	[ "myself.h", "somestuff.h", "other/stuff.h" ] ]
]

def test():
	"""Exercise the count_includes module with a set of test cases."""
	passed, failed = 0, 0

	result = run_tests(process_line_tests, process_line)
	passed += result[0]
	failed += result[1]

	result = run_tests(process_lines_tests, process_lines)
	passed += result[0]
	failed += result[1]

	print "tests passed: ", passed, " tests failed: ", failed

if __name__ == "__main__":
	if len(sys.argv) < 2:
		print(usage)
		test()
	else:
		include_dirs.extend(sys.argv[2:])

		result = dict()
		process_file_recursive(sys.argv[1], result)

		print_report(result)
