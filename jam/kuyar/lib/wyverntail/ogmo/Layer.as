package wyverntail.ogmo 
{
	public class Layer 
	{
		public static const LAYER_TYPE_INVALID		:int = 0;
		public static const LAYER_TYPE_GRID			:int = 1;
		public static const LAYER_TYPE_TILES		:int = 2;
		public static const LAYER_TYPE_ENTITIES		:int = 3;
		
		protected var _type :int;
		public function get type() :int { return _type; }
		
		protected var _name :String;
		public function get name() :String { return _name; }
		
		public function Layer() 
		{
			_type = LAYER_TYPE_INVALID;
		}
		
		public function init(data :XML) :void {}
		
	} // class

} // package
