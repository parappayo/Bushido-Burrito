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

# note: action codes >= 0x80 have a data payload
action_codes = {
		# SWF 3 Action Model
		0x04: 'ActionNextFrame',
		0x05: 'ActionPrevFrame',
		0x06: 'ActionPlay',
		0x07: 'ActionStop',
		0x08: 'ActionToggleQuality',
		0x09: 'ActionStopSounds',
		0x81: 'ActionGotoFrame',
		0x83: 'ActionGetURL',
		0x8A: 'ActionWaitForFrame',
		0x8B: 'ActionSetTarget',
		0x8C: 'ActionGotoLabel',

		# SWF 4 Action Model
		0x0A: 'ActionAdd',
		0x0B: 'ActionSubtract',
		0x0C: 'ActionMultiply',
		0x0D: 'ActionDivide',
		0x0E: 'ActionEquals',
		0x0F: 'ActionLess',
		0x10: 'ActionAnd',
		0x11: 'ActionOr',
		0x12: 'ActionNot',
		0x13: 'ActionStringEquals',
		0x14: 'ActionStringLength',
		0x15: 'ActionStringExtract',
		0x17: 'ActionPop',
		0x18: 'ActionToInteger',
		0x1C: 'ActionGetVariable',
		0x1D: 'ActionSetVariable',
		0x20: 'ActionSetTarget2',
		0x21: 'ActionStringAdd',
		0x22: 'ActionGetProperty',
		0x23: 'ActionGetProperty',
		0x24: 'ActionCloneSprite',
		0x25: 'ActionRemoveSprite',
		0x26: 'ActionTrace',
		0x27: 'ActionStartDrag',
		0x28: 'ActionEndDrag',
		0x29: 'ActionStringLess',
		0x30: 'ActionRandomNumber',
		0x31: 'ActionMBStringLength',
		0x32: 'ActionToAscii',
		0x33: 'ActionAsciiToChar',
		0x34: 'ActionGetTime',
		0x35: 'ActionMBStringExtract',
		0x36: 'ActionMBCharToAscii',
		0x37: 'ActionMBAsciiToChar',
		0x8D: 'ActionWaitForFrame2',
		0x96: 'ActionPush',
		0x99: 'ActionJump',
		0x9A: 'ActionGetURL2',
		0x9D: 'ActionIf',
		0x9E: 'ActionCall',
		0x9F: 'ActionGotoFrame2',
		}

def parse_string(data):
	pos = 0
	retval = ''
	while data[pos] != 0:
		retval += chr(data[pos])
		pos += 1
	pos += 1 # skip the null
	return pos, retval

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
		elif self.code == 12:
			self.tag = DoActionTag()
		elif self.code == 39:
			self.tag = DefineSpriteTag()
		elif self.code == 56:
			self.tag = ExportAssetsTag()
		elif self.code == 59:
			self.tag = DoInitActionTag()
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

class Asset:

	def __init__(self):
		self.id = 0
		self.name = ''

	def __str__(self):
		return 'asset name: ' + self.name

	def parse(self, data):
		pos = 0

		format = '<H'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[pos:pos+size])
		pos += size
		self.id = raw[0]

		size, name = parse_string(data[pos:])
		self.name = name
		pos += size

		return pos

class Action:

	def __init__(self):
		self.action_code = 0
		self.data = None

	def __str__(self):
		action_str = ''
		if self.action_code in action_codes:
			action_str = action_codes[self.action_code]
		else:
			action_str = str(self.action_code)
		return 'action code: ' + action_str

	def parse(self, data):
		pos = 0

		format = '<B'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[pos:pos+size])
		pos += size
		self.action_code = raw[0]

		return pos

class DoActionTag:

	def __init__(self):
		self.actions = []

	def __str__(self):
		retval = ''
		for action in self.actions:
			if len(retval) > 0: retval += '\n'
			retval += str(action)
		return retval

	def parse(self, data):
		pos = 0

		while data[pos] != 0:
			action = Action()
			pos += action.parse(data[pos:])
			self.actions.append(action)

		return pos

class DefineSpriteTag:

	def __init__(self):
		self.sprite_id = 0
		self.frame_count = 0
		self.control_tags = []

	def __str__(self):
		retval = ''
		retval += 'sprite id: ' + str(self.sprite_id)
		retval += '\nframe count: ' + str(self.frame_count)
		retval += '\ncontrol tags:'
		for tag in self.control_tags:
			retval += '\n' + str(tag)
		return retval

	def parse(self, data):
		pos = 0

		format = '<HH'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[pos:pos+size])
		pos += size
		self.sprite_id = raw[0]
		self.frame_count = raw[1]

		tag = Tag()
		pos += tag.parse(data[pos:])
		self.control_tags.append(tag)
		while tag.code != 0: # End tag
			tag = Tag()
			pos += tag.parse(data[pos:])
			self.control_tags.append(tag)

		return pos

class ExportAssetsTag:

	def __init__(self):
		self.count = 0
		self.assets = []

	def __str__(self):
		retval = ''
		for asset in self.assets:
			if len(retval) > 0: retval += '\n'
			retval += 'asset name: ' + asset.name
		return retval

	def parse(self, data):
		pos = 0

		format = '<H'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[pos:pos+size])
		pos += size
		self.count = raw[0]

		for i in range(0, self.count):
			asset = Asset()
			pos += asset.parse(data[pos:])
			self.assets.append(asset)

		return pos

class DoInitActionTag:

	def __init__(self):
		self.sprite_id = 0
		self.actions = []

	def __str__(self):
		retval = ''
		retval += 'sprite id: ' + str(self.sprite_id)
		for action in self.actions:
			retval += '\n' + str(action)
		return retval

	def parse(self, data):
		pos = 0

		format = '<H'
		size = struct.calcsize(format)
		raw = struct.unpack(format, data[pos:pos+size])
		pos += size
		self.sprite_id = raw[0]

		while data[pos] != 0:
			action = Action()
			pos += action.parse(data[pos:])
			self.actions.append(action)

		return pos

class ImportAssets2Tag:

	def __init__(self):
		self.url = ''
		self.count = 0
		self.assets = []

	def __str__(self):
		retval = 'url: ' + self.url
		for asset in self.assets:
			retval += '\n'
			retval += 'asset name: ' + asset.name
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
			asset = Asset()
			pos += asset.parse(data[pos:])
			self.assets.append(asset)

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

