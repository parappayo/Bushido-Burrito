
import sys, os

def convert_parens_to_columns(line):
	open_paren = line.find('(')
	if open_paren == -1:
		return False
	close_paren = line.find('),')
	if close_paren == -1:
		return False
	line = "{},{},{}".format(
		line[:open_paren],
		line[open_paren+1:close_paren],
		line[close_paren+2:])
	return line

def strip_pick_trade_parens(line):
	columns = line.split(',')
	if columns[2].find('(') == -1:
		return line
	open_paren = line.find('(')
	if open_paren == -1:
		return line
	close_paren = line.find(')')
	if close_paren == -1:
		return line
	line = "{},{}".format(
		line[:open_paren-1],
		line[close_paren+3:])
	return line

def emit_filtered_line(line, output_file):
	columns = line.split(',')

	rank = False
	try:
		rank = int(columns[0])
	except ValueError:
		return

	name = columns[1].strip()
	team = columns[4].strip()

	output_file.write("{},{},{}\n".format(rank, name, team))

def process_file(input_file, output_file):
	for line in input_file.readlines():
		if not line[0].isdigit():
			continue

		columns = line.split(',')
		if len(columns) < 5:
			continue

		line = line.strip()
		line = convert_parens_to_columns(line)
		if not line:
			continue

		line = strip_pick_trade_parens(line)

		line = convert_parens_to_columns(line)
		if not line:
			continue

		emit_filtered_line(line, output_file)

if __name__ == "__main__":
	filename = sys.argv[1]
	with open(filename, "r") as input_file:
		process_file(input_file, sys.stdout)
