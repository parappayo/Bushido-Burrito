package sim 
{	
	public class CharacterPool 
	{
		public var Characters :Array;
		
		public function CharacterPool() 
		{
			Characters = new Array();
		}
		
		public function populate(numChars :int, names :CharacterNames) :void
		{
			for (var i :int = 0; i < numChars; i++)
			{
				var c :Character = new Character();
				c.roll(names.random(), CharacterClasses.random());
				Characters.push(c);
			}
		}
		
	} // class

} // package
