package ui.widgets 
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.text.TextField;
	
	public class MessageWidget extends Sprite
	{
		private var _age :Number;
		private var _backing :Quad;
		private var _caption :TextField;
		
		public const Lifespan :Number = 5; // seconds
		
		public function MessageWidget() 
		{
			_backing = new Quad(Settings.ScreenWidth, 50, 0xcccccc);
			addChild(_backing);
			_caption = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
			addChild(_caption);
			
			_age = 0;
		}
		
		public function update(elapsed :Number) :void
		{
			_age += elapsed;
			
			alpha = 1 - (_age / Lifespan);
		}
		
		public function get IsDead() :Boolean
		{
			return _age > Lifespan;
		}
		
		public function set Caption(value :String) :void
		{
			_caption.text = value;
		}
		
	} // class

} // package
