package  
{
	public class Scene 
	{
		public var id :String;
		public var lines :Vector.<Line>;
		
		public function Scene() 
		{
			lines = new Vector.<Line>();
		}
		
		public function initFromXML(data :XML) :void
		{
			lines = new Vector.<Line>();

			if (data.name().localName != "scene")
			{
				throw new Error("unexpected XML format for scene data");
			}
			
			id = data.@id;

			for each (var child :XML in data.children())
			{
				var line :Line = new Line();
				line.initFromXML(child);
				lines.push(line);
			}
		}
	}

} // package
