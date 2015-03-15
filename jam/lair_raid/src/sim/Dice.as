package sim 
{
	public class Dice 
	{
		public static function rolld8() :Number
		{
			return Math.floor(Math.random() * 8 + 1);
		}
		
		public static function roll2d8() :Number
		{
			return rolld8() + rolld8();
		}
		
		public static function roll3d8() :Number
		{
			return rolld8() + rolld8() + rolld8();
		}
		
	} // class

} // package
