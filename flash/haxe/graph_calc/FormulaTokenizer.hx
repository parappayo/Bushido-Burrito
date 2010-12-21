
class FormulaTokenizer
{
	public var result :Array<Token>;
	public var errorMessage :String;

	public function new()
	{
	}

	public function tokenize(text :String) :Bool
	{
		result = new Array();
		errorMessage = "";

		var i :Int = 0;
		while (i < text.length)
		{
			var next :Token = getNextToken(text, i);
			i += next.text.length;
			result.push(next);

			if (next.type == Token.UNKNOWN)
			{
				errorMessage = "unknown token";
			}
		}

		return false;  // stub
	}

	public function getNextToken(text :String, i :Int) :Token
	{
		var retval :Token = new Token();

		retval.type = Token.UNKNOWN;
		retval.text = "";

		if (isWhitespace(text.charAt(i)))
		{
			retval.type = Token.WHITESPACE;
			retval.text += text.charAt(i);

			i += 1;
			while (isWhitespace(text.charAt(i)))
			{
				retval.text += text.charAt(i);
				i += 1;
			}
		}

		return retval;
	}

	public function isWhitespace(text :String) :Bool
	{
		var whitespace = " \t\n\r";

		var i :Int;
		for (i in 0...text.length)
		{
			if (whitespace.indexOf(text.charAt(i)) == -1)
			{
				return false;
			}
		}

		return true;
	}
}

