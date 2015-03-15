package sim 
{
	public class CharacterNames 
	{
		private var _names :Array = [
			"Theseus", "Perseus", "Hector", "Jason", "Odysseus",
			"Siegfried", "Sigurd", "Beowulf", "Alex", "Hiro",
			"Marle", "Magus", "Lucca", "Ayla", "Scala",
			"Wedge", "Vicks", "Locke", "Terra", "Kage",
			"Cyan", "Gau", "Sabin", "Edgar", "Kefka",
			"Zidane", "Vivi", "Freya", "Kuja", "Garland",
			"Freena", "Gadwin", "Guido", "Liete", "Milda",
			"Ryudo", "Elena", "Mareg", "Roan", "Valmar",
			"Guts", "Griffith", "Casca", "Judeau", "Rickert",
			"Vaan", "Ashe", "Penelo", "Balthier", "Fran",
			"Tyrion", "Jaime", "Cersei", "Tywin", "Daenerys",
			"Bran", "Sansa", "Arya", "Robb", "Catelyn",
			"Gendry", "Ygritte", "Shae", "Joffrey",
			"Alanna", "Casey", "Natalie", "Scarjoe", "Claire",
			"Tyrael", "Auriel", "Deckard", "Cain",
			"Cecil", "Rosa", "Kain", "Rydia", "Tellah",
			"Iolo", "Shamino", "Dupre",
			"Parn", "Deedlit", "Etoh", "Slayn", "Ghim",
			"Kubrick", "Malick", "Aaronosfky", "Linklater", "Kar-Wai",
		];
		
		public function random() :String
		{
			if (_names.length < 1) { return "Omega"; }
			
			var i :int = Math.floor(Math.random() * _names.length);
			var retval :String = _names[i];
			
			// ensure uniqueness of names
			_names.splice(i, 1);
			
			return retval;
		}
		
	}

} // package
