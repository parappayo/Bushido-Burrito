package  
{
	import flash.utils.Dictionary;
	
	public class Actor 
	{
		public var id :String;
		public var portraits :Dictionary;
		
		public function Actor()
		{
			portraits = new Dictionary();
		}
		
		public function initFromXML(data :XML) :void
		{
			if (data.name().localName != "actor")
			{
				throw new Error("unexpected XML format for actor data");
			}
			
			id = data.@id;
		}
	}

} // package
