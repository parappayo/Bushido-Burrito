package entities 
{
	import sim.PlayerInventory;
	import wyverntail.core.Component;
	
	public class Goal extends Component
	{
		private var _game :Game;
		private var _playerInventory :PlayerInventory;
		
		public static const IntroCaption :String = (<![CDATA[
Some of Gladwell's thugs greet you at the door.
"Your funds are insufficient to meet your debt obligations."
"Bring us $50,000, or we'll make an example of you."
You are gruffly turned back out onto the street.
]]> ).toString();

		public function Goal()
		{
			
		}
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			_playerInventory = _game.gameSim.getComponent(PlayerInventory) as PlayerInventory;
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			switch (signal)
			{
				case Signals.ACTIVATE_GOAL:
				{
					if (!_entity.containsComponent(sender))
					{
						return false;
					}
					
					if (_playerInventory.cash < 50000)
					{
						_game.handleSignal(Signals.SHOW_DIALOG, this, { caption : IntroCaption } );
					}
					else
					{
						_game.handleSignal(Signals.VICTORY, this, {});
					}
					
					return true;
				}
			}
			
			return false;
		}

	} // class

} // package
