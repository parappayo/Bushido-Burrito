
import os, config

_all_file_paths = False

def is_source_file(filename):
	return filename.endswith(config.source_file_name_endings)

def find_files(root_path, file_test):
	result = []
	for root, dirs, files in os.walk(root_path):
		for file_name in files:
			if not file_test(file_name):
				continue
			path = os.path.join(root, file_name)
			result.append(path)
	return result

def get_all_file_paths():
	global _all_file_paths
	if not _all_file_paths:
		_all_file_paths = find_files(config.project_root, is_source_file)
	return _all_file_paths

if __name__ == "__main__":
	for path in get_all_file_paths():
		print(path)
