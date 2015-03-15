package sim.actors 
{
	import sim.*;
	import sim.actors.props.*;
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
		
		public function spawn(type :int, name :String = "") :Prop
		{
			var prop :Prop;
			
			switch (type) 
			{				
				case Prop.TYPE_GENERIC:
					{
						prop = new Generic(name);
					}
					break;

				case Prop.TYPE_CAT:
					{
						prop = new Cat();
					}
					break;
					
				default:
					{
						new Assert("Unknown prop!");
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
		
		public function checkClosest(game :Game, pos :WorldPosition, radius :Number) :Prop
		{
			return actorManager.checkClosest(game, pos, radius) as Prop;
		}
		
	} // class

} // package
