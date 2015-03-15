package  
{
	public class Utils 
	{
		public static function formatNumber(num :Number) :String
		{
			if (num < 1000) { return num.toFixed(0); }
			if (num < 1000000) { return (num / 1000).toFixed(1) + "k"; }
			if (num < 1000000000) { return (num / 1000000).toFixed(1) + "M"; }
			if (num < 1000000000000) { return (num / 1000000000).toFixed(1) + "G"; }
			if (num < 1000000000000000) { return (num / 1000000000000).toFixed(1) + "T"; }
			return num.toExponential(1);
		}
	}

} // package
