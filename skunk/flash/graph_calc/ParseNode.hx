
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

	public function clone(source :ParseNode)
	{
		type = source.type;
		tokensConsumed = source.tokensConsumed;
		left = source.left;
		right = source.right;
		value = source.value;
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

	public function debugPrint() :Void
	{
		switch(type)
		{
			case NULL:
				trace("node type: NULL");

			case NUMBER_CONST:
				trace("node type: NUMBER_CONST");
				trace("node value: " + value);

			case X_VALUE:
				trace("node type: X_VALUE");

			case T_VALUE:
				trace("node type: T_VALUE");

			case ADD:
				trace("node type: ADD");
				debugPrintBinaryOp();

			case SUBTRACT:
				trace("node type: SUBTRACT");
				debugPrintBinaryOp();

			case MULTIPLY:
				trace("node type: MULTIPLY");
				debugPrintBinaryOp();

			case DIVIDE:
				trace("node type: DIVIDE");
				debugPrintBinaryOp();

			case SINE:
				trace("node type: SINE");
				debugPrintUnaryOp();

			case COSINE:
				trace("node type: COSINE");
				debugPrintUnaryOp();

			default:
				trace("error: unknown node type");
		}
	}

	private function debugPrintBinaryOp()
	{
		trace("start left side");
		left.debugPrint();
		trace("end left side");
		trace("start right side");
		right.debugPrint();
		trace("end right side");
	}

	private function debugPrintUnaryOp()
	{
		trace("start inner node");
		left.debugPrint();
		trace("end inner node");
	}
}

