package sim.actors 
{
	import starling.display.Image;
	import resources.Atlases;
	
	public class Radio extends Prop implements MessageProp
	{
		private var _triggered :Boolean;
		
		public var MessageCaption :String;
		public function getMessageCaption() :String { return MessageCaption; }
		
		public function Radio() 
		{
			var img :Image = new Image(Atlases.ElementsTextures.getTexture("radio"));
			addChild(img);
			
			_triggered = false;
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			var playerDistance :Number = game.getPlayer().worldPosition.distance(worldPosition);
			
			if (!_triggered && playerDistance < Settings.TileW / 2)
			{
				_triggered = true;
				
				// causes Level to grab the radio message
				game.handleActorSignal(Signals.RADIO_USED, this);
				
				// causes the UI Flow to display the dialog
				game.handleSignal(Signals.RADIO_USED);
			}
			
			if (_triggered && playerDistance > Settings.TileW)
			{
				_triggered = false;
			}
		}
		
	} // class

} // package
