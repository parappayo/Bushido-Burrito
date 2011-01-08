
class Test
{
	static var formulaTokenizer :FormulaTokenizer;
	static var formulaParser :FormulaParser;

	static function main()
	{
		formulaTokenizer = new FormulaTokenizer();
		formulaParser = new FormulaParser();

		test("0");
		test("3.14159");
		test("(1)");
		test("x");
		test("x + 1");
		test("x * t");
		test("sin(x)");
		test("sin(cos(x))");
		test("sin(x+3)");

		// some intentionally invalid ones
		trace("now starting the BAD PARSE tests");
		test("blah");
		test("(3");
		test("()");
	}

	static function test(text :String)
	{
		trace("testing: " + text);
		testInner(text);
		trace("done test");
	}

	static function testInner(text :String)
	{
		var tokenizeResult = formulaTokenizer.tokenize(text);
		if (!tokenizeResult) {
			trace(formulaTokenizer.errorMessage);
			return;
		}

		var parserResult = formulaParser.parse(formulaTokenizer);
		if (!parserResult) {
			for (error in formulaParser.errors) {
				trace(error);
			}
			return;
		}
	}
}

