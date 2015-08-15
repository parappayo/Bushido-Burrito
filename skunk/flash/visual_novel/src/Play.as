package  
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.display.Sprite;
	
	public class Play 
	{
		public var actors :Vector.<Actor>;
		public var scenes :Vector.<Scene>;
		
		public function Play() 
		{
			scenes = new Vector.<Scene>();
		}

		public function init(data :Class) :void
		{
			var rawData :ByteArray = new data();
			var dataString :String = rawData.readUTFBytes(rawData.length);
			var dataXML :XML = new XML(dataString);
			
			initFromXML(dataXML);
		}

		public function initFromXML(data :XML) :void
		{
			if (data.name().localName != "play")
			{
				throw new Error("unexpected XML format for play data");
			}
		}
		
		public function runScene(actId :int, sceneId :int, parent :Sprite) :void
		{
		}
	}

} // package
