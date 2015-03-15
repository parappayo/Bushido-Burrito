package sim 
{
	public class CharacterAttributes 
	{
		public static const INVALID		:int = 0;
		public static const MIGHT		:int = 1;
		public static const VITALITY	:int = 2;
		public static const FOCUS		:int = 3;
		public static const LORE		:int = 4;
		public static const LEADERSHIP	:int = 5;
		public static const NUM_ATTRIBUTES	:int = 5;
		
		public static function roll() :Array
		{
			var retval :Array = new Array();
			
			for (var i :int = 0; i < 5; i++)
			{
				retval.push(Dice.roll3d8());
			}
			
			retval.sort(Array.NUMERIC);
			retval.reverse();
			return retval;
		}
		
	} // class

} // package
