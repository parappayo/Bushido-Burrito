package sim 
{
	import wyverntail.core.Component;
	
	///
	///  A crude stock exchange sim.  Assumes unlimited availability of shares.
	///
	public class StockMarket extends Component
	{
		public var caption :String;
		public var listedCorporations :Vector.<Corporation>;
		
		// all stocks get multiplied by this
		private var _marketIndex :Number;
		public function get marketIndex() :Number { return _marketIndex; }
		
		private const _updatePeriod :Number = 1.0; // seconds
		private var _elapsed :Number;
		
		private var _playerInventory :PlayerInventory;
		
		public function StockMarket() 
		{
			listedCorporations = new Vector.<Corporation>();
		}

		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_marketIndex = 1;
			_elapsed = 0;
			_playerInventory = getComponent(PlayerInventory) as PlayerInventory;
			
			// cyperpunk jam 2014 settings
			caption = "Neo-Vancouver Stock Exchange";
			listedCorporations.push( new Corporation("Nascent Artifacts (NARF)", 25) );
			listedCorporations.push( new Corporation("Falcon Holobyte (FAHO)", 18) );
			listedCorporations.push( new Corporation("Squire Eldritch (SQEL)", 11) );
			listedCorporations.push( new Corporation("Gladwell Holdings (GLAD)", 7.5) );
			listedCorporations.push( new Corporation("Dunnelwrey Group (DUNG)", 4.5) );
		}

		override public function update(elapsed :Number) :void
		{
			_elapsed += elapsed;
			if (_elapsed > _updatePeriod)
			{
				_elapsed -= _updatePeriod;
				
				// roll for new market index
				_marketIndex += (Math.random() - 0.48) * 0.01;
				
				for each (var c :Corporation in listedCorporations)
				{
					c.rollPrice();
				}
				
				// TODO: send game a signal so that everyone can handle new prices
			}
		}
		
		public function buyShares(corp :Corporation, count :uint) :uint
		{
			return _playerInventory.buyShares(this, corp, count);
		}
		
		public function sellShares(corp :Corporation, count :uint) :uint
		{
			return _playerInventory.sellShares(this, corp, count);
		}
		
		public function sharesOwned(corp :Corporation) :uint
		{
			return _playerInventory.sharesOwned(corp);
		}
		
		public function toString() :String
		{
			var retval :String = "Stock Market " + caption + " (" + _marketIndex + ")";
			for each (var c :Corporation in listedCorporations)
			{
				retval += "\n\t" + c;
			}
			return retval;
		}
		
	} // class

} // package
