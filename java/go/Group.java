
package com.bushidoburrito.go;

import java.util.*;

public class Group
{
	Set<Stone> stones;

	public StoneColor color;

	public Group() {
		stones = new HashSet<Stone>();
		color = StoneColor.EMPTY;
	}

	public boolean contains(Stone stone) {
		for (Iterator i = stones.iterator(); i.hasNext(); ) {
			Stone groupStone = (Stone) i.next();
			if (stone.x == groupStone.x &&
				stone.y == groupStone.y) {

				// TODO: throw an exception if colors don't match
				return true;
			}
		}
		return false;
	}

	public void createFromStone(Stone stone, BoardComponent board) {
		if (stone.color == StoneColor.EMPTY) {
			// TODO: throw an exception here
			System.out.println("error: tried to add empty stone");
			return;
		}
		if (stone.group != null) {
			// TODO: throw an exception here
			System.out.println("error: stone already has group");
			return;
		}
		if (color == StoneColor.EMPTY) {
			color = stone.color;
		} else if (color != stone.color) {
			// TODO: throw an exception here
			System.out.println("error: stone is wrong color");
			return;
		}
		if (contains(stone)) {
			// TODO: throw an exception here
			System.out.println("warning: stone already added");
			return;
		}

		stones.add(stone);
		stone.group = this;

		if (board.getStone(stone.x + 1, stone.y) == stone.color) {
			addNeighbourStone(stone.x + 1, stone.y, board);
		}
		if (board.getStone(stone.x - 1, stone.y) == stone.color) {
			addNeighbourStone(stone.x - 1, stone.y, board);
		}
		if (board.getStone(stone.x, stone.y + 1) == stone.color) {
			addNeighbourStone(stone.x, stone.y + 1, board);
		}
		if (board.getStone(stone.x, stone.y - 1) == stone.color) {
			addNeighbourStone(stone.x, stone.y - 1, board);
		}
	}

	private void addNeighbourStone(int x, int y, BoardComponent board) {
		Stone neighbour = new Stone();
		neighbour.color = color;
		neighbour.x = x;
		neighbour.y = y;
		if (!contains(neighbour)) {
			createFromStone(neighbour, board);
		}
	}

	public int getLibertiesCount(BoardComponent board) {
		int retval = 0;
		for (Iterator i = stones.iterator(); i.hasNext(); ) {
			Stone stone = (Stone) i.next();
			retval += getLibertiesCount(stone, board);
		}
		return retval;
	}

	public int getLibertiesCount(Stone stone, BoardComponent board) {
		int retval = 0;
		if (stone.x > 0 &&
			board.getStone(stone.x - 1, stone.y) == StoneColor.EMPTY) {

			retval += 1;
		}
		if (stone.x < board.boardWidth - 1 &&
			board.getStone(stone.x + 1, stone.y) == StoneColor.EMPTY) {

			retval += 1;
		}
		if (stone.y > 0 &&
			board.getStone(stone.x, stone.y - 1) == StoneColor.EMPTY) {

			retval += 1;
		}
		if (stone.y < board.boardHeight - 1 &&
			board.getStone(stone.x, stone.y + 1) == StoneColor.EMPTY) {

			retval += 1;
		}
		return retval;
	}
}

