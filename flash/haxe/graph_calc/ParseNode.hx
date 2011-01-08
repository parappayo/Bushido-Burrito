
class ParseNode
{
	public var type :Int;
	public var tokensConsumed :Int;

	public var left :ParseNode;
	public var right :ParseNode;

	public var value :Float;

	// node types
	public static var NULL			= 0;
	public static var NUMBER_CONST	= 1;
	public static var X_VALUE		= 2;
	public static var T_VALUE		= 3;
	public static var ADD			= 4;
	public static var SUBTRACT		= 5;
	public static var MULTIPLY		= 6;
	public static var DIVIDE		= 7;
	public static var SINE			= 8;
	public static var COSINE		= 9;

	public function new()
	{
		type = NULL;
		tokensConsumed = 0;
		value = 0;
	}

	public function eval(x :Float, t :Float) :Float
	{
		if (type == NULL) {
			trace("error: evaluate called on a null parse node");
			return 0;
		}

		if (type == NUMBER_CONST) {
			return value;
		}

		if (type == X_VALUE) {
			return x;
		}

		if (type == T_VALUE) {
			return t;
		}

		if (type == ADD) {
			return left.eval(x, t) + right.eval(x, t);
		}

		if (type == SUBTRACT) {
			return left.eval(x, t) - right.eval(x, t);
		}

		if (type == MULTIPLY) {
			return left.eval(x, t) * right.eval(x, t);
		}

		if (type == DIVIDE) {
			return left.eval(x, t) / right.eval(x, t);
		}

		if (type == SINE) {
			return Math.sin(left.eval(x, t));
		}

		if (type == COSINE) {
			return Math.cos(left.eval(x, t));
		}

		trace("error: unhandled parse node type");
		return 0;
	}
}

