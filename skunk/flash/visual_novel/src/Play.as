package  
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.display.Sprite;
	
	public class Play 
	{
		public var actors :Dictionary;
		public var chapters :Dictionary;
		
		public function Play() 
		{
			actors = new Dictionary();
			chapters = new Dictionary();
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
			actors = new Dictionary();
			chapters = new Dictionary();
			
			if (data.name().localName != "play")
			{
				throw new Error("unexpected XML format for play data");
			}
			
			for each (var child :XML in data.children())
			{
				addData(child);
			}
		}
		
		private function addData(data :XML) :void
		{
			switch (data.name().localName)
			{
				case "actor":
					var actor :Actor = new Actor();
					actor.initFromXML(data);
					actors[actor.id] = actor;
					break;
					
				case "chapter":
					var chapter :Chapter = new Chapter();
					chapter.initFromXML(data);
					chapters[chapter.id] = chapter;
					break;
			}
		}
		
		public function runScene(chapterId :String, sceneId :String, parent :Sprite) :void
		{
			var chapter :Chapter = chapters[chapterId];
			var scene :Scene = chapter.scenes[sceneId];
			
			run(scene, parent);
		}
		
		public function run(scene :Scene, parent :Sprite) :void
		{
			for each (var line :Line in scene.lines)
			{
				trace(line.speaker);
				trace(line.dialogue);
			}
		}
	}

} // package
