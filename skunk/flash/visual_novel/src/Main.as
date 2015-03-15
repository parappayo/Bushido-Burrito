package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main extends Sprite 
	{
		public var mainMenu :Menu;
		
		public function Main() :void
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e :Event = null) :void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var numSlots :int = 3;
			
			mainMenu = new Menu(numSlots);
			mainMenu.addItem(new MenuItem("New Game")); // TODO: localize me
			mainMenu.addItem(new MenuItem("Continue")); // TODO: localize me
			mainMenu.refresh();
			addChild(mainMenu);
		}
		
	}
}
