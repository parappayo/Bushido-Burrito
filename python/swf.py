import sys, glob, struct, math, zlib

#
#  The code in this file makes much more sense if you refer to the specs for
#  the SWF file format: http://www.adobe.com/devnet/swf/
#

tag_codes = {
		0 : 'End',
		1 : 'ShowFrame',
		2 : 'DefineShape',
		4 : 'PlaceObject',
		5 : 'RemoveObject',
		6 : 'DefineBits',
		7 : 'DefineButton',
		8 : 'JPEGTables',
		9 : 'SetBackgroundColor',
		10: 'DefineFont',
		11: 'DefineText',
		12: 'DoAction',
		13: 'DefineFontInfo',
		14: 'DefineSound',
		15: 'StartSound',
		17: 'DefineButtonSound',
		18: 'SoundStreamHead',
		19: 'SoundStreamBlock',
		20: 'DefineBitsLossless',
		21: 'DefineBitsJPEG2',
		22: 'DefineShape2',
		23: 'DefineButtonCxform',
		24: 'Protect',
		26: 'PlaceObject2',
		28: 'RemoveObject2',
		32: 'DefineShape3',
		33: 'DefineText2',
		34: 'DefineButton2',
		35: 'DefineBitsJPEG3',
		36: 'DefineBitsLossless2',
		37: 'DefineEditText',
		39: 'DefineSprite',
		43: 'FrameLabel',
		45: 'SoundStreamHead2',
		46: 'DefineMorphShape',
		48: 'DefineFont2',
		56: 'ExportAssets',
		57: 'ImportAssets',
		58: 'EnableDebugger',
		59: 'DoInitAction',
		60: 'DefineVideoStream',
		61: 'VideoFrame',
		62: 'DefineFontInfo2',
		64: 'EnableDebugger2',
		65: 'ScriptLimits',
		66: 'SetTabIndex',
		69: 'FileAttributes',
		70: 'PlaceObject3',
		71: 'ImportAssets2',
		73: 'DefineFontAlignZones',
		74: 'CSMTextSettings',
		75: 'DefineFont3',
		76: 'SymbolClass',
		77: 'Metadata',
		78: 'DefineScalingGrid',
		82: 'DoABC',
		83: 'DefineShape4',
		84: 'DefineMorphShape2',
		86: 'DefineSceneAndFrameLabelData',
		87: 'DefineBinaryData',
		88: 'DefineFontName',
		89: 'StartSound2',
		90: 'DefineBitsJPEG4',
		91: 'DefineFont4',
		}

def parse_string(data):
	pos = 0
	retval = ''
	while data[pos] != 0:
		retval += chr(data[pos])
		pos += 1
	pos += 1 # skip the null
	return pos, retval

# used by ImportAssets, ExportAssets, ImportAssets2 tags
def parse_asset(assets, data):
	pos = 0
	asset = {}

	format = '<H'
	size = struct.calcsize(format)
	raw = struct.unpack(format, data[pos:pos+size])
	pos += size
	asset['id'] = raw[0]

	size, name = parse_string(data[pos:])
	asset['name'] = name
	pos += size

	assets.append(asset)

	return pos

class Tag:

	def __init__(self):
		self.code = 0
		self.length = 0
		self.tag = None

	def __str__(self):
		retval = '[' + tag_codes[self.code] + ']'
		if self.tag:
			retval += '\n'
			retval += str(self.tag)
		return retval

	def parse(self, data):
		pos = 0
		pos += self.parse_header(data[pos:])
		pos += self.parse_body(data[pos:])
		return pos

	def parse_header(self, data):
		format = '<H'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[:size])

		code_mask = 0xffc0
		length_mask = 0x3f

		self.code = raw[0] & code_mask
		self.code >>= 6
		self.length = raw[0] & length_mask

		if self.length == 0x3f:
			# large header
			format = '<HI'
			size = struct.calcsize(format)
			raw = struct.unpack(format, data[:size])
			self.length = raw[1]

		return size

	def parse_body(self, data):
		# based on self.code, parse the correct tag data
		if self.code == 0:
			# End tag, do nothing
			self.tag = None
		elif self.code == 56:
			self.tag = ExportAssetsTag()
		elif self.code == 71:
			self.tag = ImportAssets2Tag()
		if self.tag:
			self.tag.parse(data)
		return self.length

class Rect:

	def __init__(self):
		self.n_bits = 0
		self.x_min = 0
		self.x_max = 0
		self.y_min = 0
		self.y_max = 0

	def as_dict(self):
		"""Not quite the same as __dict__"""
		retval = {}
		retval['Nbits'] = self.n_bits
		retval['Xmin'] = self.x_min
		retval['Xmax'] = self.x_max
		retval['Ymin'] = self.y_min
		retval['Ymax'] = self.y_max
		return retval

	def parse(self, data):
		# figure out the number of bytes used by the rect
		raw = struct.unpack('B', data[:1])
		self.n_bits = (raw[0] >> 3) & 0x1f
		size = (5 + self.n_bits * 4) / 8;  # bits / 8 = bytes
		size = math.ceil(size)

		# parse out the other four fields
		raw = struct.unpack('B' * size, data[:size])
		rect_data = 0
		for i in range(len(raw)):
			rect_data += raw[len(raw)-i-1] << (i * 8)

		mask = 0
		for i in range(self.n_bits):
			mask |= 1 << i

		pos = 5 + self.n_bits
		mask <<= size*8 - pos
		self.x_min = (rect_data & mask) >> (size*8 - pos)

		mask >>= self.n_bits
		pos += self.n_bits
		self.x_max = (rect_data & mask) >> (size*8 - pos)

		mask >>= self.n_bits
		pos += self.n_bits
		self.y_min = (rect_data & mask) >> (size*8 - pos)

		mask >>= self.n_bits
		pos += self.n_bits
		self.y_max = (rect_data & mask) >> (size*8 - pos)

		return size

class ExportAssetsTag:

	def __init__(self):
		self.count = 0
		self.assets = []

	def __str__(self):
		retval = ''
		for asset in self.assets:
			if len(retval) > 0: retval += '\n'
			retval += 'asset name: ' + asset['name']
		return retval

	def parse(self, data):
		pos = 0

		format = '<H'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[pos:pos+size])
		pos += size
		self.count = raw[0]

		for i in range(0, self.count):
			pos += parse_asset(self.assets, data[pos:])

		return pos

class ImportAssets2Tag:

	def __init__(self):
		self.url = ''
		self.count = 0
		self.assets = []

	def __str__(self):
		retval = 'URL: ' + self.url
		for asset in self.assets:
			retval += '\n'
			retval += 'asset name: ' + asset['name']
		return retval

	def parse(self, data):
		pos = 0

		size, url = parse_string(data[pos:])
		pos += size
		self.url = url

		format = '<BBH'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[pos:pos+size])
		pos += size
		self.count = raw[2]

		for i in range(0, self.count):
			pos += parse_asset(self.assets, data[pos:])

		return pos

class FlashDocument:

	def __init__(self):
		self.signature = ''
		self.version = 0
		self.file_length = 0
		self.frame_size = Rect()
		self.frame_rate = 0
		self.frame_count = 0
		self.tags = []

	def __str__(self):
		retval = str(self.as_dict())
		retval += '\n'
		for tag in self.tags:
			retval += str(tag)
			retval += '\n\n'
		return retval

	def as_dict(self):
		retval = {}
		retval['Signature'] = self.signature
		retval['Version'] = self.version
		retval['FileLength'] = self.file_length
		retval['FrameSize'] = self.frame_size.as_dict()
		retval['FrameRate'] = self.frame_rate
		retval['FrameCount'] = self.frame_count
		return retval

	def is_compressed(self):
		return len(self.signature) == 3 and self.signature[0] == 'C'

	def from_file(self, filename):
		infile = open(filename, 'rb')
		data = infile.read()
		self.parse(data)

	def parse(self, data):
		"""Populates all of the FlashDocument members by parsing out
		the given binary data.
		"""
		pos = 0
		pos += self.parse_header_part1(data[pos:])
		if self.is_compressed():
			data = zlib.decompress(data[pos:])
			pos = 0
		pos += self.frame_size.parse(data[pos:])
		pos += self.parse_header_part2(data[pos:])

		while pos < len(data):
			tag = Tag()
			pos += tag.parse(data[pos:])
			self.tags.append(tag)

		return

	def parse_header_part1(self, data):
		"""Reads the first 8 header bytes of the Flash file.
		After this, it can be determined if the remaining SWF data
		is compressed or not.
		For consistency, the number of bytes parsed is returned.
		"""
		format = '<4BI'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[:size])
		self.signature = chr(raw[0]) + chr(raw[1]) + chr(raw[2])
		self.version = raw[3]
		self.file_length = raw[4]
		return size

	def parse_header_part2(self, data):
		format = '<2BH'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[:size])
		self.frame_rate = raw[1]
		self.frame_rate += raw[0] / 256
		self.frame_count = raw[2]
		return size

def main(args):
	if len(args) < 1:
		print('path to input file needed')
		return

	files = glob.glob(args[0])
	for filename in files:
		doc = FlashDocument()
		doc.from_file(filename)
		print('File: ' + filename)
		print(doc)

if __name__ == '__main__':
	main(sys.argv[1:])

