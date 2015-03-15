package common 
{
	public class Dice 
	{
		public static function roll(count :uint, sides :uint) :uint
		{
			var retval :uint;
			for (var i :uint = 0; i < count; i++)
			{
				retval += Math.floor(Math.random() * sides + 1);
			}
			return retval;
		}

		public static function rolld6() :uint
		{
			return Math.floor(Math.random() * 6 + 1);
		}

		public static function roll2d6() :uint
		{
			return rolld6() + rolld6();
		}

		public static function rolld8() :uint
		{
			return Math.floor(Math.random() * 8 + 1);
		}
		
		public static function roll2d8() :uint
		{
			return rolld8() + rolld8();
		}
		
		public static function roll3d8() :uint
		{
			return rolld8() + rolld8() + rolld8();
		}
		
	} // class

} // package
