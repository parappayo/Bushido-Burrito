package maze
{
	public class MazeCell
	{
		public var northExit :Boolean;
		public var southExit :Boolean;
		public var eastExit :Boolean;
		public var westExit :Boolean;
		
		public static const NUM_STRING_ROWS :int = 3;
		
		public static const WALL_CHAR :String = " ";
		public static const EXIT_CHAR :String = ".";
		public static const ROOM_CHAR :String = "o";
		public static const PLAYER_START_CHAR :String = "@";
		public static const BOSS_ROOM_CHAR :String = "B";
		public static const TREASURE_ROOM_CHAR :String = "T";
		public static const SIDE_ROOM_CHAR :String = ".";
		
		public var isPlayerStart :Boolean;
		public var isBossRoom :Boolean;
		public var isBossPath :Boolean;
		public var isTreasureRoom :Boolean;
		public var isTreasurePath :Boolean;
		public var isSidePath :Boolean;
		
		// used during generation algorithm
		public var visited :Boolean;
		private var _x :int;
		public function get x() :int { return _x; }
		private var _y :int;
		public function get y() :int { return _y; }
		
		public function MazeCell(x :int, y :int)
		{
			_x = x;
			_y = y;
			
			northExit = false;
			southExit = false;
			eastExit = false;
			westExit = false;
			
			isPlayerStart = false;
			isBossRoom = false;
			
			visited = false;
		}
		
		public function getLevelName() :String
		{
			var retval :String = "Room_";
			
			if (isBossRoom)
			{
				retval = "BossRoom_";
			}
			else if (isTreasureRoom)
			{
				retval = "TreasureRoom_";
			}
			
			if (northExit) { retval += "N"; }
			if (southExit) { retval += "S"; }
			if (eastExit) { retval += "E"; }
			if (westExit) { retval += "W"; }
			
			// TODO: randomize the room variant
			retval += "_01";
			
			return retval;
		}
		
		public function canCarveConnection() :Boolean
		{
			return !isPlayerStart && !isBossPath && !isBossRoom && !isTreasurePath && !isTreasureRoom;
		}

		public function toString() :String
		{
			var retval :String = "";
			for (var r :int = 0; r < MazeCell.NUM_STRING_ROWS; r++)
			{
				retval += toStringRow(r);
				retval += "\n";
			}
			return retval;
		}
		
		public function toStringRow(r :int) :String
		{
			var roomChar :String = WALL_CHAR;
			
			if (isPlayerStart)
			{
				roomChar = PLAYER_START_CHAR;
			}
			else if (isBossRoom)
			{
				roomChar = BOSS_ROOM_CHAR;
			}
			else if (isTreasureRoom)
			{
				roomChar = TREASURE_ROOM_CHAR;
			}
			else if (isSidePath)
			{
				roomChar = SIDE_ROOM_CHAR;
			}
			else if (visited)
			{
				roomChar = ROOM_CHAR;
			}
			
			if (r < 1)
			{
				if (northExit)
				{
					return WALL_CHAR + EXIT_CHAR + WALL_CHAR;
				}
				return WALL_CHAR + WALL_CHAR + WALL_CHAR;
			}
			else if (r < 2)
			{
				if (westExit && eastExit)
				{
					return EXIT_CHAR + roomChar + EXIT_CHAR;
				}
				else if (westExit)
				{
					return EXIT_CHAR + roomChar + WALL_CHAR;
				}
				else if (eastExit)
				{
					return WALL_CHAR + roomChar + EXIT_CHAR;
				}
				return WALL_CHAR + roomChar + WALL_CHAR;
			}
			
			// row 3 assumed
			if (southExit)
			{
				return WALL_CHAR + EXIT_CHAR + WALL_CHAR;
			}
			return WALL_CHAR + WALL_CHAR + WALL_CHAR;
		}

	} // class

} // package


