
import sys
from html.parser import HTMLParser

class FilterForTables(HTMLParser):
	"""Parses an html document and outputs only table contents."""

	found_table = False
	found_td = False
	found_th = False

	def handle_starttag(self, tag, attribs):
		if tag == "table":
			self.found_table = True
		elif tag == "td":
			self.found_td = True
		elif tag == "th":
			self.found_th = True

	def handle_endtag(self, tag):
		if tag == "table":
			self.found_table = False
		elif tag == "td":
			self.found_td = False
			print(",", end="")
		elif tag == "th":
			self.found_th = False
			print(",", end="")
		elif tag == "tr":
			print("")

	def handle_data(self, data):
		if self.found_td or self.found_th:
			print(data.strip(), end="")

def sanitize_utf8_as_ascii(string):
	return string.encode("ascii", "namereplace").decode()

def process_file(input_file):
	parser = FilterForTables()
	input_str = input_file.read()
	parser.feed(sanitize_utf8_as_ascii(input_str))

if __name__ == "__main__":
	filename = sys.argv[1]
	with open(filename, "r", encoding="utf-8") as input_file:
		process_file(input_file)
