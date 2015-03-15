package components 
{
	import wyverntail.core.*;

	public class IdleAnimation extends Component
	{
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			var clip :MovieClip = getComponent(MovieClip) as MovieClip;
			
			clip.addAnimation("idle", Assets.EntitiesAtlas.getTextures(prefabArgs.animName), 3);
			clip.play("idle", true);

			// hack for LD29
			clip.addAnimation("turn_done", Assets.EntitiesAtlas.getTextures(prefabArgs.animName + "0"), 3);
		}
		
	} // class

} // package
