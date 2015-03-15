package sim 
{
	public class Settings 
	{
		CONFIG::debug
		{
			public static const SkipUI :Boolean = false;
			public static const GodMode :Boolean = false;
			public static const ShowStats :Boolean = false;
		}
		
		CONFIG::release
		{
			// for ship builds, set to false
			public static const SkipUI :Boolean = false;
			public static const GodMode :Boolean = false;
			public static const ShowStats :Boolean = false;
		}
		
		// for Ouya set to true, for web set to false
		public static const MobileBuild :Boolean = true;
		public static const AcceptButton :String = (MobileBuild) ? "O" : "ENTER";
		
		// global configuration
		public static const TileW :Number = 32;
		public static const TileH :Number = 32;
		public static const ScreenWidth :Number = 800;
		public static const ScreenHeight :Number = 720;
		public static const SpriteFramerate :int = 10; // fps
		
		// screen overlay
		public static const TintColour :int = 0x9edc28;
		public static const TintAlpha :Number = 0.2;
		
		// starting points
		public static const StartingLevels :Array = [
			"Area01_Courtyard", // "Area01_Courtyard", "Area05_Corridor", "Area07_Vault", "Area09_Breakroom"
			"Mission02_Area01_Hilbert",
			"Mission03_Area01",
		];
		
		public static const PauseCaption :String = "Paused";
		
		// smg
		public static const WeaponPickupCaption :String = "You found the M3 SMG";
		
		// mission 1
		public static const MissionIntro1 :String = (<![CDATA[	
[ Urgent Despatch ]
April 27, 1948
To: Sergeant Chuck "Twinkle-Toes" Taylor
The war may be over, but freedom still needs a few good soldiers to defend her.
Kazimir Malevich's minimalist masterpiece, The Black Square, is being held deep within Stalin's censorship dungeon and it is soon to be destroyed.
Your mission is to infiltrate the compound as a lone operative, and secure the painting for posterity.
Press [AcceptButton] to continue
]]> ).toString();

		// mission 2
		public static const MissionIntro2 :String = (<![CDATA[	
[ Urgent Despatch ]
September 14th, 1948
To: Sergeant Chuck "Bloody-Boots" Taylor
Buckle up for more hot Cold War action, soldier.
That wily fiend Stalin has nicked that Black Square once again. He won't rest until no free soul can lay eyes on it.
The painting is being held in an even larger, more dangerous fortress this time. Be careful.
Press [AcceptButton] to continue
]]> ).toString();

		// mission 3
		public static const MissionIntro3 :String = (<![CDATA[	
[ Urgent Despatch ]
February 20th, 1949
To: Sergeant Chuck "Commie-Crusher" Taylor
We're in a real jam this time, and only our best soldier can bail us out. That's you, Chuck.
Stalin's agents have once again seized the Black Square, and this time it is being held in Stalin's Siberian Censorship Super-Compound.
Intel is sketchy and the compound is well fortified. Expect a long and difficult search.
Press [AcceptButton] to continue
]]> ).toString();

		// intro text
		public static const MissionIntros :Array = [
			MissionIntro1,
			MissionIntro2,
			MissionIntro3,
		];
	}
} // package
