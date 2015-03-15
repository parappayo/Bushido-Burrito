package actors 
{
	/**
	 *  Pathfinding logic, for the ghosts to trail the player.
	 */
	public class BreadCrumbManager extends Actor
	{
		private var crumbs:Vector.<BreadCrumb>;
		
		public function BreadCrumbManager() 
		{
			crumbs = new Vector.<BreadCrumb>();
		}
		
		public function init(worldPosition:Vector2D)
		{
			// pre-populate the vector
			var historyLength:int = 50;
			for (var i:int = 0; i < historyLength; i++)
			{
				addCrumb(worldPosition.x, worldPosition.y);
			}
		}
		
		override public function update(game:Game):void
		{
			crumbs.shift();
		}
		
		public function addCrumb(x:Number, y:Number):void
		{
			var crumb:BreadCrumb = new BreadCrumb(x, y);
			crumbs.push(crumb);
		}
		
		public function getTailCrumb():BreadCrumb
		{
			return crumbs[crumbs.length - 1];
		}
	}
}
