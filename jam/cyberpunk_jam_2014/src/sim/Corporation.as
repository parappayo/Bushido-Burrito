package sim 
{
	public class Corporation 
	{
		private var _caption :String;
		public function get caption() :String { return _caption; }
		
		private var _stockPrice :Number;
		
		public function Corporation(caption :String, stockPrice :Number)
		{
			_caption = caption;
			_stockPrice = stockPrice;
		}
		
		public function stockPrice(market :StockMarket) :Number
		{
			return _stockPrice * market.marketIndex;
		}

		// returns the total cost
		public function buyShares(market :StockMarket, shares :uint) :Number
		{
			var retval :Number = stockPrice(market) * shares;
			
			_stockPrice *= 1.0001 * shares;
			
			return retval;
		}
		
		public function sellShares(market :StockMarket, shares :uint) :Number
		{
			var retval :Number = stockPrice(market) * shares;

			_stockPrice /= 1.0001 * shares;
			
			return retval;
		}
		
		public function rollPrice() :void
		{
			_stockPrice *= 1 + (Math.random() - 0.5) * 0.0001;
		}
		
		public function toString() :String
		{
			return caption + " (" + _stockPrice + ")";
		}
		
	} // class

} // package
