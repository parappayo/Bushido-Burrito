package ui.screens 
{
	import feathers.controls.*;
	import feathers.controls.renderers.*;
	import feathers.data.*;
	import sim.Character;
	import starling.display.Quad;
	import starling.display.Image;
	import starling.text.TextField;
	
	import sim.Enemy;
	import sim.TrashMobsStage;
	
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import ui.widgets.PartyView;

	public class TrashMobsScreen extends ui.screens.Screen
	{
		private var _caption :TextField;
		private var _timeLeft :ProgressBar;
		private var _party :PartyView;
		
		public function TrashMobsScreen(parent :Flow, game :Game)
		{
			super(parent, game);
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_timeLeft = new ProgressBar();
				_timeLeft.maximum = 10;
				_timeLeft.minimum = 0;
				_timeLeft.width = Settings.ScreenWidth;
				_timeLeft.height = 50;
				_game.UISprite.addChild(_timeLeft);

				_caption = new TextField(Settings.ScreenWidth, 50, "Trash Mobs", "theme_font", 16, 0x000000);
				_game.UISprite.addChild(_caption);
				
				_party = new PartyView();
				_party.width = Settings.ScreenWidth;
				_party.height = 250;
				_party.y = Settings.ScreenHeight - _party.height;
				_party.refreshLayout();
				_game.UISprite.addChild(_party);
				
				_game.TrashMobs.Party = _game.Recruit.Party;
				_game.TrashMobs.start(_game);
				populate(_game.TrashMobs);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_caption, true);
				_caption = null;
				
				_game.UISprite.removeChild(_timeLeft, true);
				_timeLeft = null;
				
				_game.UISprite.removeChild(_party, true);
				_party = null;
				
				for each (var enemy :Enemy in _game.TrashMobs.Mobs)
				{
					_game.UISprite.removeChild(enemy.Graphic, true);
					enemy.Graphic = null;
					
					_game.UISprite.removeChild(enemy.DamageText, true);
					enemy.DamageText = null;
				}
			}
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			_timeLeft.value = _game.TrashMobs.timeLeft();
			
			if (_game.TrashMobs.timeLeft() <= 0)
			{
				if (_game.DifficultyTier > 0 && !_game.TrashMobs.succeeded())
				{
					_game.DifficultyTier -= 1;
				}
				
				_game.TrashMobs.end(_game);
				_parent.handleChildDone();
				return;
			}
			
			for each (var chara :Character in _game.TrashMobs.Party)
			{
				_party.updateData(chara);
			}
		}
		
		override public function handleSignal(signal :int) :void
		{
			super.handleSignal(signal);
			
			if (_timeElapsedInState > MinScreenDuration &&
				signal == Signals.ACCEPT_KEYUP &&
				_game.TrashMobs.succeeded() )
			{
				_game.TrashMobs.end(_game);
				_parent.handleChildDone();
			}
		}
		
		protected function populate(stageData :TrashMobsStage) :void
		{
			for each (var chara :Character in stageData.Party)
			{
				_party.addCharacter(chara);
			}
			_party.refreshLayout();
			
			var enemyWidth :int = 64;
			var enemyHeight :int = 64;
			var enemyAreaTop :int = _timeLeft.y + _timeLeft.height;
			var enemyAreaBottom :int = _party.y - enemyHeight;
			var enemyAreaLeft :int = 0;
			var enemyAreaRight :int = Settings.ScreenWidth - enemyWidth;
			var enemyAreaWidth :int = enemyAreaRight - enemyAreaLeft;
			var enemyAreaHeight :int = enemyAreaBottom - enemyAreaTop;
			
			var enemy :Enemy;
			for each (enemy in stageData.Mobs)
			{
				enemy.Graphic = new Image(Assets.Monsters.getTexture(enemy.Name.toLowerCase()));
				//enemy.Graphic = new Quad(enemyWidth, enemyHeight, 0xcc0000);
				enemy.Graphic.width = enemyWidth;
				enemy.Graphic.height = enemyHeight;
				
				enemy.Graphic.x = enemyAreaLeft + Math.random() * enemyAreaWidth;
				enemy.Graphic.y = enemyAreaTop + Math.random() * enemyAreaHeight;
				
				// TODO: should put enemies on another layer here
				_game.UISprite.addChild(enemy.Graphic);
			}
			
			// separate loop so damage text layered over all graphics
			for each (enemy in stageData.Mobs)
			{
				enemy.DamageText = new TextField(enemyWidth * 2, enemyHeight, "", "theme_font", 16, 0xcc0000);
				enemy.DamageText.x = enemy.Graphic.x - enemyWidth / 2;
				enemy.DamageText.y = enemy.Graphic.y - enemyHeight / 2;

				// TODO: should put text on another layer here
				_game.UISprite.addChild(enemy.DamageText);
			}
		}
		
	} // class
	
} // package
