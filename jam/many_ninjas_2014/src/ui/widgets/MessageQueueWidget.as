package ui.widgets 
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.text.TextField;
	
	public class MessageQueueWidget extends Sprite
	{
		private var _messages :Vector.<MessageWidget>;
		
		public function MessageQueueWidget() 
		{
			_messages = new Vector.<MessageWidget>();
		}
		
		public function update(elapsed :Number) :void
		{
			for each (var message :MessageWidget in _messages)
			{
				message.update(elapsed);
			}
			
			if (_messages.length > 0 && _messages[_messages.length-1].IsDead)
			{
				removeChild(_messages.pop());
			}
		}
		
		public function addMessage(caption :String) :void
		{
			var message :MessageWidget = new MessageWidget();
			message.Caption = caption;
			_messages.unshift(message);
			addChild(message);
			refreshMessagePositions();
		}
		
		private function refreshMessagePositions() :void
		{
			var y :Number = Settings.ScreenHeight;
			
			for each (var message :MessageWidget in _messages)
			{
				y -= message.height;
				message.y = y;
			}			
		}
		
	} // class

} // package
