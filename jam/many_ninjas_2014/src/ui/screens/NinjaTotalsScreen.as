package ui.screens 
{
	import feathers.controls.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.events.*;
	import sim.NinjaPool;
	import wyverntail.core.Flow;
	import ui.flows.FlowStates;

	public class NinjaTotalsScreen extends Screen
	{
		private var _sprite :Sprite;
		
		private var _rankIcon :Vector.<Image>;
		private var _rankCountText :Vector.<TextField>;

		private var _NinjaPool :NinjaPool;

		public function NinjaTotalsScreen(parent :Flow, game :Game) 
		{
			super(parent, game);

			_sprite = new Sprite();
			_rankCountText = new Vector.<TextField>();
		}
		
		override protected function handleEnterState(oldState :int, newState :int) :void
		{
			if (newState == FlowStates.ACTIVE)
			{
				_game.UISprite.addChild(_sprite);
				
				_NinjaPool = _game.SimEntity.getComponent(NinjaPool) as NinjaPool;

				var backingQuad :Quad = new Quad(Settings.ScreenWidth, Settings.ScreenHeight, 0xcccccc);
				backingQuad.alpha = 0.9;
				_sprite.addChild(backingQuad);
			
				var layoutX :int = Settings.ScreenWidth * 0.5;
				var layoutY :int = 10;
				
				for (var rank :int = 0; rank < NinjaPool.NUM_NINJA_RANKS; rank++)
				{
					var textureName :String = NinjaPool.ninjaTextureName(rank, "attack");
					var img :Image = new Image(Assets.Sprites.getTexture(textureName));
					img.height = 48;
					img.width = 48;
					img.x = layoutX - 40;
					img.y = layoutY;
					_sprite.addChild(img);
					
					var tf :TextField = new TextField(Settings.ScreenWidth / 3, 50, "", Settings.DefaultFont, Settings.FontSize);
					tf.hAlign = HAlign.LEFT;
					tf.x = layoutX + 20;
					tf.y = layoutY;
					tf.text = "x " + Utils.formatNumber(_NinjaPool.ninjaCountAtRank(rank));
					_sprite.addChild(tf);
					_rankCountText[rank] = tf;
					
					layoutY += 50;
				}
				
				var totalPower :TextField = new TextField(Settings.ScreenWidth / 3, 50, "", Settings.DefaultFont, Settings.FontSize);
				totalPower.text = "Combined Strength: " + Utils.formatNumber(_NinjaPool.TotalPower);
				totalPower.x = layoutX - totalPower.width * 0.5;
				totalPower.y = layoutY;
				_sprite.addChild(totalPower);
				layoutY += 50;
			
				var exitButton :Button = new Button();
				exitButton.label = "Back";
				exitButton.addEventListener(Event.TRIGGERED, function() :void { _parent.handleChildDone(); } );
				exitButton.width = 100;
				exitButton.x = layoutX - exitButton.width * 0.5;
				exitButton.y = layoutY;
				_sprite.addChild(exitButton);
				layoutY += 50;
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

	} // class

} // package