
class Token
{
	public var type :Int;
	public var text :String;
	public var value :Float;

	// token types
	public static var UNKNOWN	= 0;
	public static var WHITESPACE	= 1;
	public static var NUMBER	= 2;
	public static var ADD		= 3;
	public static var SUBTRACT	= 4;
	public static var MULTIPLY	= 5;
	public static var DIVIDE	= 6;
	public static var SINE		= 7;
	public static var COSINE	= 8;
	public static var PI		= 9;
	public static var X_VAR		= 10;
	public static var T_VAR		= 11;
	public static var L_PAREN	= 12;
	public static var R_PAREN	= 13;

	public function new()
	{
		type = UNKNOWN;
	}
}

