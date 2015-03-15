package ui.widgets 
{
	import feathers.core.*;
	import feathers.data.*;
	import feathers.controls.*;
	import feathers.controls.renderers.*;
	
	import starling.display.Quad;
	import starling.text.TextField;
	
	import sim.Character;

	public class PartyView extends FeathersControl
	{
		protected var _characters :Vector.<Character>;
		protected var _characterViews :Object;
		
		public const MaxPartySize :int = 10;
		
		public function PartyView() 
		{
			_characters = new Vector.<Character>();
			_characterViews = new Object();
		}
		
		public function addCharacter(chara :Character, postCombat :Boolean = false) :void
		{
			if (_characters.length >= MaxPartySize) { return; }
			
			_characters.push(chara);
			
			var widget :CharacterView = postCombat ? new CharacterPostCombatView() : new CharacterView();
			widget.populate(chara);
			_characterViews[chara.Name] = widget;

			addChild(widget);
		}
		
		public function refreshLayout() :void
		{
			var childWidth :int = width / 2;
			var childHeight :int = height / 5;
			
			var i :int = 0;
			for each (var chara :Character in _characters)
			{
				var charaView :CharacterView = _characterViews[chara.Name];
				
				charaView.width = childWidth;
				charaView.height = childHeight;
				charaView.refreshLayout();
				
				// two-column layout
				if (i < 5)
				{
					charaView.x = 0;
					charaView.y = i * childHeight;
				}
				else
				{
					charaView.x = childWidth;
					charaView.y = (i - 5) * childHeight;
				}
				
				i++;
			}
		}
		
		public function updateData(chara :Character) :void
		{
			var charaView :CharacterView = _characterViews[chara.Name];
			if (!charaView) { return; }
			charaView.updateData(chara);
		}
		
	} // class

} // package
