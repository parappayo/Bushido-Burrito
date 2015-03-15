package ui.screens 
{
	import sim.Settings;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	
	public class Hud extends Screen 
	{
		private var _sprite :Sprite;
		private var _lifebar :Image;
		private var _weaponIcon :Image;
		private var _weaponText :TextField;
		
		// size of the backing along the screen bottom
		private var barW :Number = Settings.ScreenWidth;
		private var barH :Number = 64;
		
		// cached values
		private var _healthValue :Number;
		private var _hasSMG :Boolean;
		
		private var _lifebarTextures :Array = [
			new Image(Assets.UiTextures.getTexture("lifebar_00")),
			new Image(Assets.UiTextures.getTexture("lifebar_01")),
			new Image(Assets.UiTextures.getTexture("lifebar_02")),
			new Image(Assets.UiTextures.getTexture("lifebar_03")),
			new Image(Assets.UiTextures.getTexture("lifebar_04")),
			new Image(Assets.UiTextures.getTexture("lifebar_05")),
		];
		
		private var _pistolTexture :Image = new Image(Assets.UiTextures.getTexture("pistol_indicator"));
		private var _smgTexture :Image = new Image(Assets.UiTextures.getTexture("smg_indicator"));

		public function Hud(parent:Flow, game:Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			var bar :Quad = new Quad(barW, barH, 0xffffff);
			bar.y = Settings.ScreenHeight - barH;
			_sprite.addChild(bar);
			
			const padding :Number = 20;

			var healthText :TextField = new TextField(90, 32, "Health", "blacksquare", 18);
			healthText.x = padding;
			healthText.y = Settings.ScreenHeight - healthText.height - barH / 2;
			_sprite.addChild(healthText);
			
			_weaponText = new TextField(100, 32, "Weapon", "blacksquare", 18);
			_sprite.addChild(_weaponText);
			
			_hasSMG = _game.getPlayer().hasSMG();
			_healthValue = _game.getPlayer().getHealth();
			refresh();
		}
		
		override public function update(elapsed :Number) :void
		{
			if (_hasSMG != _game.getPlayer().hasSMG() ||
				_healthValue != _game.getPlayer().getHealth() )
			{
				_hasSMG = _game.getPlayer().hasSMG();
				_healthValue = _game.getPlayer().getHealth();
				
				refresh();
			}
		}
		
		public function show() :void
		{
			_game.UISprite.addChild(_sprite);
		}
		
		public function hide() :void
		{
			_game.UISprite.removeChild(_sprite);
		}
		
		public function refresh() :void
		{
			const padding :Number = 20;

			if (_lifebar != null)
			{
				_sprite.removeChild(_lifebar, true);
			}
			
			_lifebar = _lifebarTextures[_healthValue];
			_lifebar.x = 100;
			_lifebar.y = Settings.ScreenHeight - _lifebar.height - barH / 2;
			_sprite.addChild(_lifebar);
			
			if (_weaponIcon != null)
			{
				_sprite.removeChild(_weaponIcon, true);
			}
			
			if (_hasSMG)
			{
				_weaponIcon = _smgTexture;
			}
			else
			{
				_weaponIcon = _pistolTexture;
			}
				
			_weaponIcon.x = Settings.ScreenWidth - _weaponIcon.width - padding - 10;
			_weaponIcon.y = Settings.ScreenHeight - _weaponIcon.height - barH / 2;
			_sprite.addChild(_weaponIcon);
			
			_weaponText.x = Settings.ScreenWidth - _weaponIcon.width - _weaponText.width - padding;
			_weaponText.y = Settings.ScreenHeight - _weaponText.height - barH / 2;
		}
		
	} // class
	
} // package
