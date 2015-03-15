package sim 
{
	public class CharacterClasses 
	{
		public static const INVALID		:int = 0;
		public static const BARD		:int = 1;
		public static const BERZERKER	:int = 2;
		public static const DRUID		:int = 3;
		public static const KNIGHT		:int = 4;
		public static const NINJA		:int = 5;
		public static const PALADIN		:int = 6;
		public static const RANGER		:int = 7;
		public static const SAGE		:int = 8;
		public static const WARLOCK		:int = 9;
		public static const WIZARD		:int = 10;
		public static const NUM_CLASSES :int = 10;
		
		public static function toString(rpgClass :int) :String
		{
			switch (rpgClass)
			{
				case BARD:			return "Bard";
				case BERZERKER:		return "Berzerker";
				case DRUID:			return "Druid";
				case KNIGHT:		return "Knight";
				case NINJA:			return "Ninja";
				case PALADIN:		return "Paladin";
				case RANGER:		return "Ranger";
				case SAGE:			return "Sage";
				case WARLOCK:		return "Warlock";
				case WIZARD:		return "Wizard";
				default:			return "Invalid";
			}
		}
		
		public static function random() :int
		{
			return Math.floor( Math.random() * NUM_CLASSES + 1 );
		}
		
		public static var AttributeOrder :Object;
		
		public static function initAttributeOrder() :void
		{
			AttributeOrder = new Object();
			
			AttributeOrder[BARD] = [
				CharacterAttributes.LEADERSHIP,
				CharacterAttributes.LORE,
				CharacterAttributes.VITALITY,
				CharacterAttributes.MIGHT,
				CharacterAttributes.FOCUS,
				];
				
			AttributeOrder[BERZERKER] = [
				CharacterAttributes.MIGHT,
				CharacterAttributes.VITALITY,
				CharacterAttributes.FOCUS,
				CharacterAttributes.LORE,
				CharacterAttributes.LEADERSHIP,
				];
				
			AttributeOrder[DRUID] = [
				CharacterAttributes.LORE,
				CharacterAttributes.VITALITY,
				CharacterAttributes.LEADERSHIP,
				CharacterAttributes.FOCUS,
				CharacterAttributes.MIGHT,
				];
				
			AttributeOrder[KNIGHT] = [
				CharacterAttributes.MIGHT,
				CharacterAttributes.LEADERSHIP,
				CharacterAttributes.VITALITY,
				CharacterAttributes.FOCUS,
				CharacterAttributes.LORE,
				];
				
			AttributeOrder[NINJA] = [
				CharacterAttributes.VITALITY,
				CharacterAttributes.FOCUS,
				CharacterAttributes.MIGHT,
				CharacterAttributes.LORE,
				CharacterAttributes.LEADERSHIP,
				];
				
			AttributeOrder[PALADIN] = [
				CharacterAttributes.LEADERSHIP,
				CharacterAttributes.VITALITY,
				CharacterAttributes.MIGHT,
				CharacterAttributes.LORE,
				CharacterAttributes.FOCUS,
				];
				
			AttributeOrder[RANGER] = [
				CharacterAttributes.VITALITY,
				CharacterAttributes.MIGHT,
				CharacterAttributes.LORE,
				CharacterAttributes.LEADERSHIP,
				CharacterAttributes.FOCUS,
				];
				
			AttributeOrder[SAGE] = [
				CharacterAttributes.LORE,
				CharacterAttributes.LEADERSHIP,
				CharacterAttributes.FOCUS,
				CharacterAttributes.VITALITY,
				CharacterAttributes.MIGHT,
				];
				
			AttributeOrder[WARLOCK] = [
				CharacterAttributes.LORE,
				CharacterAttributes.FOCUS,
				CharacterAttributes.VITALITY,
				CharacterAttributes.LEADERSHIP,
				CharacterAttributes.MIGHT,
				];
				
			AttributeOrder[WIZARD] = [
				CharacterAttributes.LORE,
				CharacterAttributes.LEADERSHIP,
				CharacterAttributes.FOCUS,
				CharacterAttributes.VITALITY,
				CharacterAttributes.MIGHT,
				];
		}

	} // class

} // package
