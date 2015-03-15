package components 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.*;
	import wyverntail.core.*;

	public class Selectable extends Component
	{
		private var _game :Game;
		private var _parent :starling.display.Sprite;
		private var _selected :Boolean;
		private var _pulseDelta :Number;
		private var _highlight :Quad;
		private var _pos :Position2D;
		private var _playerControl :Boolean;
		
		public function get selected() :Boolean { return _selected; }
		public function get stage() :Stage { return _parent.stage; }
		
		override public function start(prefabArgs :Object, spawnArgs :Object) :void
		{
			_game = prefabArgs.game;
			_parent = prefabArgs.parentSprite;
			_selected = false;
			_pulseDelta = -0.05;
			_playerControl = spawnArgs.playerControl;
		
			_highlight = new Quad(prefabArgs.width, prefabArgs.height, 0xffffff);
			_highlight.visible = false;
			_highlight.pivotX = _highlight.width * 0.5;
			_highlight.pivotY = _highlight.height * 0.5;
			_parent.addChild(_highlight);
			
			_pos = getComponent(Position2D) as Position2D;
		}
		
		override public function update(elapsed :Number) :void
		{
			_highlight.x = _pos.worldX;
			_highlight.y = _pos.worldY;
			
			if (_selected)
			{
				_highlight.alpha += _pulseDelta * elapsed;
				
				if (_highlight.alpha < 0.05) { _pulseDelta = 0.4; }
				else if (_highlight.alpha > 0.4) { _pulseDelta = -0.4; }
			}
		}
		
		override public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			if (signal == Signals.UNIT_DEFEATED)
			{
				var senderComponent :Component = sender as Component;
				if (senderComponent != null && senderComponent.isSibling(this))
				{
					unselect();
					enabled = false;
					return false;
				}
			}
			
			if (signal == Signals.PLAYER_TURN_START ||
				signal == Signals.AI_TURN_START)
			{
				unselect();
			}
			
			if (!_playerControl || signal != Signals.TOUCH_BEGAN) { return false; }
			
			var event :TouchEvent = args as TouchEvent;
			if (event == null) { return false; }
			var touch :Touch = event.getTouch(_parent.stage, TouchPhase.BEGAN);
			if (touch == null) { return false; }
			
			var wasSelected :Boolean = false;
			if (_selected)
			{
				wasSelected = true;
				_selected = false;
				_highlight.visible = false;
			}

			if (!collides(touch.globalX, touch.globalY))
			{
				if (wasSelected)
				{
					_game.handleSignal(
						Signals.SELECTED_STATE_CHANGED,
						this,
						{ touchEvent : event } );
				}
				return false;
			}
			
			_selected = !wasSelected;
			_game.handleSignal(
				Signals.SELECTED_STATE_CHANGED,
				this,
				{ touchEvent : event } );
			
			_highlight.visible = _selected;
			_highlight.alpha = 0.4;
			_pulseDelta = -0.4;
			
			return false;
		}
		
		// does NOT cause a SELECTED_STATE_CHANGED event
		public function unselect() :void
		{
			_selected = false;
			_highlight.visible = false;
			_highlight.alpha = 0.4;
			_pulseDelta = -0.4;
		}
		
		public function collides(worldX :Number, worldY :Number) :Boolean
		{
			return worldX >= _highlight.x && worldX < _highlight.x + _highlight.width &&
				worldY >= _highlight.y && worldY < _highlight.y + _highlight.height;
		}
		
	} // class

} // package
