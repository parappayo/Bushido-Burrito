package ui.screens 
{
	import entities.Player;
	import sim.Corporation;
	import sim.PlayerInventory;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.*;

	import wyverntail.core.Flow;
	import ui.flows.FlowStates;
	import sim.StockMarket;
	
	public class StockMarketScreen extends Screen
	{
		private var _rows :Vector.<StockEntry>;
		private var _highlightedRow :uint;
		
		private var _sprite :Sprite;
		private var _caption :TextField;
		private var _tfBalance :TextField;
		private var _highlight :Quad;
		
		private var _stockMarket :StockMarket;
		private var _playerInventory :PlayerInventory;
		
		public function StockMarketScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			_rows = new Vector.<StockEntry>();
			_highlightedRow = 0;
			_sprite = new Sprite();
			
			var box :Image = new Image(Assets.DialogueScreenTexture);
			_sprite.addChild(box);
			
			var width :Number = 300;
			var height :Number = 30;
			
			_caption = new TextField(width, height, "", Settings.DefaultFont, Settings.FontSize, 0xff55ff);
			_caption.x = (Settings.ScreenWidth - width) * 0.5;
			_caption.y = 10;
			_caption.hAlign = HAlign.CENTER;
			_caption.vAlign = VAlign.CENTER;
			_sprite.addChild(_caption);
			
			_tfBalance = new TextField(width, height, "", Settings.DefaultFont, Settings.FontSize, 0x55ffff);
			_tfBalance.x = (Settings.ScreenWidth - width) * 0.5;
			_tfBalance.y = 40;
			_tfBalance.hAlign = HAlign.CENTER;
			_tfBalance.vAlign = VAlign.CENTER;
			_sprite.addChild(_tfBalance);
			
			_highlight = new Quad(_caption.width, _caption.height, 0xffffff);
			_sprite.addChild(_highlight);
		}
		
		public function setCaption(caption :String) :void
		{
			_caption.text = caption;
		}
		
		private function populate(stockMarket :StockMarket) :void
		{
			_caption.text = stockMarket.caption;
			
			for each (var r :StockEntry in _rows)
			{
				r.removeFrom(_sprite);
			}
			
			_rows.length = 0;
			for each (var c :Corporation in stockMarket.listedCorporations)
			{
				addRow(c);
			}			
			if (_rows.length < 1)
			{
				_parent.handleChildDone();
			}
			else
			{
				highlightRow(0);
			}
		}
		
		private function refreshBalance() :void
		{
			_tfBalance.text = "Your Balance: $" + _playerInventory.cash.toFixed(2);
		}
		
		private function addRow(corporation :Corporation) :void
		{
			var stockEntry :StockEntry = new StockEntry();
			stockEntry.corporation = corporation;
			
			const startingY :Number = 80;
			const width :Number = 400;
			const height :Number = 30;
			const priceWidth :Number = 60;
			const ownedWidth :Number = 60;
			const spacing :Number = 4;
			
			_highlight.width = width;
			
			stockEntry.tfCaption = new TextField(width - priceWidth - ownedWidth - spacing*2, height, "", Settings.DefaultFont, Settings.FontSize, 0xffffff);
			stockEntry.tfCaption.x = (Settings.ScreenWidth - width) * 0.5;
			stockEntry.tfCaption.y = startingY + _rows.length * height;
			stockEntry.tfCaption.hAlign = HAlign.CENTER;
			stockEntry.tfCaption.vAlign = VAlign.CENTER;
			stockEntry.tfCaption.text = corporation.caption;
			_sprite.addChild(stockEntry.tfCaption);
			
			stockEntry.tfPrice = new TextField(priceWidth, height, "", Settings.DefaultFont, Settings.FontSize, 0xffffff);
			stockEntry.tfPrice.x = stockEntry.tfCaption.x + stockEntry.tfCaption.width + spacing;
			stockEntry.tfPrice.y = stockEntry.tfCaption.y;
			stockEntry.tfPrice.hAlign = HAlign.CENTER;
			stockEntry.tfPrice.vAlign = VAlign.CENTER;
			_sprite.addChild(stockEntry.tfPrice);
			
			stockEntry.tfOwned = new TextField(ownedWidth, height, "", Settings.DefaultFont, Settings.FontSize, 0xffffff);
			stockEntry.tfOwned.x = stockEntry.tfPrice.x + stockEntry.tfPrice.width + spacing;
			stockEntry.tfOwned.y = stockEntry.tfCaption.y;
			stockEntry.tfOwned.hAlign = HAlign.CENTER;
			stockEntry.tfOwned.vAlign = VAlign.CENTER;
			_sprite.addChild(stockEntry.tfOwned);

			stockEntry.refresh(_stockMarket);
			_rows.push(stockEntry);
		}
		
		private function get highlightedRow() :StockEntry
		{
			return _rows[_highlightedRow];
		}
		
		private function highlightRow(index :int) :void
		{
			if (index > _rows.length - 1) { index = 0; }
			if (index < 0) { index = _rows.length - 1; }
			
			highlightedRow.unhighlight();
			_highlightedRow = index;			
			highlightedRow.highlight(_highlight);
		}

		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_game.UISprite.addChild(_sprite);
				_stockMarket = _game.gameSim.getComponent(StockMarket) as StockMarket;
				_playerInventory = _game.gameSim.getComponent(PlayerInventory) as PlayerInventory;
				populate(_stockMarket);
				refreshBalance();
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_sprite);
			}
		}

		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.BACK_KEYUP)
			{
				_parent.handleChildDone();
				return true;
			}
			else if (signal == Signals.MOVE_DOWN_KEYDOWN)
			{
				highlightRow(_highlightedRow + 1);
			}
			else if (signal == Signals.MOVE_UP_KEYDOWN)
			{
				highlightRow(_highlightedRow - 1);
			}
			else if (signal == Signals.ACTION_KEYDOWN || signal == Signals.MOVE_RIGHT_KEYDOWN)
			{
				_stockMarket.buyShares(highlightedRow.corporation, 1);
				highlightedRow.refresh(_stockMarket);
				refreshBalance();
			}
			else if (signal == Signals.MOVE_LEFT_KEYDOWN)
			{
				_stockMarket.sellShares(highlightedRow.corporation, 1);
				highlightedRow.refresh(_stockMarket);
				refreshBalance();
			}
			
			return false;
		}
		
		override public function handleChildDone() :void
		{
			if (_state == FlowStates.MESSAGE_DIALOG)
			{
				changeState(FlowStates.ACTIVE);
			}
		}

	} // class

} // package

import sim.Corporation;
import sim.StockMarket;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.text.TextField;

class StockEntry
{
	public var tfCaption :TextField;
	public var tfPrice :TextField;
	public var tfOwned :TextField;
	public var corporation :Corporation;
	
	public function removeFrom(sprite :Sprite) :void
	{
		sprite.removeChild(tfCaption);
		sprite.removeChild(tfPrice);
		sprite.removeChild(tfOwned);
	}
	
	public function highlight(highlightSprite :DisplayObject) :void
	{
		highlightSprite.x = tfCaption.x;
		highlightSprite.y = tfCaption.y;
		tfCaption.color = 0x000000;
		tfPrice.color = 0x000000;
		tfOwned.color = 0x000000;
	}
	
	public function unhighlight() :void
	{
		tfCaption.color = 0xffffff;
		tfPrice.color = 0xffffff;		
		tfOwned.color = 0xffffff;		
	}
	
	public function refresh(stockMarket :StockMarket) :void
	{
		tfPrice.text = corporation.stockPrice(stockMarket).toFixed(2);
		tfOwned.text = stockMarket.sharesOwned(corporation).toString();
	}
}
