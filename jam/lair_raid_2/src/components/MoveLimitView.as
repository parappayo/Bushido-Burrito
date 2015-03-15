package components 
{
	import starling.display.Sprite;
	import starling.display.Quad;
	import wyverntail.core.*;

	public class MoveLimitView extends Component
	{
		private var _sprite :starling.display.Sprite;
		private var _highlightedComponent :Component;
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_sprite = new starling.display.Sprite();
			_sprite.pivotX = Settings.TileWidth * 0.5;
			_sprite.pivotY = Settings.TileHeight * 0.5;
			_sprite.visible = false;
			prefabArgs.parentSprite.addChild(_sprite);
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			switch (signal)
			{
				case Signals.PLAYER_TURN_START:
				case Signals.AI_TURN_START:
					{
						_sprite.visible = false;
					}
					break;
					
				case Signals.SELECTED_STATE_CHANGED:
					{
						if (sender.selected)
						{
							_highlightedComponent = sender as Component;

							var stats :UnitStats = _highlightedComponent.getComponent(UnitStats) as UnitStats;
							if (stats != null && stats.hasMoved)
							{
								_sprite.visible = false;
								return false;
							}
							
							var mover :TacticalGridMovement = _highlightedComponent.getComponent(TacticalGridMovement) as TacticalGridMovement;
							updateShape(mover);
							_sprite.visible = true;
						}
						else if (sender == _highlightedComponent)
						{
							_sprite.visible = false;
						}
					}
					break;
			}
			
			return false;
		}
		
		private function updateShape(mover :TacticalGridMovement) :void
		{
			_sprite.removeChildren();
			
			// TODO: should be able to handle other movement values
			var movePts :int = 3;
			
			var pos :Position2D = _highlightedComponent.getComponent(Position2D) as Position2D;
			var myGridX :int = Math.floor(pos.worldX / Settings.TileWidth);
			var myGridY :int = Math.floor(pos.worldY / Settings.TileHeight);
			
			for (var gridY :int = myGridY - movePts; gridY <= myGridY + movePts; gridY++)
			{
				for (var gridX :int = myGridX - movePts; gridX <= myGridX + movePts; gridX++)
				{
					var worldX :Number = gridX * Settings.TileWidth;
					var worldY :Number = gridY * Settings.TileHeight;
					if (mover.canMoveTo(worldX, worldY))
					{
						var q :Quad = new Quad(Settings.TileWidth, Settings.TileHeight, 0x0088ff);
						q.x = worldX;
						q.y = worldY;
						q.alpha = 0.2;
						_sprite.addChild(q);
					}
				}
			}
		}
		
	} // class

} // package
