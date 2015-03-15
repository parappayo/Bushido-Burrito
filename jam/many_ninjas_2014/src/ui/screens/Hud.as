package ui.screens 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.events.*;
	import feathers.controls.*;
	import ui.widgets.MessageQueueWidget;

	import wyverntail.core.Entity;
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import sim.*;
	
	public class Hud extends ui.screens.Screen 
	{
		private var _sprite :Sprite;
		
		private var _ninjasText :TextField;
		private var _riceText :TextField;
				
		private var _NinjaPool :NinjaPool;
		private var _RicePool :RicePool;  // TODO: separate UI for this
		
		private var _messageQueue :MessageQueueWidget;
		private var _progressPanel :Sprite;
		private var _progressBar :ProgressBar;
		private var _progressCaption :TextField;
		
		private var _controlPanel :Sprite;
		private var _harvestRiceButton :Button;
		private var _cookRiceButton :Button;
		private var _trainNinjasButton :Button;
		private var _raidCastleButton :Button;
		
		public function Hud(parent:Flow, game:Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();			
		}
		
		public function show() :void
		{
			_game.UISprite.addChild(_sprite);
			
			_NinjaPool = _game.SimEntity.getComponent(NinjaPool) as NinjaPool;
			_RicePool = _game.SimEntity.getComponent(RicePool) as RicePool;
			
			_messageQueue = new MessageQueueWidget();
			_sprite.addChild(_messageQueue);
			
			_progressPanel = new Sprite()
			_progressPanel.visible = false;
			_sprite.addChild(_progressPanel);
			
			_progressBar = new ProgressBar();
			_progressBar.width = Settings.ScreenWidth;
			_progressBar.height = 50;
			_progressBar.alpha = 0.8;
			_progressPanel.addChild(_progressBar);
			
			_progressCaption = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
			_progressPanel.addChild(_progressCaption);
			
			_controlPanel = new Sprite();
			_sprite.addChild(_controlPanel);
			
			var backingQuad :Quad = new Quad(208, 100, 0xcccccc);
			backingQuad.x = 8;
			backingQuad.y = 10;
			_controlPanel.addChild(backingQuad);
			
			var layoutX :int = 12;
			var layoutY :int = 10;

			_ninjasText = new TextField(200, 50, "", Settings.DefaultFont, Settings.FontSize);
			_ninjasText.text = "Ninjas";
			_ninjasText.x = layoutX;
			_ninjasText.y = layoutY;
			_controlPanel.addChild(_ninjasText);
			layoutY += 50;
			
			_riceText = new TextField(200, 50, "", Settings.DefaultFont, Settings.FontSize);
			_riceText.text = "Rice";
			_riceText.x = layoutX;
			_riceText.y = layoutY;
			_controlPanel.addChild(_riceText);
			layoutY += 50;
			
			_harvestRiceButton = new Button();
			_harvestRiceButton.label = "Harvest Rice";
			_harvestRiceButton.x = layoutX;
			_harvestRiceButton.y = layoutY;
			_harvestRiceButton.addEventListener(Event.TRIGGERED, _RicePool.harvestRice);
			_controlPanel.addChild(_harvestRiceButton);
			layoutY += 50;
			
			_cookRiceButton = new Button();
			_cookRiceButton.label = "Cook Rice";
			_cookRiceButton.x = layoutX;
			_cookRiceButton.y = layoutY;
			_cookRiceButton.addEventListener(Event.TRIGGERED, _RicePool.cookAllRice);
			_controlPanel.addChild(_cookRiceButton);
			layoutY += 50;
			
			_trainNinjasButton = new Button();
			_trainNinjasButton.label = "Train Ninjas";
			_trainNinjasButton.x = layoutX;
			_trainNinjasButton.y = layoutY;
			_trainNinjasButton.addEventListener(Event.TRIGGERED, _NinjaPool.trainNinjas);
			_controlPanel.addChild(_trainNinjasButton);
			layoutY += 50;

			_raidCastleButton = new Button();
			_raidCastleButton.label = "Raid Castle";
			_raidCastleButton.x = layoutX;
			_raidCastleButton.y = layoutY;
			_raidCastleButton.addEventListener(Event.TRIGGERED, function() :void { _game.handleSignal(Signals.SHOW_RAID_CASTLE, this, {}); } );
			_controlPanel.addChild(_raidCastleButton);
			layoutY += 50;

			var button :Button = new Button();
			button.label = "Show Ninja Army";
			button.width = 200;
			button.x = layoutX;
			button.y = layoutY;
			button.addEventListener(Event.TRIGGERED, function() :void { _game.handleSignal(Signals.SHOW_NINJA_TOTALS, this, {}); } );
			_controlPanel.addChild(button);
			layoutY += 50;
			
			var upgradesButton :Button = new Button();
			upgradesButton.label = "Buy Upgrades";
			upgradesButton.x = layoutX;
			upgradesButton.y = layoutY;
			upgradesButton.addEventListener(Event.TRIGGERED, function() :void { _game.handleSignal(Signals.SHOW_UPGRADES, this, {}); } );
			_controlPanel.addChild(upgradesButton);
			layoutY += 50;
			
			backingQuad.height = layoutY;
			backingQuad.alpha = 0.8;
		}

		public function hide() :void
		{
			_game.UISprite.removeChild(_sprite);			
			_sprite.removeChildren();
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			_messageQueue.update(elapsed);
			
			if (_NinjaPool.TrainingInProgress)
			{
				_controlPanel.visible = false;
				_progressPanel.visible = true;
				
				_progressBar.maximum = 1.0;
				_progressBar.value = _NinjaPool.TrainingProgress;
				_progressCaption.text = "Training in Progress";
			}
			else if (_NinjaPool.RaidInProgress)
			{
				_controlPanel.visible = false;
				_progressPanel.visible = true;
				
				_progressBar.maximum = 1.0;
				_progressBar.value = _NinjaPool.RaidProgress;
				_progressCaption.text = "Raid in Progress";
			}
			else if (_RicePool.CookingInProgress)
			{
				_controlPanel.visible = false;
				_progressPanel.visible = true;
				
				_progressBar.maximum = 1.0;
				_progressBar.value = _RicePool.CookingProgress;
				_progressCaption.text = "Cooking in Progress";
			}
			else
			{
				_controlPanel.visible = true;
				_progressPanel.visible = false;
				
				_ninjasText.text = "Ninjas: " + Utils.formatNumber(_NinjaPool.TotalNinjas);
				_riceText.text = "Rice: " + Utils.formatNumber(_RicePool.BagsOfRice);
			
				_cookRiceButton.isEnabled = _RicePool.BagsOfRice > 0;
				_trainNinjasButton.isEnabled = _NinjaPool.TotalNinjas > 0 && _NinjaPool.TrainingFactor > 0;
				_raidCastleButton.isEnabled = _NinjaPool.TotalNinjas > 0;
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.SHOW_HUD_MESSAGE)
			{
				_messageQueue.addMessage(args.caption);
				return true;
			}
			
			return false;
		}
		
	} // class
	
} // package
