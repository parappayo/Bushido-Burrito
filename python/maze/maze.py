
import sys, random

class MazeData:

	# maze cell states
	WALL = 0
	OPEN = 1

	# four cardinal dirs
	NORTH = 1
	SOUTH = 2
	EAST = 3
	WEST = 4

	def __init__(self):
		self.width = 0
		self.height = 0
		self.data = []

	def __str__(self):
		retval = ""
		for y in range(0, self.height):
			for x in range(0, self.width):
				i = y * self.width + x
				if self.data[i] == MazeData.WALL:
					retval += '#'
				else:
					retval += ' '
			retval += '\n'
		return retval

	def clear(self, width, height):
		self.width = width
		self.height = height
		self.data = []
		for i in range(0, width * height):
			self.data.append(MazeData.WALL)

	def is_wall(self, x, y):
		if x < 0 or y < 0 or x >= self.width or y >= self.height:
			return False
		return self.data[y * self.width + x] == MazeData.WALL

	def can_carve(self, x, y, from_direction):
		if from_direction == MazeData.NORTH:
			return (self.is_wall(x-1, y) and
				self.is_wall(x+1, y) and
				self.is_wall(x-1, y+1) and
				self.is_wall(x, y+1) and
				self.is_wall(x+1, y+1) )

		if from_direction == MazeData.SOUTH:
			return (self.is_wall(x-1, y) and
				self.is_wall(x+1, y) and
				self.is_wall(x-1, y-1) and
				self.is_wall(x, y-1) and
				self.is_wall(x+1, y-1) )

		if from_direction == MazeData.EAST:
			return (self.is_wall(x, y-1) and
				self.is_wall(x, y+1) and
				self.is_wall(x-1, y-1) and
				self.is_wall(x-1, y) and
				self.is_wall(x-1, y+1) )

		if from_direction == MazeData.WEST:
			return (self.is_wall(x, y-1) and
				self.is_wall(x, y+1) and
				self.is_wall(x+1, y-1) and
				self.is_wall(x+1, y) and
				self.is_wall(x+1, y+1) )

	def generate_depth_first(self, x, y, visited = None):
		if visited == None:
			visited = []
			for i in range(0, self.width * self.height):
				visited.append(False)

		i = y * self.width + x
		self.data[i] = MazeData.OPEN
		visited[i] = True

		neighbours = []
		if x > 1:
			i = y * self.width + x - 1
			if not visited[i]:
				neighbours.append([x-1, y, i, MazeData.EAST])
		if x < self.width - 1:
			i = y * self.width + x + 1
			if not visited[i]:
				neighbours.append([x+1, y, i, MazeData.WEST])
		if y > 1:
			i = (y - 1) * self.width + x
			if not visited[i]:
				neighbours.append([x, y-1, i, MazeData.SOUTH])
		if y < self.height - 1:
			i = (y + 1) * self.width + x
			if not visited[i]:
				neighbours.append([x, y+1, i, MazeData.NORTH])

		while len(neighbours) > 0:
			n = random.choice(neighbours)
			neighbours.remove(n)
			x = n[0]
			y = n[1]
			i = n[2]
			from_dir = n[3]
			if self.can_carve(x, y, from_dir):
				self.generate_depth_first(x, y, visited)
			else:
				visited[i] = True

if __name__ == '__main__':
	maze_data = MazeData()
	maze_data.clear(80, 40)
	maze_data.generate_depth_first(1, 1)
	print(maze_data)

