package ui.screens 
{
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import ui.flows.Flow;
	import ui.flows.FlowStates;
	import resources.Atlases;
	
	public class Hud extends Screen 
	{
		private var _sprite :Sprite;
		private var _lifebar :Image;
		private var _weaponIcon :Image;
		
		// size of the backing along the screen bottom
		private var barW :Number = Settings.ScreenWidth;
		private var barH :Number = 64;
		
		// cached values
		private var _healthValue :Number;
		private var _hasDisc :Boolean;
		
		private var _lifebarTextures :Array = [
			new Image(Atlases.UITextures.getTexture("lifebar_00")),
			new Image(Atlases.UITextures.getTexture("lifebar_01")),
			new Image(Atlases.UITextures.getTexture("lifebar_02")),
			new Image(Atlases.UITextures.getTexture("lifebar_03")),
			new Image(Atlases.UITextures.getTexture("lifebar_04")),
			new Image(Atlases.UITextures.getTexture("lifebar_05")),
			new Image(Atlases.UITextures.getTexture("lifebar_06")),			
		];
		
		private var _discOnTexture :Image = new Image(Atlases.UITextures.getTexture("disc_on"));
		private var _discOffTexture :Image = new Image(Atlases.UITextures.getTexture("disc_off"));

		public function Hud(parent:Flow, game:Game) 
		{
			super(parent, game);
			
			_sprite = new Sprite();
			
			const padding :Number = 20;
			
			_hasDisc = _game.getPlayer().hasDisc();
			_healthValue = _game.getPlayer().getHealth();
			refresh();
		}
		
		override public function update(elapsed :Number) :void
		{
			const hasDisc :Boolean = _game.getPlayer().hasDisc();
			const healthValue :Number = _game.getPlayer().getHealth();
			if (_hasDisc != hasDisc || _healthValue != healthValue)
			{
				_hasDisc = hasDisc;
				_healthValue = healthValue;
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
			
			_lifebar = _lifebarTextures[Math.ceil(_healthValue)];
			_lifebar.x = padding + 10;
			_lifebar.y = Settings.ScreenHeight - _lifebar.height - barH / 2;
			_sprite.addChild(_lifebar);
			
			if (_weaponIcon != null)
			{
				_sprite.removeChild(_weaponIcon, true);
			}
			
			if (_hasDisc)
			{
				_weaponIcon = _discOnTexture;
			}
			else
			{
				_weaponIcon = _discOffTexture;
			}
				
			_weaponIcon.x = Settings.ScreenWidth - _weaponIcon.width - padding - 10;
			_weaponIcon.y = Settings.ScreenHeight - _weaponIcon.height - barH / 2;
			_sprite.addChild(_weaponIcon);
		}
		
	} // class
	
} // package
