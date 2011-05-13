
package com.bushidoburrito.go;

import java.applet.Applet;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;

import java.io.*;
import javax.imageio.ImageIO;

import javax.swing.*;
import javax.swing.event.*;

public class GoApplet extends JApplet implements MouseListener
{
	BoardComponent board;

	public void start() {
		initComponents();
	}

	public void initComponents() {
		setLayout(new BorderLayout());

		board = new BoardComponent();
		board.whiteStone = loadImage("white_stone.png");
		board.blackStone = loadImage("black_stone.png");
		board.addMouseListener(this);
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

	public void mousePressed(MouseEvent e) {
		int x = e.getX() / board.getStoneWidth();
		int y = e.getY() / board.getStoneHeight();
		board.takeMove(x, y);
	}

	public void mouseClicked(MouseEvent e) {}
	public void mouseEntered(MouseEvent e) {}
	public void mouseExited(MouseEvent e) {}
	public void mouseReleased(MouseEvent e) {}

	public static void main(String[] args) {
		JFrame f = new JFrame("Go Board");
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		JApplet ap = new GoApplet();
		ap.init();
		ap.start();
		f.add("Center", ap);
		f.pack();
		f.setVisible(true);
	}
}

