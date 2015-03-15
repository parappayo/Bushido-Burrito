package maze
{
	import flash.display.InteractiveObject;
	public class MazeData
	{
		private var _height :int;
		private var _width :int;
		private var _data :Array; // of MazeCell objects
		
		// generation params, define the style of the maze
		public var mainPathLength :int;  // how far to get to the boss
		public var treasurePathLength :int;  // how far off the main path the treasure is
		public var sideRouteMaxLength :int; // how far the side routes can go
		public var sideRouteChance :Number; // odds that a side route will appear in any given main path cell
		public var verbose :Boolean;  // enable debug traces
		
		public var playerStartX :int;
		public var playerStartY :int;
		
		public function get width() :int { return _width; }
		public function get height() :int { return _height; }

		public function MazeData(width :int, height :int)
		{
			_width = width;
			_height = height;

			_data = new Array();
			for (var i :int = 0; i < _width * _height; i++)
			{
				var x :int = i % _width;
				var y :int = i / _width;
				_data[i] = new MazeCell(x, y);
			}
			
			// default generation params
			mainPathLength = 4;
			treasurePathLength = 1;
			sideRouteMaxLength = 2;
			sideRouteChance = 0.6;
		}

		public function toString() :String
		{
			var retval :String = "";
			for (var y :int = 0; y < _height; y++)
			{
				for (var r :int = 0; r < MazeCell.NUM_STRING_ROWS; r++)
				{
					for (var x :int = 0; x < _width; x++)
					{
						var cell :MazeCell = _data[y * _width + x];
						retval += cell.toStringRow(r);
					}
					retval += "\n";
				}
			}
			return retval;
		}
		
		public function getCell(x :int, y :int) :MazeCell
		{
			if (x < 0 || y < 0 || x >= _width || y >= _height) { return null; }
			return _data[y * _width + x];
		}
		
		public function generate() :void
		{
			playerStartX = 2; // start in a couple of spaces to make dead ends less likely
			playerStartY = _height / 2;
			
			var x :int = playerStartX;
			var y :int = playerStartY;
			var cell :MazeCell = _data[y * _width + x];
			var nextCell :MazeCell;
			
			cell.isPlayerStart = true;
			cell.visited = true;
			cell.eastExit = true;
			
			var mainPathStart :MazeCell = getCell(x + 1, y);
			
			if (verbose) { trace("carving main path"); }			
			var bossCell :MazeCell = carveMainPath(mainPathLength + 1, mainPathStart);
			bossCell.isBossRoom = true;
			
			if (verbose) { trace("carving treasure path"); }
			var randMainCell :MazeCell = findRandomMainPathCell(mainPathLength, mainPathStart);
			if (randMainCell)
			{				
				// find a branch off of the main path
				nextCell = null;
				var roll :Number = Math.random() * 4;
				if (roll < 1)
				{
					nextCell = carveNorth(randMainCell, false);
				}
				if (roll < 2 && nextCell == null)
				{
					nextCell = carveSouth(randMainCell, false);
				}
				if (roll < 3 && nextCell == null)
				{
					nextCell = carveEast(randMainCell, false);
				}
				if (nextCell == null)
				{
					nextCell = carveWest(randMainCell, false);
				}
				if (nextCell == null)
				{
					nextCell = carveNorth(randMainCell, false);
				}
				if (nextCell == null)
				{
					nextCell = carveSouth(randMainCell, false);
				}
				
				if (nextCell)
				{
					var treasureRoomCell :MazeCell = carveTreasurePath(treasurePathLength+1, nextCell);
					if (treasureRoomCell)
					{
						treasureRoomCell.isTreasureRoom = true;
					}
				}
			}
			if (verbose && (randMainCell == null || nextCell == null))
			{
				trace("failed to find a start point for treasure path");
			}
			
			if (verbose) { trace("carving side routes"); }
			carveSideRoutes(mainPathLength, mainPathStart);
			
			if (verbose) { trace(this); }
		}
		
		// makes the given cell's exits match its neighbours
		private function fixExits(cell :MazeCell) :void
		{
			var neighbour :MazeCell;

			// west neighbour
			neighbour = getCell(cell.x - 1, cell.y);
			cell.westExit = neighbour && neighbour.eastExit;
			
			// east neighbour
			neighbour = getCell(cell.x + 1, cell.y);
			cell.eastExit = neighbour && neighbour.westExit;
			
			// north neighbour
			neighbour = getCell(cell.x, cell.y - 1);
			cell.northExit = neighbour && neighbour.southExit;

			// south neighbour
			neighbour = getCell(cell.x, cell.y + 1);
			cell.southExit = neighbour && neighbour.northExit;			
		}
		
		// returns carved cell, or null if cell cannot be carved
		private function carveNorth(startCell :MazeCell, canLoop :Boolean) :MazeCell
		{
			var nextCell :MazeCell = getCell(startCell.x, startCell.y - 1);
			if (!nextCell || (!canLoop && nextCell.visited) || !nextCell.canCarveConnection())
			{
				if (verbose) { trace("can't go north, blocked"); }
				return null;
			}
			startCell.northExit = true;
			return nextCell;
		}
		
		// returns carved cell, or null if cell cannot be carved
		private function carveSouth(startCell :MazeCell, canLoop :Boolean) :MazeCell
		{
			var nextCell :MazeCell = getCell(startCell.x, startCell.y + 1);
			if (!nextCell || (!canLoop && nextCell.visited) || !nextCell.canCarveConnection())
			{
				if (verbose) { trace("can't go south, blocked"); }
				return null;
			}
			startCell.southExit = true;
			return nextCell;
		}
		
		// returns carved cell, or null if cell cannot be carved
		private function carveEast(startCell :MazeCell, canLoop :Boolean) :MazeCell
		{
			var nextCell :MazeCell = getCell(startCell.x + 1, startCell.y);
			if (!nextCell || (!canLoop && nextCell.visited) || !nextCell.canCarveConnection())
			{
				if (verbose) { trace("can't go east, blocked"); }
				return null;
			}
			startCell.eastExit = true;
			return nextCell;
		}
		
		// returns carved cell, or null if cell cannot be carved
		private function carveWest(startCell :MazeCell, canLoop :Boolean) :MazeCell
		{
			var nextCell :MazeCell = getCell(startCell.x - 1, startCell.y);
			if (!nextCell || (!canLoop && nextCell.visited) || !nextCell.canCarveConnection())
			{
				if (verbose) { trace("can't go west, blocked"); }
				return null;
			}
			startCell.westExit = true;
			return nextCell;
		}
		
		// returns the final room in the path
		public function carveMainPath(length :int, startCell :MazeCell) :MazeCell
		{
			var nextCell :MazeCell;

			startCell.visited = true;
			startCell.isBossPath = true;
			fixExits(startCell);
			
			// recursion exit condition
			if (length < 2) { return startCell; }

			// the odds favour going east
			var rand :Number = Math.floor(Math.random() * 8);
			if (verbose) { trace("rolled " + rand); }
			if (rand < 3)
			{
				nextCell = carveEast(startCell, false);
			}
			if (rand < 5 && nextCell == null)
			{
				nextCell = carveNorth(startCell, false);
			}
			if (rand < 7 && nextCell == null)
			{
				nextCell = carveSouth(startCell, false);
			}
			// now we need to carve a dir regardless of our roll
			if (nextCell == null)
			{
				nextCell = carveWest(startCell, false);
			}
			if (nextCell == null)
			{
				nextCell = carveEast(startCell, false);
			}
			if (nextCell == null)
			{
				nextCell = carveNorth(startCell, false);
			}
			if (nextCell == null)
			{
				nextCell = carveSouth(startCell, false);
			}
			
			// ran into a dead end
			if (!nextCell) { return startCell; }
			
			return carveMainPath(length - 1, nextCell);
		}

		// returns the final room in the path
		public function carveTreasurePath(length :int, startCell :MazeCell) :MazeCell
		{
			var nextCell :MazeCell;

			startCell.visited = true;
			startCell.isTreasurePath = true;
			fixExits(startCell);
			
			// recursion exit condition
			if (length < 2) { return startCell; }

			// even odds for any direction
			var rand :Number = Math.floor(Math.random() * 4);
			if (verbose) { trace("rolled " + rand); }
			if (rand < 1)
			{
				nextCell = carveEast(startCell, false);
			}
			if (rand < 2 && nextCell == null)
			{
				nextCell = carveNorth(startCell, false);
			}
			if (rand < 3 && nextCell == null)
			{
				nextCell = carveSouth(startCell, false);
			}
			// now we need to carve a dir regardless of our roll
			if (nextCell == null)
			{
				nextCell = carveWest(startCell, false);
			}
			if (nextCell == null)
			{
				nextCell = carveEast(startCell, false);
			}
			if (nextCell == null)
			{
				nextCell = carveNorth(startCell, false);
			}
			if (nextCell == null)
			{
				nextCell = carveSouth(startCell, false);
			}
			
			// ran into a dead end
			if (!nextCell) { return startCell; }
			
			return carveTreasurePath(length - 1, nextCell);
		}
		
		public function carveSideRoute(length :int, startCell :MazeCell) :void
		{
			var nextCell :MazeCell;

			startCell.visited = true;
			startCell.isSidePath = true;
			fixExits(startCell);
			
			// recursion exit condition
			if (length < 2) { return; }

			// even odds for any direction
			var rand :Number = Math.floor(Math.random() * 4);
			if (verbose) { trace("rolled " + rand); }
			if (rand < 1)
			{
				nextCell = carveEast(startCell, true);
			}
			if (rand < 2 && nextCell == null)
			{
				nextCell = carveNorth(startCell, true);
			}
			if (rand < 3 && nextCell == null)
			{
				nextCell = carveSouth(startCell, true);
			}
			// now we need to carve a dir regardless of our roll
			if (nextCell == null)
			{
				nextCell = carveWest(startCell, true);
			}
			if (nextCell == null)
			{
				nextCell = carveEast(startCell, true);
			}
			if (nextCell == null)
			{
				nextCell = carveNorth(startCell, true);
			}
			if (nextCell == null)
			{
				nextCell = carveSouth(startCell, true);
			}
			
			// ran into a dead end
			if (!nextCell) { return; }
			
			return carveSideRoute(length - 1, nextCell);
		}
		
		private function findRandomMainPathCell(length :int, startCell :MazeCell) :MazeCell
		{
			// recursion end condition
			if (!startCell.isBossPath || startCell.isBossRoom) { return null; }
			var roll :Number = Math.random() * length;
			if (roll < 1) { return startCell; }
			
			var nextCell :MazeCell;
			nextCell = getCell(startCell.x + 1, startCell.y); // east
			if (!nextCell || !nextCell.isBossPath)
			{
				nextCell = getCell(startCell.x, startCell.y - 1); // north
			}
			if (!nextCell || !nextCell.isBossPath)
			{
				nextCell = getCell(startCell.x, startCell.y + 1); // south
			}
			if (!nextCell || !nextCell.isBossPath)
			{
				nextCell = getCell(startCell.x - 1, startCell.y); // west
			}
			
			if (nextCell && !nextCell.isBossPath)
			{
				return null;
			}
			
			return findRandomMainPathCell(length - 1, nextCell);
		}
		
		/// This function will go through the main route and randomly carve some
		/// extra detours.
		/// startCell is the first cell in the main path route
		private function carveSideRoutes(length :int, startCell :MazeCell) :void
		{
			// recursion end condition
			if (!startCell) { return; }
			if (length < 2 || !startCell.isBossPath || startCell.isBossRoom) { return; }
			
			var nextCell :MazeCell;
			
			if (Math.random() < sideRouteChance)
			{
				// find a branch off of the main path
				var roll :Number = Math.random() * 4;
				if (roll < 1)
				{
					nextCell = carveNorth(startCell, true);
				}
				if (roll < 2 && nextCell == null)
				{
					nextCell = carveSouth(startCell, true);
				}
				if (roll < 3 && nextCell == null)
				{
					nextCell = carveEast(startCell, true);
				}
				if (nextCell == null)
				{
					nextCell = carveWest(startCell, true);
				}
				if (nextCell == null)
				{
					nextCell = carveNorth(startCell, true);
				}
				if (nextCell == null)
				{
					nextCell = carveSouth(startCell, true);
				}
				
				if (nextCell)
				{
					carveSideRoute(Math.floor(Math.random() * sideRouteMaxLength), nextCell);
				}
			}
			
			// find the next cell in the main path
			nextCell = getCell(startCell.x + 1, startCell.y); // east
			if (!nextCell || !nextCell.isBossPath)
			{
				nextCell = getCell(startCell.x, startCell.y - 1); // north
			}
			if (!nextCell || !nextCell.isBossPath)
			{
				nextCell = getCell(startCell.x, startCell.y + 1); // south
			}
			if (!nextCell || !nextCell.isBossPath)
			{
				nextCell = getCell(startCell.x - 1, startCell.y); // west
			}
			carveSideRoutes(length - 1, nextCell);			
		}
		
	} // class

} // package

