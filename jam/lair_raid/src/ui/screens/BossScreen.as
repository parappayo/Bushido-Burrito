package ui.screens 
{
	import feathers.controls.*;
	import feathers.controls.renderers.*;
	import feathers.data.*;
	import starling.text.TextField;
	import starling.display.Quad;
	import starling.display.Image;

	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import ui.widgets.PartyView;
	import sim.*;

	public class BossScreen extends ui.screens.Screen
	{
		private var _caption :TextField;
		private var _timeLeft :ProgressBar;
		private var _bossHealth :ProgressBar;
		private var _bossHealthCaption :TextField;
		private var _party :PartyView;
		
		public function BossScreen(parent :Flow, game :Game) 
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

				_caption = new TextField(Settings.ScreenWidth, 50, "Boss Fight", "theme_font", 16, 0x000000);
				_game.UISprite.addChild(_caption);
				
				_party = new PartyView();
				_party.width = Settings.ScreenWidth;
				_party.height = 250;
				_party.y = Settings.ScreenHeight - _party.height;
				_party.refreshLayout();
				_game.UISprite.addChild(_party);
				
				_bossHealth = new ProgressBar();
				_bossHealth.width = Settings.ScreenWidth;
				_bossHealth.height = 30;
				_bossHealth.y = _party.y - _bossHealth.height;
				_game.UISprite.addChild(_bossHealth);
				
				_bossHealthCaption = new TextField(Settings.ScreenWidth, 30, "Boss Health", "theme_font", 16, 0x000000);
				_bossHealthCaption.y = _bossHealth.y;
				_game.UISprite.addChild(_bossHealthCaption);
				
				_game.Boss.Party = _game.Recruit.Party;
				_game.Boss.start(_game);
				populate(_game.Boss);
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
				
				_game.UISprite.removeChild(_bossHealth, true);
				_bossHealth = null;
				
				_game.UISprite.removeChild(_bossHealthCaption, true);
				_bossHealthCaption = null;

				for each (var enemy :Enemy in _game.Boss.Mobs)
				{
					_game.UISprite.removeChild(enemy.Graphic, true);
					enemy.Graphic = null;
					
					_game.UISprite.removeChild(enemy.DamageText, true);
					enemy.DamageText = null;
				}
				
				// boss is added to mobs list, so this isn't needed
				//_game.UISprite.removeChild(_game.Boss.TheBoss.Graphic, true);
				//_game.Boss.TheBoss.Graphic = null;
			}
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			_timeLeft.value = _game.Boss.timeLeft();
			
			if (_game.Boss.timeLeft() <= 0)
			{
				if (_game.DifficultyTier > 0 && !_game.Boss.succeeded())
				{
					_game.DifficultyTier -= 1;
				}
				
				_game.Boss.end(_game);
				_parent.handleChildDone();
				return;
			}
			
			for each (var enemy :Enemy in _game.Boss.Mobs)
			{
				if (enemy.isDead() && enemy.Graphic != null)
				{
					enemy.Graphic.visible = false;
				}
			}
			
			if (_game.Boss.TheBoss.isDead())
			{
				_game.Boss.TheBoss.Graphic.visible = false;
			}
			
			for each (var chara :Character in _game.Boss.Party)
			{
				_party.updateData(chara);
			}
			
			_bossHealth.minimum = 0;
			_bossHealth.maximum = _game.Boss.TheBoss.MaxHP;
			_bossHealth.value = _game.Boss.TheBoss.HP;
		}
		
		override public function handleSignal(signal :int) :void
		{
			// super.handleSignal(signal);
			
			if (_timeElapsedInState > MinScreenDuration &&
				signal == Signals.ACCEPT_KEYUP &&
				_game.Boss.succeeded() )
			{
				_game.Boss.end(_game);
				_parent.handleChildDone();
			}
		}
		
		protected function populate(stageData :BossStage) :void
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
			
			for each (var enemy :Enemy in stageData.Mobs)
			{
				if (enemy == _game.Boss.TheBoss) { continue; }
				
				enemy.Graphic = new Image(Assets.Monsters.getTexture(enemy.Name.toLowerCase()));				
				//enemy.Graphic = new Quad(enemyWidth, enemyHeight, 0xff0000);
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
				if (enemy.Graphic == null) { continue; }
				
				enemy.DamageText = new TextField(enemyWidth * 2, enemyHeight, "", "theme_font", 16, 0xcc0000);
				enemy.DamageText.x = enemy.Graphic.x - enemyWidth / 2;
				enemy.DamageText.y = enemy.Graphic.y - enemyHeight / 2;

				// TODO: should put text on another layer here
				_game.UISprite.addChild(enemy.DamageText);
			}
			
			var bossWidth :int = 5 * enemyWidth;
			var bossHeight :int = 5 * enemyHeight;
			
			var theBoss :Enemy = _game.Boss.TheBoss;
			theBoss.Graphic = new Image(Assets.Monsters.getTexture(theBoss.Name.toLowerCase()));
			//theBoss.Graphic = new Quad(bossWidth, bossHeight, 0x448844);
			theBoss.Graphic.width = bossWidth;
			theBoss.Graphic.height = bossHeight;
			theBoss.Graphic.x = enemyAreaLeft + (enemyAreaWidth - bossWidth) / 2;
			theBoss.Graphic.y = enemyAreaTop + (enemyAreaHeight - bossHeight) / 2;
			_game.UISprite.addChild(theBoss.Graphic);
			
			theBoss.DamageText = new TextField(bossWidth, bossHeight, "", "theme_font", 32, 0xcc0000);
			theBoss.DamageText.x = theBoss.Graphic.x;
			theBoss.DamageText.y = theBoss.Graphic.y - bossHeight / 2;
			_game.UISprite.addChild(theBoss.DamageText);
			
			_bossHealthCaption.text = theBoss.Name + " Health";
		}
		
	} // class
	
} // package
