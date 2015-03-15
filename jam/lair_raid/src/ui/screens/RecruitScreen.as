package ui.screens 
{
	import feathers.controls.*;
	import feathers.controls.renderers.*;
	import feathers.data.*;
	import starling.text.TextField;
	import ui.widgets.RecruitListItemRenderer;
	
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	
	import sim.Character;
	import sim.CharacterPool;
	import sim.RecruitStage;

	public class RecruitScreen extends ui.screens.Screen
	{
		private var _caption :TextField;
		private var _timeLeft :ProgressBar;
		private var _list :List;
		
		public function RecruitScreen(parent :Flow, game :Game)
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
				
				_caption = new TextField(Settings.ScreenWidth, 50, "Recruit Party", "theme_font", 16, 0x000000);
				_game.UISprite.addChild(_caption);
				
				_list = new List();
				_list.allowMultipleSelection = true;
				_list.y = _timeLeft.height;
				_list.width = Settings.ScreenWidth;
				_list.height = Settings.ScreenHeight;
				_list.itemRendererFactory = function() :IListItemRenderer
				{
					//return new DefaultListItemRenderer();
					return new RecruitListItemRenderer();
				}
				_game.UISprite.addChild(_list);
				
				populate(_game.CharaPool);
				
				// re-select the charas from the previous round
				// this is a huge hack, but it works :(
				var i :int = 0;
				var itemsToSelect :Vector.<int> = new Vector.<int>();
				for each (var chara :Character in _game.CharaPool.Characters)
				{
					if (chara.WasUsedLastRound)
					{
						itemsToSelect.push(i);
					}
					i++;
				}
				_list.selectedIndices = itemsToSelect;
				
				_game.Recruit.start(_game);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				var party :Vector.<Character> = new Vector.<Character>();
				for each (var character :Character in _list.selectedItems)
				{
					if (party.length < RecruitStage.MaxPartySize)
					{
						party.push(character);
					}
				}
				
				for each (var chara :Character in _game.CharaPool.Characters)
				{
					chara.WasUsedLastRound = false;
				}
				
				_game.Recruit.Party = party;
				_game.Recruit.end(_game);
				
				_game.UISprite.removeChild(_list, true);
				_list = null;
				
				_game.UISprite.removeChild(_caption, true);
				_caption = null;
				
				_game.UISprite.removeChild(_timeLeft, true);
				_timeLeft = null;
			}
		}
		
		override public function update(elapsed :Number) :void
		{
			super.update(elapsed);
			
			_timeLeft.value = _game.Recruit.timeLeft();
			
			if (_game.Recruit.timeLeft() <= 0)
			{
				_parent.handleChildDone();
			}
		}
		
		override public function handleSignal(signal :int) :void
		{
			super.handleSignal(signal);
		}
		
		private function populate(characterPool :CharacterPool) :void
		{
			var listCollection :ListCollection = new ListCollection;
			
			for each (var character :Character in characterPool.Characters)
			{
				listCollection.addItem(character);
			}
			
			_list.dataProvider = listCollection;
		}
		
	} // class
	
} // package
