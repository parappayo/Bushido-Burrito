package  
{
	public class Actor 
	{
		public var id :String;
		
		public function Actor() 
		{
			
		}
		
		public function initFromXML(data :XML) :void
		{
			if (data.name().localName != "actor")
			{
				throw new Error("unexpected XML format for actor data");
			}
		}
	}

} // package
