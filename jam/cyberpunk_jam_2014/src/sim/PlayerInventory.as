package sim 
{
	import flash.utils.Dictionary;
	import wyverntail.core.Component;
	
	public class PlayerInventory extends Component
	{
		private var _cash :Number; // TODO: BigInt
		public function get cash() :Number { return _cash; }
		
		private var _sharesOwned :Dictionary;
		
		public function PlayerInventory() 
		{
			_sharesOwned = new Dictionary();
			
			_cash = Settings.PlayerStartingCash;
		}
		
		public function addCash(quantity :Number) :void
		{
			_cash += quantity;
		}
		
		public function sharesOwned(corp :Corporation) :uint
		{
			if (_sharesOwned[corp] == null)
			{
				_sharesOwned[corp] = 0;
			}
			
			return _sharesOwned[corp];
		}
		
		public function buyShares(market :StockMarket, corp :Corporation, count :uint) :uint
		{
			if (_sharesOwned[corp] == null)
			{
				_sharesOwned[corp] = 0;
			}
			
			if (corp.stockPrice(market) * count > _cash)
			{
				count = _cash / corp.stockPrice(market);
			}
			
			_cash -= corp.stockPrice(market) * count;			
			_sharesOwned[corp] += count;
			return count;
		}
		
		public function sellShares(market :StockMarket, corp :Corporation, count :uint) :uint
		{
			if (_sharesOwned[corp] == null)
			{
				_sharesOwned[corp] = 0;
				return 0;
			}
			
			if (count > _sharesOwned[corp])
			{
				count = _sharesOwned[corp];
			}
			
			_cash += corp.stockPrice(market) * count;
			_sharesOwned[corp] -= count;
			return count;
		}
		
	} // class

} // package
