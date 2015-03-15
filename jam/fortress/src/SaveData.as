package  
{
	import flash.net.SharedObject;
	
	public class SaveData 
	{
		static private var _settings:SharedObject;
		static private var _progress:SharedObject;
		
		// settings
		// ...
		
		// progress
		static public var gameComplete:Boolean;
		
		static public function init():void
		{
			_settings = SharedObject.getLocal("settings");
			_progress = SharedObject.getLocal("progress");
			
			// progress
			gameComplete = false;
		}
		
		static public function Load():void
		{
			// progress
			gameComplete = _progress.data.gameComplete;
		}
		
		static public function Save():void
		{
			// settings
			_settings.flush();
			
			// progress
			_progress.data.gameComplete = gameComplete;
			_progress.flush();
		}
		
		static public function ResetSettings():void
		{
			_settings.clear();
		}
		
		static public function EraseProgress():void
		{
			_progress.clear();
		}
	}

}