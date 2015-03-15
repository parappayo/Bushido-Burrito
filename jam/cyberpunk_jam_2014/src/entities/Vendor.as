package entities 
{
	import wyverntail.core.Component;
	import wyverntail.core.Entity;
	
	public class Vendor extends Component
	{
		private var _game :Game;
		private var _vendorType :String;
		
		public function Vendor() 
		{
			
		}
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			_vendorType = spawnArgs.type;
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			switch (signal)
			{
				case Signals.ACTIVATE_VENDOR:
				{
					if (!_entity.containsComponent(sender))
					{
						return false;
					}
					
					switch (_vendorType)
					{
						case "stock_market":
							{
								_game.handleSignal(Signals.SHOW_STOCK_MARKET, this, {});
							}
							break;
							
						case "sushi":
							{
								_game.handleSignal(Signals.SHOW_SUSHI, this, {});
							}
							break;
					}
					
					return true;
				}
			}
			
			return false;
		}
	} // class

} // package
