package sim.actors 
{
	import starling.display.Image;
	import starling.display.Quad;
	import sim.*;
	import resources.*;
	
	public class PushBlock extends Prop
	{
		public static const STATE_READY			:int = 0;
		public static const STATE_MOVING		:int = 1;
		public static const STATE_USED			:int = 2;
		
		protected var _state :int;
		private var _wasPushedThisFrame :Boolean;
		private var _framesPushed :int;
		private var _pushDir :WorldOrientation;
		private var _pushSource :WorldPosition;
		private var _pushDestination :WorldPosition;
		private var _img :Image;
		
		//private var _debugQuad :starling.display.Quad;
		
		public function PushBlock() 
		{
			_img = new Image(Atlases.ElementsTextures.getTexture("push"));
			addChild(_img);
			
			_state = STATE_READY;
			_wasPushedThisFrame = false;
			_framesPushed = 0;
			_pushDir = new WorldOrientation();
			_pushSource = new WorldPosition();
			_pushDestination = new WorldPosition();
			
			//_debugQuad = new Quad(10, 10, 0xff0000);
			//addChild(_debugQuad);
		}
		
		override public function update(game :Game, elapsed :Number) :void
		{
			switch (_state)
			{
				case STATE_READY:
					{
						if (!_wasPushedThisFrame)
						{
							_framesPushed = 0;
						}
						else
						{
							_framesPushed += 1;
							_wasPushedThisFrame = false;
							
							if (_framesPushed > 20) // roughly 0.5 sec
							{
								_pushSource.copy(worldPosition);
								_pushDestination.x = worldPosition.x + (_pushDir.x * Settings.TileW);
								_pushDestination.y = worldPosition.y + (_pushDir.y * Settings.TileH);
								
								if (game.getWalkmesh().isWalkable(_pushDestination.x, _pushDestination.y))
								{
									_state = STATE_MOVING;
									game.getWalkmesh().setWalkable(_pushDestination.x, _pushDestination.y, false);
								}
							}
						}
					}
					break;
					
				case STATE_MOVING:
					{
						const speed :Number = 2.0;
						
						worldPosition.x += _pushDir.x * speed;
						worldPosition.y += _pushDir.y * speed;
						
						var done :Boolean = false;
						
						if ( (_pushDir.x > 0 && worldPosition.x >= _pushDestination.x) ||
							(_pushDir.x < 0 && worldPosition.x <= _pushDestination.x) )
						{
							worldPosition.x = _pushDestination.x;
							done = true;
						}

						if ( (_pushDir.y > 0 && worldPosition.y >= _pushDestination.y) ||
							(_pushDir.y < 0 && worldPosition.y <= _pushDestination.y) )
						{
							worldPosition.y = _pushDestination.y;
							done = true;
						}
						
						if (done)
						{
							_state = STATE_USED;
							game.getWalkmesh().setWalkable(_pushSource.x, _pushSource.y, true);
							
							removeChild(_img, true);
							_img = new Image(Atlases.ElementsTextures.getTexture("push_done"));
							addChild(_img);
						}
					}
					break;
			}
		}
		
		override public function checkPush(game :Game, pos :WorldPosition, dir :WorldOrientation) :void
		{
			if (_state != STATE_READY) { return; }
			
			// hack: because player origin isn't centered
			var tempPos :WorldPosition = new WorldPosition();
			tempPos.copy(pos);
			
			var pushed :Boolean = false;
			
			// guard against diagonal pushing
			if (dir.x != 0)
			{
				dir.y = 0;
			}
			
			if (dir.y < 0)
			{
				tempPos.x += Settings.TileW / 2;
				tempPos.y -= Settings.TileH / 4;
			}
			else if (dir.y > 0)
			{
				tempPos.x += Settings.TileW / 2;
				tempPos.y += Settings.TileH * 5/4;
			}
			else if (dir.x < 0)
			{
				tempPos.x -= Settings.TileW / 4;
				tempPos.y += Settings.TileH / 2;
			}
			else if (dir.x > 0)
			{
				tempPos.x += Settings.TileW * 5/4;
				tempPos.y += Settings.TileH / 2;
			}
			
			//_debugQuad.x = tempPos.x - worldPosition.x;
			//_debugQuad.y = tempPos.y - worldPosition.y;
			
			if (tempPos.boxCollide(worldPosition))
			{
				_wasPushedThisFrame = true;
				_pushDir.copy(dir);
			}
		}
		
	} // class

} // package
