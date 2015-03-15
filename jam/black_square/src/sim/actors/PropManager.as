package sim.actors 
{
	import sim.*;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	public class PropManager
	{
		private var sprite :Sprite;
		private var actorManager :ActorManager;
		private var cameraPositionables :Vector.<CameraPositionable>;
		
		public function PropManager(sprite :Sprite)
		{
			this.sprite = sprite;
			
			actorManager = new ActorManager();
			cameraPositionables = new Vector.<CameraPositionable>();
		}
		
		public function clear() :void
		{
			actorManager.clear();
			cameraPositionables.length = 0;
		}
		
		public function spawn(type :int) :Prop
		{
			var prop :Prop;
			
			switch (type) 
			{
				case Prop.TYPE_BARREL:
					{
						prop = new Barrel();
					}
					break;

				case Prop.TYPE_CRATE:
					{
						prop = new Crate();
					}
					break;
				
				case Prop.TYPE_PUSH_BLOCK:
					{
						prop = new PushBlock();
					}
					break;
				
				case Prop.TYPE_SECRET_PUSH_BLOCK:
					{
						prop = new SecretPushBlock();
					}
					break;
				
				case Prop.TYPE_PROXIMITY_MINE:
					{
						prop = new ProximityMine();
					}
					break;
				
				case Prop.TYPE_STAIRS:
					{
						prop = new Stairs();
					}
					break;

				case Prop.TYPE_SECRET_STAIRS:
					{
						prop = new SecretStairs();
					}
					break;

				case Prop.TYPE_RADIO:
					{
						prop = new Radio();
					}
					break;

				case Prop.TYPE_WEAPON_SMG_PICKUP:
					{
						prop = new WeaponSMGPickup();
					}
					break;
					
				case Prop.TYPE_BLACK_SQUARE:
					{
						prop = new BlackSquare();
					}
					break;

				case Prop.TYPE_TANK:
					{
						prop = new TankProp();
					}
					break;

				case Prop.TYPE_SWITCH:
					{
						prop = new Barrel();
					}
					break;
					
				case Prop.TYPE_TRUCK:
					{
						prop = new Truck();
					}
					break;
					
				case Prop.TYPE_BOOKCASE:
					{
						prop = new Bookcase();
					}
					break;
					
				case Prop.TYPE_PAINTINGS:
					{
						prop = new Paintings();
					}
					break;
					
				case Prop.TYPE_STATUE:
					{
						prop = new Statue();
					}
					break;
					
				case Prop.TYPE_FIRST_AID:
					{
						prop = new HealthPickup();
					}
					break;

				default:
					{
						prop = new Crate();
					}
					break;
			}
			
			actorManager.add(prop);
			cameraPositionables.push(prop);
			sprite.addChild(prop);
			return prop;
		}
		
		public function update(game :Game, elapsed :Number) :void
		{
			actorManager.update(game, elapsed);
		}
		
		public function applyCamera(camera :Camera) :void
		{			
			for each (var c :CameraPositionable in cameraPositionables)
			{
				camera.apply(c);
			}			
		}
		
		public function handleSignal(game :Game, signal :int, args :Object) :void
		{
			actorManager.handleSignal(game, signal, args);
		}

		public function checkCollision(game :Game, pos :WorldPosition, ignore :SpriteActor) :Boolean
		{
			return actorManager.checkCollision(game, pos, ignore);
		}
		
		public function checkExplosion(game :Game, pos :WorldPosition, radius :Number) :void
		{
			actorManager.checkExplosion(game, pos, radius);
		}
		
		public function checkPush(game :Game, pos :WorldPosition, dir :WorldOrientation) :void
		{
			actorManager.checkPush(game, pos, dir);
		}
		
	} // class

} // package
