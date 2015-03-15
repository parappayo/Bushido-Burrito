package ui 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	
	import flash.media.SoundTransform;		
	
	public class NarrationWidget extends Sprite
	{
		private var backing:Quad;
		private var tf_dialog:TextField;
		
		public function NarrationWidget() 
		{		
			backing = new Quad(600, 150, 0x55555555);
			backing.alpha = 0.5;
			backing.x = 100;
			backing.y = 75;
			addChild(backing);
			
			tf_dialog = new TextField(800, 300, "", "FunDead", 24, 0x7C99B4);
			addChild(tf_dialog);
		}
		
		public function setCaption(caption:String):void
		{
			Audio.txtPopup.play(0, 0, new SoundTransform(0.7));
			tf_dialog.text = caption;
		}
	}
}
