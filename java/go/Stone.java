
package com.bushidoburrito.go;

enum StoneColor { NONE, BLACK, WHITE }

public class Stone
{
	StoneColor color;
	int x, y;
	Group group;

	public int getLibertiesCount(BoardData board) {
		int retval = 0;
		if (x > 0 && board.isEmpty(x - 1, y)) {
			retval += 1;
		}
		if (x < board.getWidth() - 1 && board.isEmpty(x + 1, y)) {
			retval += 1;
		}
		if (y > 0 && board.isEmpty(x, y - 1)) {
			retval += 1;
		}
		if (y < board.getHeight() - 1 && board.isEmpty(x, y + 1)) {
			retval += 1;
		}
		return retval;
}
}

