
#  https://en.wikipedia.org/wiki/Soundex

digit_map = {
	'b' : 1,
	'f' : 1,
	'p' : 1,
	'v' : 1,

	'c' : 2,
	'g' : 2,
	'j' : 2,
	'k' : 2,
	'q' : 2,
	's' : 2,
	'x' : 2,
	'z' : 2,

	'd' : 3,
	't' : 3,

	'l' : 4,

	'm' : 5,
	'n' : 5,

	'r' : 6
}

vowels = "aeiouy"
skip_consonants = "hw"

def remove_chars(source, chars):
	"""Return a copy of the string source with any characters found in chars omitted."""
	return "".join(map(lambda x: x if not x in chars else '', source))

def next_digit(source, previous_digit):
	"""Returns the tuple (digit, previous) where "digit" is the encoding for the character given as source,
	and "previous" is the next value to pass in as previous_digit. An encoding value of 0 means the given
	source char should be skipped and so the returned digit should not be appended to the result string."""

	if source in vowels:
		return (0, 0)
	if source in skip_consonants:
		return (0, previous_digit)

	result = digit_map[source]
	if result == previous_digit:
		return (0, 0)
	return (result, result)

def pad_encoding(source):
	"""Ensure that the given encoding is at least four chars, appends enough 0s to ensure that it is."""
	while len(source) < 4: source += '0'
	return source

def encode(source):
	"""Return the soundex encoding of source, in the format of one letter and three decimal digits."""
	if len(source) < 1: return ""

	c = source[0].lower()
	result = c.upper()
	previous_digit = 0
	if (not c in vowels) and (not c in skip_consonants):
		previous_digit = digit_map[c]

	for c in source[1:].lower():
		(digit, previous_digit) = next_digit(c, previous_digit)
		if digit == 0:
			continue

		result += str(digit)
		if len(result) > 3:
			return result

	return pad_encoding(result)

tests = [
	[ "Bleh", "B400" ],
	[ "Robert", "R163" ],
	[ "Rupert", "R163" ],
	[ "Rubin", "R150" ],
	[ "Ashcroft", "A261"],
	[ "Tymczak", "T522" ],
	[ "Pfister", "P236" ]
]

def test():
	"""Exercise the soundex.encode method with a set of test cases."""
	for test in tests:
		source = test[0]
		expected = test[1]
		result = encode(source)
		if result != expected:
			print("failed %s: expected %s but got %s" % (source, expected, result))

if __name__ == "__main__":
	test()
