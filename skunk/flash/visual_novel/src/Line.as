package  
{
	public class Line 
	{
		public var speaker :String;
		public var dialogue :String;
		
		public function initFromXML(data :XML) :void
		{
			if (data.name().localName != "line")
			{
				throw new Error("unexpected XML format for line data");
			}
			
			speaker = data.@speaker;
			dialogue = data.text()[0];
		}
	}

} // package
