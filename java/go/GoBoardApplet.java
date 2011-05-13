
import java.applet.Applet;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;

import java.io.*;
import javax.imageio.ImageIO;

import javax.swing.*;
import javax.swing.event.*;

public class GoBoardApplet extends JApplet
{
	GoBoardComponent board;

	public void start() {
		initComponents();
	}

	public void initComponents() {
		setLayout(new BorderLayout());

		board = new GoBoardComponent();
		board.whiteStone = loadImage("white_stone.png");
		board.blackStone = loadImage("black_stone.png");
		add("Center", board);
	}

	private BufferedImage loadImage(String name) {
		File input = new File(name);
		try {
			return ImageIO.read(input);
		} catch (IOException e) {
		}
		return null;
	}

	public static void main(String[] args) {
		JFrame f = new JFrame("Go Board");
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		JApplet ap = new GoBoardApplet();
		ap.init();
		ap.start();
		f.add("Center", ap);
		f.pack();
		f.setVisible(true);
	}
}

