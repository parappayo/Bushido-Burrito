package ui 
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class HeartrateWidget extends Sprite
	{
		private var rate:Number;
		private var tf_rate:TextField;
		
		public function HeartrateWidget() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			tf_rate = new TextField(200, 60, "", "FunDead", 32, 0x00ffff);
			tf_rate.text = "HEART: " + rate.toString();
			addChild(tf_rate);
		}
		
		public function setRate(rate:Number):void
		{
			this.rate = rate;

			// TODO: animation logic instead of text
			
			if (tf_rate != null)
			{
				tf_rate.text = "HEART: " + rate.toString();
			}
		}
		
	}

}