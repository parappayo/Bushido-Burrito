package sim.components.movement 
{
	public class MoveUpdate 
	{
		public var _up:Boolean;
		public var _down:Boolean;
		public var _left:Boolean;
		public var _right:Boolean;
		
		public function MoveUpdate()
		{
			reset();
		}
		
		public function setValues(up:Boolean, down:Boolean, left:Boolean, right:Boolean):void
		{
			_up = up;
			_down = down;
			_left = left;
			_right = right;
		}
		
		public function reset():void
		{
			_up = false;
			_down = false;
			_left = false;
			_right = false;	
		}
	}
}