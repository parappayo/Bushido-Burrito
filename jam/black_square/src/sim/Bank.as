package sim
{
	import flash.utils.Dictionary;
	
	public class Bank 
	{
		private var _contents:Dictionary;
		
		public function Bank() 
		{
			_contents = new Dictionary();
		}
		
		public function add(id:int, item:Object):void
		{
			_contents[id] = item;
		}
		
		public function remove(id:int):void
		{
			delete _contents[id];
		}
		
		protected function _find(id:int):Object
		{
			if (_contents[id] != undefined)
			{
				return _contents[id];
			}
			return null;
		}
	}
}