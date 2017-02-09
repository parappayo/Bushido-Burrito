
import sys, re ,os

usage = """
C++ Includes Tool

A basic script for generating reports on #includes directive usage.

> cpp_includes [-r] [root] [project include dirs]

Flags:
  -r  scan includes recursively

If the given root option is a file, then the tool scans the given file and
generates a report on which header files it includes.

If the given root option is a directory, then the tool scans C / C++ source
files in the given directory and generates a report showing which files have
the most includes and which files are included the most.

Include dirs are used only if -r is specified. In this case the tool will
recursively scan the included files to see which files they include, so that
the final report gives a more complete picture of header usage.
"""

# determines what counts as an include line
include_regex = "^\#include[ \t]*[\<\"](.+)[\>\"].*"

# determine what counts as a source file
source_file_name_endings = ("h", "hpp", "c", "cpp")

# project directories to resolve include paths against
include_dirs = []

# caches results so that redundant recursive branches are not followed
file_cache = dict()

recursive_mode = False

def is_source_file(filename):
	return filename.endswith(source_file_name_endings)

def find_include(line):
	match = re.search(include_regex, line)
	if not match:
		return False
	return match.group(1)

def find_includes(lines):
	includes = []
	for line in lines.splitlines():
		line = find_include(line)
		if (line):
			includes.append(line)
	return includes

def find_includes_in_file(path):
	if path in file_cache:
		return file_cache[path]
	try:
		with open(path, "r") as input_file:
			result = find_includes(input_file.read())
			file_cache[path] = result
			return result
	except IOError:
		return False
	return False

def find_includes_in_file_recursive(path, result):
	file_result = find_includes_in_file(path)
	if not file_result:
		return False
	result[path] = file_result
	for path in file_result:
		if not find_includes_in_file_recursive(path, result):
			for include_dir in include_dirs:
				include_path = include_dir + path
				if find_includes_in_file_recursive(include_path, result):
					break
			print("warning: could not find path for include ", path)

def find_includes_in_file_tree(root_path, result):
	for root, dirs, files in os.walk(root_path):
		for file_name in files:
			if not is_source_file(file_name):
				continue
			path = os.path.join(root, file_name)
			if recursive_mode:
				find_includes_in_file_recursive(path, result)
			else:
				file_result = find_includes_in_file(path)
				if file_result:
					result[path] = file_result
	return result

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
	for include_count in sorted(include_counts, key=lambda x: int(x[1]), reverse=True):
		print(include_count[1], include_count[0])

include_line_tests = [
	[ "#include <narf.h>",		"narf.h" ],
	[ "#include \"narf.h\"",	"narf.h" ],
	[ "#include <../narf.h>",	"../narf.h" ],
]

include_lines_tests = [
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

	result = run_tests(include_line_tests, find_include)
	passed += result[0]
	failed += result[1]

	result = run_tests(include_lines_tests, find_includes)
	passed += result[0]
	failed += result[1]

	print("tests passed: ", passed, " tests failed: ", failed)

if __name__ == "__main__":

	if len(sys.argv) < 2:
		print(usage)
		test()
		exit()

	root = ""
	result = dict()

	if sys.argv[1] == "-r":
		if len(sys.argv) < 3:
			print(usage)
			exit()
		recursive_mode = True
		root = sys.argv[2]
		include_dirs.extend(sys.argv[3:])
	else:
		root = sys.argv[1]
		include_dirs.extend(sys.argv[2:])

	if os.path.isdir(root):
		find_includes_in_file_tree(root, result)
	elif (recursive_mode):
		find_includes_in_file_recursive(root, result)
	else:
		file_results = find_includes_in_file(root)
		if (file_results):
			result[root] = file_results

	print_report(result)
