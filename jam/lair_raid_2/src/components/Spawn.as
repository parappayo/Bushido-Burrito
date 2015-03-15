package components 
{
	import wyverntail.core.*;

	public class Spawn extends Component
	{
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			var factory :Factory = prefabArgs.factory;
			var pos :Position2D = getComponent(Position2D) as Position2D;

			var unit :Entity;
			var unitPos :Position2D
			
			if (prefabArgs.playerSide)
			{
				unit = factory.spawn(_entity.scene, "dwarf", { playerControl : true } );
				unitPos = unit.getComponent(Position2D) as Position2D;
				unitPos.worldX = pos.worldX;
				unitPos.worldY = pos.worldY;
			}
			else
			{
				unit = factory.spawn(_entity.scene, "knight", {} );
				unitPos = unit.getComponent(Position2D) as Position2D;
				unitPos.worldX = pos.worldX;
				unitPos.worldY = pos.worldY;
			}
			
			var unitStats :UnitStats = unit.getComponent(UnitStats) as UnitStats;
			unitStats.playerSide = prefabArgs.playerSide;
		}
		
	} // class

} // package
