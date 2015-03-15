package  
{
	import flash.display.Sprite;

	public class Menu extends Sprite
	{
		private var _menuItems :Array;
		private var _slots :Array;
		
		public function Menu(numSlots :int) 
		{
			_menuItems = new Array();
			_slots = new Array();
			
			for (var i :int = 0; i < numSlots; i++)
			{
				var slot :MenuSlot = new MenuSlot();
				_slots.push(slot);
				addChild(slot);
			}
		}
		
		public function addItem(item :MenuItem) :void
		{
			_menuItems.push(item);
		}
		
		public function refresh() :void
		{
			var y :Number = 0;
			var spacing :Number = 4;
			
			for (var i :int = 0; i < _slots.length; i++)
			{
				var slot :MenuSlot = _slots[i];
				
				// TODO: use menu scroll position to get the correct item
				var item :MenuItem = _menuItems[i];
				
				if (item != null)
				{
					slot.setItem(_menuItems[i]);
				}
		
				slot.y = y;
				y += slot.height + spacing;
			}
		}
		
	}
}
