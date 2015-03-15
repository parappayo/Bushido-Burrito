package sim 
{
	public class Pool 
	{
		private var _items:Array;
		private var _capacity:int;
		private var _marker:int;
		
		public function Pool(type:Class, capacity:int) 
		{
			_items = new Array();
			_capacity = capacity;
			_marker = _capacity;
			for (var i:int = 0; i < _capacity; ++i)
			{
				_items[i] = new type();
			}
		}
		
		public function acquire():Object
		{
			var o:Object = null;
			if (_marker > 0)
			{
				o = _items[--_marker];
			}
			else
			{
				new Assert("Pool is exhausted!");
			}
			return o;
		}
		
		public function release(o:Object):void
		{
			if (_marker < _capacity)
			{
				_items[_marker++] = o;
			}
			else
			{
				new Assert("Pool shouldn't exceed its initial size!");
			}
		}
		
		public function getItems():Array
		{
			return _items;
		}
	}
}