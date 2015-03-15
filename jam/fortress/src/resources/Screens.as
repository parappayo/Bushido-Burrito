// This file is automatically generated by a pre-build step
package resources
{
	import starling.textures.Texture;

	public class Screens
	{
		[Embed(source="../../assets/Textures/Screens/Bears.png")]
		private static var BearsPNG:Class;
		public static var BearsTexture:Texture;

		[Embed(source="../../assets/Textures/Screens/dialogue_popup.png")]
		private static var dialogue_popupPNG:Class;
		public static var dialogue_popupTexture:Texture;

		[Embed(source="../../assets/Textures/Screens/Gameover1.png")]
		private static var Gameover1PNG:Class;
		public static var Gameover1Texture:Texture;

		[Embed(source="../../assets/Textures/Screens/Gameover2.png")]
		private static var Gameover2PNG:Class;
		public static var Gameover2Texture:Texture;

		[Embed(source="../../assets/Textures/Screens/Gameovercredits.png")]
		private static var GameovercreditsPNG:Class;
		public static var GameovercreditsTexture:Texture;

		[Embed(source="../../assets/Textures/Screens/Intro.png")]
		private static var IntroPNG:Class;
		public static var IntroTexture:Texture;

		[Embed(source="../../assets/Textures/Screens/Intro2.png")]
		private static var Intro2PNG:Class;
		public static var Intro2Texture:Texture;

		[Embed(source="../../assets/Textures/Screens/Legal.png")]
		private static var LegalPNG:Class;
		public static var LegalTexture:Texture;

		[Embed(source="../../assets/Textures/Screens/loading_popup.png")]
		private static var loading_popupPNG:Class;
		public static var loading_popupTexture:Texture;

		[Embed(source="../../assets/Textures/Screens/Title.png")]
		private static var TitlePNG:Class;
		public static var TitleTexture:Texture;

		[Embed(source="../../assets/Textures/Screens/Victory.png")]
		private static var VictoryPNG:Class;
		public static var VictoryTexture:Texture;

		public static function init():void
		{
			BearsTexture = Texture.fromBitmap(new BearsPNG());
			dialogue_popupTexture = Texture.fromBitmap(new dialogue_popupPNG());
			Gameover1Texture = Texture.fromBitmap(new Gameover1PNG());
			Gameover2Texture = Texture.fromBitmap(new Gameover2PNG());
			GameovercreditsTexture = Texture.fromBitmap(new GameovercreditsPNG());
			IntroTexture = Texture.fromBitmap(new IntroPNG());
			Intro2Texture = Texture.fromBitmap(new Intro2PNG());
			LegalTexture = Texture.fromBitmap(new LegalPNG());
			loading_popupTexture = Texture.fromBitmap(new loading_popupPNG());
			TitleTexture = Texture.fromBitmap(new TitlePNG());
			VictoryTexture = Texture.fromBitmap(new VictoryPNG());
		}
	}
}