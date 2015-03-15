package ui.screens 
{
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.events.*;
	import feathers.controls.Button;
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import sim.*;
	
	public class UpgradesScreen extends Screen
	{
		private var _sprite :Sprite;

		private var _NinjaPool :NinjaPool;
		private var _RicePool :RicePool;
		private var _CastlePool :CastlePool;
		
		private var _autoHarvestDescription :TextField
		private var _autoHarvestCost :TextField
		private var _autoHarvestButton :Button;

		private var _ninjaHarvestDescription :TextField
		private var _ninjaHarvestCost :TextField
		private var _ninjaHarvestButton :Button;

		private var _trainingDescription :TextField
		private var _trainingCost :TextField
		private var _trainingButton :Button;

		private var _clanLeaderDescription :TextField
		private var _clanLeaderCost :TextField
		private var _clanLeaderButton :Button;

		public function UpgradesScreen(parent :Flow, game :Game) 
		{
			super(parent, game);

			_sprite = new Sprite();
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_game.UISprite.addChild(_sprite);

				_NinjaPool = _game.SimEntity.getComponent(NinjaPool) as NinjaPool;
				_RicePool = _game.SimEntity.getComponent(RicePool) as RicePool;
				_CastlePool = _game.SimEntity.getComponent(CastlePool) as CastlePool;

				var backingQuad :Quad = new Quad(Settings.ScreenWidth, Settings.ScreenHeight, 0xcccccc);
				backingQuad.alpha = 0.9;
				_sprite.addChild(backingQuad);

				var layoutX :int = Settings.ScreenWidth * 0.5;
				var layoutY :int = Settings.ScreenHeight * 0.05;

				_autoHarvestDescription = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
				_autoHarvestDescription.x = layoutX - _autoHarvestDescription.width * 0.5;
				_autoHarvestDescription.y = layoutY;
				_sprite.addChild(_autoHarvestDescription);
				layoutY += 40;

				_autoHarvestCost = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
				_autoHarvestCost.x = layoutX - _autoHarvestDescription.width * 0.5;
				_autoHarvestCost.y = layoutY;
				_sprite.addChild(_autoHarvestCost);
				layoutY += 50;

				_autoHarvestButton = new Button();
				_autoHarvestButton.addEventListener(Event.TRIGGERED, buyAutoHarvest);
				_autoHarvestButton.width = 320;
				_autoHarvestButton.x = layoutX - _autoHarvestButton.width * 0.5;
				_autoHarvestButton.y = layoutY;
				_sprite.addChild(_autoHarvestButton);
				layoutY += 50;
				
				_ninjaHarvestDescription = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
				_ninjaHarvestDescription.x = layoutX - _ninjaHarvestDescription.width * 0.5;
				_ninjaHarvestDescription.y = layoutY;
				_sprite.addChild(_ninjaHarvestDescription);
				layoutY += 40;

				_ninjaHarvestCost = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
				_ninjaHarvestCost.x = layoutX - _ninjaHarvestDescription.width * 0.5;
				_ninjaHarvestCost.y = layoutY;
				_sprite.addChild(_ninjaHarvestCost);
				layoutY += 50;

				_ninjaHarvestButton = new Button();
				_ninjaHarvestButton.addEventListener(Event.TRIGGERED, buyNinjaHarvest);
				_ninjaHarvestButton.width = 320;
				_ninjaHarvestButton.x = layoutX - _ninjaHarvestButton.width * 0.5;
				_ninjaHarvestButton.y = layoutY;
				_sprite.addChild(_ninjaHarvestButton);
				layoutY += 50;
				
				_trainingDescription = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
				_trainingDescription.x = layoutX - _trainingDescription.width * 0.5;
				_trainingDescription.y = layoutY;
				_sprite.addChild(_trainingDescription);
				layoutY += 40;

				_trainingCost = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
				_trainingCost.x = layoutX - _trainingDescription.width * 0.5;
				_trainingCost.y = layoutY;
				_sprite.addChild(_trainingCost);
				layoutY += 50;

				_trainingButton = new Button();
				_trainingButton.addEventListener(Event.TRIGGERED, buyTraining);
				_trainingButton.width = 320;
				_trainingButton.x = layoutX - _trainingButton.width * 0.5;
				_trainingButton.y = layoutY;
				_sprite.addChild(_trainingButton);
				layoutY += 50;
				
				_clanLeaderDescription = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
				_clanLeaderDescription.x = layoutX - _clanLeaderDescription.width * 0.5;
				_clanLeaderDescription.y = layoutY;
				_sprite.addChild(_clanLeaderDescription);
				layoutY += 40;

				_clanLeaderCost = new TextField(Settings.ScreenWidth, 50, "", Settings.DefaultFont, Settings.FontSize);
				_clanLeaderCost.x = layoutX - _clanLeaderDescription.width * 0.5;
				_clanLeaderCost.y = layoutY;
				_sprite.addChild(_clanLeaderCost);
				layoutY += 50;

				_clanLeaderButton = new Button();
				_clanLeaderButton.addEventListener(Event.TRIGGERED, buyClanLeader);
				_clanLeaderButton.width = 320;
				_clanLeaderButton.x = layoutX - _clanLeaderButton.width * 0.5;
				_clanLeaderButton.y = layoutY;
				_sprite.addChild(_clanLeaderButton);
				layoutY += 50;
				
				layoutY += 10;
				var exitButton :Button = new Button();
				exitButton.label = "Back";
				exitButton.addEventListener(Event.TRIGGERED, function() :void { _parent.handleChildDone(); } );
				exitButton.width = 100;
				exitButton.x = layoutX - exitButton.width * 0.5;
				exitButton.y = layoutY;
				_sprite.addChild(exitButton);
				layoutY += 50;
				
				refreshButtons();
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_sprite);
			
				_sprite.removeChildren();
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.ACTION_KEYUP ||
				signal == Signals.BACK_KEYUP)
			{
				_parent.handleChildDone();
				return true;
			}
			
			return false;
		}
		
		private function refreshButtons() :void
		{
			refreshAutoHarvestButton();
			refreshNinjaHarvestButton();
			refreshTrainingButton();
			refreshClanLeaderButton();
		}
		
		private function refreshAutoHarvestButton() :void
		{
			var upgradeCost :Number = _RicePool.autoHarvestCost(_RicePool.AutoHarvestUpgradeLevel + 1);
			if (_RicePool.AutoHarvestUpgradeLevel >= RicePool.MaxAutoHarvestUpgradeLevel)
			{
				_autoHarvestButton.label = "MAX";
				_autoHarvestButton.isEnabled = false;
				_autoHarvestDescription.text = "Maxed out";
			}
			else
			{
				_autoHarvestButton.label = "Buy Auto Harvest Level " + (_RicePool.AutoHarvestUpgradeLevel + 1);
				_autoHarvestDescription.text = "Harvest rice automatically every " +
					_RicePool.autoHarvestPeriod(_RicePool.AutoHarvestUpgradeLevel + 1) +
					" seconds";
				_autoHarvestCost.text = "Cost: " +
					Utils.formatNumber(upgradeCost) +
					" rice";
				_autoHarvestButton.isEnabled = _RicePool.BagsOfRice >= upgradeCost;
			}
		}
		
		private function buyAutoHarvest() :void
		{
			var upgradeCost :Number = _RicePool.autoHarvestCost(_RicePool.AutoHarvestUpgradeLevel + 1);
			_RicePool.BagsOfRice -= upgradeCost;
			
			_RicePool.AutoHarvestUpgradeLevel = Math.min(
				_RicePool.AutoHarvestUpgradeLevel + 1,
				RicePool.MaxAutoHarvestUpgradeLevel);
				
			refreshButtons();
		}
		
		private function refreshNinjaHarvestButton() :void
		{
			var upgradeCost :Number = _RicePool.ninjaHarvestCost(_RicePool.NinjaHarvestUpgradeLevel + 1);
			if (_RicePool.NinjaHarvestUpgradeLevel >= RicePool.MaxNinjaHarvestUpgradeLevel)
			{
				_ninjaHarvestButton.label = "MAX";
				_ninjaHarvestButton.isEnabled = false;
				_ninjaHarvestDescription.text = "Maxed out";
			}
			else
			{
				_ninjaHarvestButton.label = "Buy Ninja Harvest Level " + (_RicePool.NinjaHarvestUpgradeLevel + 1);
				_ninjaHarvestDescription.text = "" +
					(_RicePool.ninjaHarvestFactor(_RicePool.NinjaHarvestUpgradeLevel + 1) * 100).toFixed(1) +
					"% of your ninja army helps out at harvest time";
				_ninjaHarvestCost.text = "Cost: " +
					Utils.formatNumber(upgradeCost) +
					" rice";
				_ninjaHarvestButton.isEnabled = _RicePool.BagsOfRice >= upgradeCost;
			}
		}
		
		private function buyNinjaHarvest() :void
		{
			var upgradeCost :Number = _RicePool.ninjaHarvestCost(_RicePool.NinjaHarvestUpgradeLevel + 1);
			_RicePool.BagsOfRice -= upgradeCost;
			
			_RicePool.NinjaHarvestUpgradeLevel = Math.min(
				_RicePool.NinjaHarvestUpgradeLevel + 1,
				RicePool.MaxNinjaHarvestUpgradeLevel);
				
			refreshButtons();
		}
		
		private function refreshTrainingButton() :void
		{
			var upgradeCost :Number = _NinjaPool.trainingCost(_NinjaPool.TrainingUpgradeLevel + 1);
			if (_NinjaPool.TrainingUpgradeLevel >= NinjaPool.MaxTrainingUpgradeLevel)
			{
				_trainingButton.label = "MAX";
				_trainingButton.isEnabled = false;
				_trainingDescription.text = "Maxed out";
			}
			else
			{
				_trainingButton.label = "Buy Training Level " + (_NinjaPool.TrainingUpgradeLevel + 1);
				_trainingDescription.text = "Promote " +
					(_NinjaPool.trainingFactor(_NinjaPool.TrainingUpgradeLevel + 1) * 100).toFixed() +
					"% of ninjas in each training session";
				_trainingCost.text = "Cost: " +
					Utils.formatNumber(upgradeCost) +
					" rice";
				_trainingButton.isEnabled = _RicePool.BagsOfRice >= upgradeCost;
			}
		}
		
		private function buyTraining() :void
		{
			var upgradeCost :Number = _NinjaPool.trainingCost(_NinjaPool.TrainingUpgradeLevel + 1);
			_RicePool.BagsOfRice -= upgradeCost;
			
			_NinjaPool.TrainingUpgradeLevel = Math.min(
				_NinjaPool.TrainingUpgradeLevel + 1,
				NinjaPool.MaxTrainingUpgradeLevel);
				
			refreshButtons();
		}
		
		private function refreshClanLeaderButton() :void
		{
			var upgradeCost :Number = _NinjaPool.clanLeaderCost(_NinjaPool.ClanLeaderUpgradeLevel + 1);
			if (_NinjaPool.ClanLeaderUpgradeLevel >= NinjaPool.MaxClanLeaderUpgradeLevel)
			{
				_clanLeaderButton.label = "MAX";
				_clanLeaderButton.isEnabled = false;
				_clanLeaderDescription.text = "Maxed out";
			}
			else
			{
				_clanLeaderButton.label = "Buy Clan Leader Level " + (_NinjaPool.ClanLeaderUpgradeLevel + 1);
				_clanLeaderDescription.text = "Issues orders to the clan every " +
					_NinjaPool.clanLeaderPeriod(_NinjaPool.ClanLeaderUpgradeLevel + 1) +
					" seconds";
				_clanLeaderCost.text = "Cost: " +
					Utils.formatNumber(upgradeCost) +
					" rice";
				_clanLeaderButton.isEnabled = _RicePool.BagsOfRice >= upgradeCost;
			}
		}
		
		private function buyClanLeader() :void
		{
			var upgradeCost :Number = _NinjaPool.clanLeaderCost(_NinjaPool.ClanLeaderUpgradeLevel + 1);
			_RicePool.BagsOfRice -= upgradeCost;
			
			_NinjaPool.ClanLeaderUpgradeLevel = Math.min(
				_NinjaPool.ClanLeaderUpgradeLevel + 1,
				NinjaPool.MaxClanLeaderUpgradeLevel);
				
			refreshButtons();
		}
		
	} // class

} // package

