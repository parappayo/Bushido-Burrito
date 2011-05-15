
// TODO: create a BoardData class to better separate data from UI code

package com.bushidoburrito.go;

import java.awt.*;
import java.awt.image.*;

import java.util.*;

enum StoneColor { EMPTY, BLACK, WHITE }

public class BoardComponent extends Component
{
	boolean isBlackTurn;

	int boardWidth = 19;
	int boardHeight = 19;

	BufferedImage whiteStone = null;
	BufferedImage blackStone = null;

	private StoneColor[] boardData;

	ArrayList<Group> groups;

	public BoardComponent() {
		isBlackTurn = true;

		boardData = new StoneColor[boardWidth * boardHeight];
		for (int i = 0; i < boardData.length; i++) {
			boardData[i] = StoneColor.EMPTY;
		}

		groups = new ArrayList<Group>();
	}

	public boolean takeMove(int x, int y) {
		if (getStone(x, y) != StoneColor.EMPTY) {
			return false;
		}
		StoneColor s = isBlackTurn ? StoneColor.BLACK : StoneColor.WHITE;
		isBlackTurn = !isBlackTurn;
		setStone(x, y, s);
		updateGroups();
		repaint();
		return true;
	}

	private void updateGroups() {
		groups.clear();
		for (int i = 0; i < boardData.length; i++) {
			if (boardData[i] != StoneColor.EMPTY) {
				int x = i % boardWidth;
				int y = i / boardWidth;
				Stone stone = findStone(x, y);

				if (stone == null) {
					stone = new Stone();
					stone.color = boardData[i];
					stone.x = x;
					stone.y = y;

					Group group = new Group();
					group.createFromStone(stone, this);
					if (group.getLibertiesCount(this) == 0) {
						clearStones(group);
					} else {
						groups.add(group);
					}
				}
			}
		}

	}

	private void clearStones(Group group) {
		for (Iterator i = group.stones.iterator(); i.hasNext(); ) {
			Stone stone = (Stone) i.next();
			stone.color = StoneColor.EMPTY;
			boardData[stone.y * boardWidth + stone.x] = StoneColor.EMPTY;
		}
	}

	private Stone findStone(int x, int y) {
		if (boardData[y * boardWidth + x] == StoneColor.EMPTY) {
			return null;
		}
		for (Iterator i = groups.iterator(); i.hasNext(); ) {
			Group group = (Group) i.next();

		}
		return null;
	}

	public void setStone(int x, int y, StoneColor s) {
		if (x < 0 || y < 0 || x > boardWidth || y > boardHeight) { return; }
		boardData[y * boardWidth + x] = s;
	}

	public StoneColor getStone(int x, int y) {
		if (x < 0 || y < 0 || x > boardWidth || y > boardHeight) {
			return StoneColor.EMPTY;
		}
		return boardData[y * boardWidth + x];
	}

	public int getStoneWidth() {
		int retval = 32;
		if (whiteStone != null) { retval = whiteStone.getWidth(); }
		return retval;
	}

	public int getStoneHeight() {
		int retval = 32;
		if (whiteStone != null) { retval = whiteStone.getHeight(); }
		return retval;
	}

	public Dimension getPreferredSize() {
		return new Dimension(
			boardWidth * getStoneWidth(),
			boardHeight * getStoneHeight()
			);
	}

	public void paint(Graphics g) {
		Dimension size = getSize();

		g.setColor(Color.LIGHT_GRAY);
		g.fillRect(0, 0, size.width, size.height);

		int w = getStoneWidth();
		int h = getStoneHeight();

		g.setColor(Color.BLACK);
		for (int x = 0; x < boardWidth; x++) {
			int x1 = x*w + w/2;
			int y1 = h/2;
			int y2 = (boardHeight - 1)*h + h/2;
			g.drawLine(x1, y1, x1, y2);
		}
		for (int y = 0; y < boardHeight; y++) {
			int y1 = y*h + h/2;
			int x1 = w/2;
			int x2 = (boardWidth - 1)*w + w/2;
			g.drawLine(x1, y1, x2, y1);
		}

		for (int i = 0; i < boardData.length; i++) {
			int x = (i % boardWidth) * w;
			int y = (i / boardWidth) * h;
			StoneColor color = boardData[i];

			if (color == StoneColor.BLACK) {
				g.drawImage(blackStone, x, y, null);
			} else if (color == StoneColor.WHITE) {
				g.drawImage(whiteStone, x, y, null);
			}
		}
	}
}

