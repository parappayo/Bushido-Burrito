
import java.awt.*;
import java.awt.image.*;

public class GoBoardComponent extends Component
{
	boolean isBlackTurn;

	int boardWidth = 19;
	int boardHeight = 19;

	BufferedImage whiteStone = null;
	BufferedImage blackStone = null;

	enum Stone { EMPTY, BLACK, WHITE }

	private Stone[] boardData;

	public GoBoardComponent() {
		isBlackTurn = true;

		boardData = new Stone[boardWidth * boardHeight];
		for (int i = 0; i < boardData.length; i++) {
			boardData[i] = Stone.EMPTY;
		}
	}

	public void takeMove(int x, int y) {
		Stone s = isBlackTurn ? Stone.BLACK : Stone.WHITE;
		isBlackTurn = !isBlackTurn;
		setStone(x, y, s);
		repaint();
	}

	public void setStone(int x, int y, Stone s) {
		boardData[y * boardWidth + x] = s;
	}

	public Stone getStone(int x, int y) {
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
			Stone space = boardData[i];

			if (space == Stone.BLACK) {
				g.drawImage(blackStone, x, y, null);
			} else if (space == Stone.WHITE) {
				g.drawImage(whiteStone, x, y, null);
			}
		}
	}
}

