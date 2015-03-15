package sim.components 
{
	import sim.actors.Actor;
	public class Health implements Component 
	{
		private var _current:int;
		private var _max:int;
		
		public function Health(health:int) 
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
		
		public function getCurrent() :int
		{
			return _current;
		}
		
		public function getMax() :int
		{
			return _max;
		}
		
		public function isDead():Boolean
		{
			return (_current == 0);
		}
		
		public function heal():void
		{
			_current = _max;
		}
		
		public function takeDamage(damage:int):void
		{
			_current = Math.max(_current - damage, 0);
		}
	}
}