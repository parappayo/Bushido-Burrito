
package com.bushidoburrito.go;

import java.awt.*;
import java.awt.image.*;

public class BoardComponent extends Component
{
	BufferedImage whiteStone = null;
	BufferedImage blackStone = null;

	BoardData boardData;

	public BoardComponent() {
		startNewGame(19, 19);
	}

	public void startNewGame(int width, int height) {
		boardData = new BoardData(width, height);
	}

	/** Takes x, y as pixel coordinates */
	public boolean takeMove(int x, int y) {
		int boardX = x / getStoneWidth();
		int boardY = y / getStoneHeight();

		boolean retval = boardData.takeMove(boardX, boardY);
		if (retval) {
			repaint();
		}
		return retval;
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
			boardData.getWidth() * getStoneWidth(),
			boardData.getHeight() * getStoneHeight()
			);
	}

	public void paint(Graphics g) {
		Dimension size = getSize();

		g.setColor(Color.LIGHT_GRAY);
		g.fillRect(0, 0, size.width, size.height);

		int w = getStoneWidth();
		int h = getStoneHeight();

		int boardWidth = boardData.getWidth();
		int boardHeight = boardData.getHeight();

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

		for (int y = 0; y < boardHeight; y++) {
			for (int x = 0; x < boardWidth; x++) {
				StoneColor color = boardData.getStone(x, y);

				if (color == StoneColor.BLACK) {
					g.drawImage(blackStone, x*w, y*h, null);
				} else if (color == StoneColor.WHITE) {
					g.drawImage(whiteStone, x*w, y*h, null);
				}
			}
		}
	}
}

