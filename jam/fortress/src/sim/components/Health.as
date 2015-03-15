package sim.components 
{
	import sim.actors.Actor;
	public class Health implements Component 
	{
		private var _current:Number;
		private var _max:Number;
		
		public function Health(health:Number) 
		{
			_current = health;
			_max = health;
		}
		
		public function update(game:Game, actor:Actor, elapsed:Number):void 
		{
		}
		
		public function handleSignal(game:Game, actor:Actor, signal:int, args :Object):void 
		{
		}
		
		public function getCurrent() :Number
		{
			return _current;
		}
		
		public function getMax() :Number
		{
			return _max;
		}
		
		public function isDead():Boolean
		{
			return (_current <= 0);
		}
		
		public function heal():void
		{
			_current = _max;
		}
		
		public function takeDamage(damage:Number):void
		{
			_current = Math.max(_current - damage, 0);
		}
	}
}