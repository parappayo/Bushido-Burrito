
import java.awt.*;
import java.awt.image.*;

public class GoBoardComponent extends Component
{
	int boardWidth = 19;
	int boardHeight = 19;

	BufferedImage whiteStone = null;
	BufferedImage blackStone = null;

	public Dimension getPreferredSize() {

		int stoneWidth = 32;
		int stoneHeight = 32;
		if (whiteStone != null) {
			stoneWidth = whiteStone.getWidth();
			stoneHeight = whiteStone.getHeight();
		}

		return new Dimension(
			boardWidth * stoneWidth,
			boardHeight * stoneHeight
			);
	}

	public void paint(Graphics g) {
		Dimension size = getSize();

		g.setColor(Color.LIGHT_GRAY);
		g.fillRect(0, 0, size.width, size.height);

		// for testing only
		g.drawImage( blackStone, 10, 10, null);
	}
}

