package  
{
	public class Settings 
	{
		// set all of these to false for ship builds
		public static const SkipUI :Boolean = false;
		public static const ShowStats :Boolean = false;
		public static const GodMode :Boolean = false;
		public static const SkipToBossFight :Boolean = false;
		public static const DisableAudio :Boolean = false;

		public static const ScreenWidth :Number = 800;
		public static const ScreenHeight :Number = 720;
		
		// difficulty tuning
		public static const CharaPoolCount :Number = 50;
		public static const TrashMobCount :Number = 30;
		public static const TrashMobRandomCount :Number = 30;
		public static const BossAdsCount :Number = 20;
		
		public static const LegalCaption :String = (<![CDATA[
Made with FlashDevelop
Starling, Feathers UI
]]> ).toString();

		public static const SplashCaption :String = (<![CDATA[
by Jason Estey
for Fritz Jam 2014
]]> ).toString();
	
		public static const VictoryCaption :String = (<![CDATA[
You have vanquished the vile lair!

Diablo's minions grow stronger.
]]> ).toString();

		public static const GameOverCaption :String = (<![CDATA[
The party got tired and had to turn back.

Get ready to try again.
]]> ).toString();

	} // class
	
} // package
