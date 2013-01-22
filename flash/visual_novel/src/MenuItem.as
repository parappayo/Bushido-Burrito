package  
{
	public class MenuItem
	{
		public var caption :String;
		
		private var _id :int;
		private static var _idCounter :int = 0;
		
		public function MenuItem(captionText :String) 
		{
			caption = captionText;
			
			_id = _idCounter++;
		}

		public function getId() :int { return _id; }
	}
}
