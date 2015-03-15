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
	
	public class SushiScreen extends Screen
	{
		private var _dialog :MessageDialog;
		
		private var _rows :Vector.<SushiEntry>;
		private var _highlightedRow :uint;
		
		private var _sprite :Sprite;
		private var _caption :TextField;
		private var _tfBalance :TextField;
		private var _highlight :Quad;
		
		private var _playerInventory :PlayerInventory;

		public function SushiScreen(parent :Flow, game :Game) 
		{
			super(parent, game);
			
			_dialog = new MessageDialog(this, game);
			
			_rows = new Vector.<SushiEntry>();
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
		
		private function populate() :void
		{
			_caption.text = "Sushi Menu";
			
			_rows.length = 0;
			addRow("Tobiko", 8.50);
			addRow("Ikura", 7.50);
			addRow("Toro nigiri", 7.50);
			addRow("Unagi", 6.50);
			addRow("Tamago", 5.00);
			addRow("California Roll", 4.00);
			
			highlightRow(0);
		}
		
		private function refreshBalance() :void
		{
			_tfBalance.text = "Your Balance: $" + _playerInventory.cash.toFixed(2);
		}
		
		private function addRow(caption :String, price :Number) :void
		{
			var sushi :SushiEntry = new SushiEntry();
			sushi.price = price;
			
			const startingY :Number = 80;
			const width :Number = 400;
			const height :Number = 30;
			const priceWidth :Number = 60;
			const ownedWidth :Number = 60;
			const spacing :Number = 4;
			
			_highlight.width = width;
			
			sushi.tfCaption = new TextField(width - priceWidth - ownedWidth - spacing*2, height, caption, Settings.DefaultFont, Settings.FontSize, 0xffffff);
			sushi.tfCaption.x = (Settings.ScreenWidth - width) * 0.5;
			sushi.tfCaption.y = startingY + _rows.length * height;
			sushi.tfCaption.hAlign = HAlign.CENTER;
			sushi.tfCaption.vAlign = VAlign.CENTER;
			_sprite.addChild(sushi.tfCaption);
			
			sushi.tfPrice = new TextField(priceWidth, height, price.toFixed(2), Settings.DefaultFont, Settings.FontSize, 0xffffff);
			sushi.tfPrice.x = sushi.tfCaption.x + sushi.tfCaption.width + spacing;
			sushi.tfPrice.y = sushi.tfCaption.y;
			sushi.tfPrice.hAlign = HAlign.CENTER;
			sushi.tfPrice.vAlign = VAlign.CENTER;
			_sprite.addChild(sushi.tfPrice);

			_rows.push(sushi);
		}
		
		private function get highlightedRow() :SushiEntry
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
			if (newState == FlowStates.INTRO)
			{				
				_dialog.setCaption("Irasshaimase!!");
				changeState(FlowStates.MESSAGE_DIALOG);				
			}
			else if (newState == FlowStates.ACTIVE)
			{
				_game.UISprite.addChild(_sprite);
				_playerInventory = _game.gameSim.getComponent(PlayerInventory) as PlayerInventory;
				populate();
				refreshBalance();
			}
			else if (newState == FlowStates.MESSAGE_DIALOG)
			{
				_child = _dialog;
				_child.changeState(FlowStates.ACTIVE);
			}
		}
		
		override protected function handleExitState(oldState :int, newState :int) :void
		{
			if (oldState == FlowStates.ACTIVE)
			{
				_game.UISprite.removeChild(_sprite);
			}
		}
		
		override public function handleChildDone() :void
		{
			if (_state == FlowStates.MESSAGE_DIALOG)
			{
				changeState(FlowStates.ACTIVE);
			}
		}

		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (_state == FlowStates.MESSAGE_DIALOG)
			{
				return _dialog.handleSignal(signal, sender, args);
			}
			
			if (_state != FlowStates.ACTIVE) { return false; }
			
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
			else if (signal == Signals.ACTION_KEYDOWN)
			{
				// TODO: dialog thanking the player
				// TODO: restore player's health
				
				_playerInventory.addCash( -highlightedRow.price);
				refreshBalance();
			}
			
			return false;
		}

	} // class

} // package

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.text.TextField;

class SushiEntry
{
	public var tfCaption :TextField;
	public var tfPrice :TextField;
	public var price :Number;
	
	public function removeFrom(sprite :Sprite) :void
	{
		sprite.removeChild(tfCaption);
		sprite.removeChild(tfPrice);
	}
	
	public function highlight(highlightSprite :DisplayObject) :void
	{
		highlightSprite.x = tfCaption.x;
		highlightSprite.y = tfCaption.y;
		tfCaption.color = 0x000000;
		tfPrice.color = 0x000000;
	}
	
	public function unhighlight() :void
	{
		tfCaption.color = 0xffffff;
		tfPrice.color = 0xffffff;
	}
}
