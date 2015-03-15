package  
{
	import flash.display.Sprite;
	import flash.text.*;
	
	public class MenuSlot extends Sprite
	{
		private var tf_caption :TextField;
		private var _textFormat :TextFormat;
		
		public function MenuSlot() 
		{
			_textFormat = new TextFormat();
			_textFormat.size = 22;
			_textFormat.font = "Arial";
			
			tf_caption = new TextField();
			tf_caption.selectable = false;
			tf_caption.autoSize = TextFieldAutoSize.LEFT;
			addChild(tf_caption);
		}
		
		public function setItem(item :MenuItem) :void
		{
			tf_caption.text = item.caption;
			tf_caption.setTextFormat(_textFormat);
		}
		
	}

}