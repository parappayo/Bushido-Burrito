
using UnityEngine;

using System.Collections.Generic;

namespace Tetris
{
    public struct Point
    {
        public int X;
        public int Y;

        public Point(int x, int y) { X = x; Y = y; }
    }

    public enum Rotation
    {
        ZERO = 0,
        NINTEY = 90,
        ONE_EIGHTY = 180,
        TWO_SEVENTY = 270
    }

    public enum BlockType
    {
        I, Z, N, L, R, O, T,
    }

    public class Block : IEnumerable<Point>
    {
        public BlockType BlockType;
        public Rotation Rotation;
        public Point Position;

        public Dictionary<BlockType, Point[]> Geometry = new Dictionary<BlockType, Point[]>()
            {
                { BlockType.I, new Point[4] {
                    new Point(0,0), new Point(0,1), new Point(0,2), new Point(0,3) } },

                { BlockType.Z, new Point[4] {
                    new Point(1,0), new Point(1,1), new Point(0,1), new Point(0,2) } },

                { BlockType.N, new Point[4] {
                    new Point(0,0), new Point(0,1), new Point(1,1), new Point(1,2) } },

                { BlockType.L, new Point[4] {
                    new Point(0,0), new Point(0,1), new Point(0,2), new Point(1,2) } },

                { BlockType.R, new Point[4] {
                    new Point(1,0), new Point(0,0), new Point(0,1), new Point(0,2) } },

                { BlockType.O, new Point[4] {
                    new Point(0,0), new Point(0,1), new Point(1,1), new Point(1,0) } },

                { BlockType.T, new Point[4] {
                    new Point(0,0), new Point(0,1), new Point(1,1), new Point(0,2) } },
            };

        public IEnumerator<Point> GetEnumerator()
        {
            // TODO: need to account for block rotation here
            return (IEnumerator<Point>)Geometry[BlockType].GetEnumerator();
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }

    public class Cell
    {
        public Block OccupiedBlock;
    }

    public class Field
    {
        public readonly uint Width;
        public readonly uint Height;
        private Cell[] Cells;
        private List<Block> PlacedBlocks = new List<Block>();

        public Field(uint width, uint height)
        {
            Width = width;
            Height = height;
            Cells = new Cell[width * height];
        }

        public Cell GetCell(Point position)
        {
            return Cells[position.X * position.Y];
        }

        public bool IsOccupied(Point position)
        {
            return GetCell(position).OccupiedBlock != null;
        }

        public bool CanOccupy(Block block)
        {
            foreach (Point point in block)
            {
                if (IsOccupied(point))
                {
                    return false;
                }
            }

            return true;
        }

        public void Place(Block block)
        {
            PlacedBlocks.Add(block);
        }
    }

    public class Game
    {
        public Block ActiveBlock;
        public Field Field;

        public Game(uint width, uint height)
        {
            Field = new Field(width, height);
        }

        public Block GetNextBlock()
        {
            // TODO: return a random block
            return new Block();
        }

        public void Tick()
        {
            ActiveBlock.Position.Y += 1;

            if (!Field.CanOccupy(ActiveBlock))
            {
                ActiveBlock.Position.Y -= 1;
                Field.Place(ActiveBlock);
                // TODO: check for completed lines
                ActiveBlock = GetNextBlock();
                return;
            }
        }
    }
}

public class TetrisSim : MonoBehaviour
{
    public uint Width = 10;
    public uint Height = 20;

    public Tetris.Game Game;

    private void Start()
    {
        Game = new Tetris.Game(Width, Height);
    }

    private void Update()
    {
        // TODO: timer, tick game every so often
    }
}
