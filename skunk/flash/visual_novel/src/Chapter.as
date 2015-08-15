package  
{
	import flash.utils.Dictionary;
	
	public class Chapter 
	{
		public var id :String;
		public var scenes :Dictionary;
		
		public function Chapter() 
		{
			scenes = new Dictionary();
		}
		
		public function initFromXML(data :XML) :void
		{
			scenes = new Dictionary();

			if (data.name().localName != "chapter")
			{
				throw new Error("unexpected XML format for chapter data");
			}
			
			id = data.@id;
			
			for each (var child :XML in data.children())
			{
				var scene :Scene = new Scene();
				scene.initFromXML(child);
				scenes[scene.id] = scene;
			}
		}
	}

} // package
