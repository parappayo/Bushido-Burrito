using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Tango_Uniform
{
    public enum UnitType
    {
        Invalid,
        Unknown,

        Infantry,
        Armor,
        Artillery,
        AntiArmor,
        MechInfantry,
        Engineer,
    }

    public struct Unit
    {
        public UnitType Type;
        public HexTilePosition Position;

        public Unit(UnitType type, HexTilePosition pos)
        {
            Type = type;
            Position = pos;
        }
    }

    public class UnitData
    {
        Unit[] units;
        int length;

        public UnitData()
        {
            units = new Unit[1];
            length = 0;
        }

        public int Length
        {
            get { return length; }
            set
            {
                if (length < value)
                {
                    units = new Unit[value];
                }
                length = value;
            }
        }

        public Unit this[int i]
        {
            get
            {
                return units[i];
            }
        }

        public void InitializeTestData()
        {
            Length = 20;
            for (int i = 0; i < Length; i++)
            {
                units[i].Type = UnitType.Unknown;
                units[i].Position = new HexTilePosition(i, i);
            }
        }
    }
}
