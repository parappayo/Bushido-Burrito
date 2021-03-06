
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

	def get_neighbours(self, x, y, visited):
		"""Returns a list of neighbouring, unvisited locations.
		Only north, south, east, and west neighbours are considered.
		Return value is a list of tuples, each tuple contains
			(x, y, i, dir)
		where x,y are grid coords, i is a grid index, and dir
		is the opposite direction that the neighbour is in, or
		in other words the direction of the source location from
		the neighbour cell's point of reference."""

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
		return neighbours

	def generate_depth_first(self, x = 1, y = 1, visited = None):
		if visited == None:
			visited = []
			for i in range(0, self.width * self.height):
				visited.append(False)

		i = y * self.width + x
		self.data[i] = MazeData.OPEN
		visited[i] = True

		neighbours = self.get_neighbours(x, y, visited)
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

	def generate_prims(self, x = 1, y = 1):
		"""Uses Prim's Algorithm to generate a random maze."""

		walls = []
		visited = []
		for i in range(0, self.width * self.height):
			visited.append(False)

		i = y * self.width + x
		self.data[i] = MazeData.OPEN

		neighbours = self.get_neighbours(x, y, visited)
		while len(neighbours) > 0:
			n = random.choice(neighbours)
			neighbours.remove(n)

			x = n[0]
			y = n[1]
			i = n[2]
			from_dir = n[3]

			if self.can_carve(x, y, from_dir):
				self.data[i] = MazeData.OPEN
				neighbours.extend(self.get_neighbours(x, y, visited))
			visited[i] = True

	def generate_simple_binary_tree(self):
		for y in range(0, self.height-2):
			if y % 2 == 0: continue
			for x in range(0, self.width-2):
				if x % 2 == 0: continue

				i = y * self.width + x
				self.data[i] = MazeData.OPEN

				if random.random() < 0.5:
					i = (y + 1) * self.width + x
					self.data[i] = MazeData.OPEN
				else:
					i = y * self.width + (x + 1)
					self.data[i] = MazeData.OPEN

if __name__ == '__main__':
	maze_data = MazeData()
	maze_data.clear(80, 40)
	# maze_data.generate_depth_first()
	maze_data.generate_prims()
	# maze_data.generate_simple_binary_tree()
	print(maze_data)

