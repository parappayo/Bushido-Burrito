package sim.components.action 
{
	import resources.Audio;
	import sim.actors.SpriteActor;
	import sim.components.animation.Animations;
	public class ActionStateWait implements ActionState 
	{
		private var _duration:Number;
		private var _exitAnim:int;
		private var _timer:Number;
		
		public function ActionStateWait(duration:Number, exitAnim:int = Animations.NONE) 
		{
			_duration = duration;
			_exitAnim = exitAnim;
			_timer = 0;
		}
		
		public function enter(game:Game, actor:SpriteActor):void 
		{
			_timer = _duration;
		}
		
		public function update(game:Game, actor:SpriteActor, elapsed:Number):Boolean 
		{
			_timer -= elapsed;
			if (_timer < 0)
			{
				return true;
			}
			return false;
		}
		
		public function exit(game:Game, actor:SpriteActor):void 
		{
			var purrzillas:Array = [Audio.vo_cat_disapproving_01, Audio.vo_cat_dull_01];
			SoundPlayer.playRandom(purrzillas, Settings.VolumeSfx - 0.1);
			actor.handleSignal(game, Signals.ANIMATION_PLAY, _exitAnim);
		}
	}
}