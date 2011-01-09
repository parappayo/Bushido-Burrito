
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
				return false;
			}

			if (next.text.length < 1)
			{
				errorMessage = "tokenizer logic error";
				return false;
			}
		}

		return true;
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
		else if (text.charAt(i) == "(")
		{
			retval.type = Token.L_PAREN;
			retval.text += text.charAt(i);
			i += 1;
		}
		else if (text.charAt(i) == ")")
		{
			retval.type = Token.R_PAREN;
			retval.text += text.charAt(i);
			i += 1;
		}
		else if (text.charAt(i) == "+")
		{
			retval.type = Token.ADD;
			retval.text += text.charAt(i);
			i += 1;
		}
		else if (text.charAt(i) == "-")
		{
			retval.type = Token.SUBTRACT;
			retval.text += text.charAt(i);
			i += 1;
		}
		else if (text.charAt(i) == "*")
		{
			retval.type = Token.MULTIPLY;
			retval.text += text.charAt(i);
			i += 1;
		}
		else if (text.charAt(i) == "/")
		{
			retval.type = Token.DIVIDE;
			retval.text += text.charAt(i);
			i += 1;
		}
		else if (text.charAt(i) == "x" ||
			text.charAt(i) == "X")
		{
			retval.type = Token.X_VAR;
			retval.text += text.charAt(i);
			i += 1;
		}
		else if (text.charAt(i) == "t" ||
			text.charAt(i) == "T")
		{
			retval.type = Token.T_VAR;
			retval.text += text.charAt(i);
			i += 1;
		}
		else if (text.substr(i, 3) == "sin" ||
			text.substr(i, 3) == "SIN")
		{
			retval.type = Token.SINE;
			retval.text += text.substr(i, 3);
			i += 3;
		}
		else if (text.substr(i, 3) == "cos" ||
			text.substr(i, 3) == "COS")
		{
			retval.type = Token.COSINE;
			retval.text += text.substr(i, 3);
			i += 3;
		}
		else if (text.substr(i, 2) == "pi" ||
			text.substr(i, 2) == "PI")
		{
			retval.type = Token.PI;
			retval.text += text.substr(i, 2);
			i += 2;
		}
		else
		{
			// could be a number
			var numStrLen :Int = countNumericChars(text.substr(i));
			var numStr :String = text.substr(i, numStrLen);
			var value :Float = Std.parseFloat(numStr);

			if (value == 0.0 && text.charAt(i) != '0') {
				// nope, it wasn't a number
				trace("error: unknown token at position " + i);
			} else {
				retval.type = Token.NUMBER;
				retval.value = value;
				retval.text = numStr;
			}
		}

		return retval;
	}

	public function isWhitespace(text :String) :Bool
	{
		var r :EReg = ~/^[\t\n\r ]$/;
		return r.match(text);
	}

	public function countNumericChars(text :String) :Int
	{
		var r :EReg = ~/^([0-9\.])*/;
		if (!r.match(text)) { return 0; }
		return r.matchedPos().len;
	}

	public function debugTrace()
	{
		var token :Token;
		for (token in result)
		{
			trace(token.text + "=" + token.type);
		}
	}
}

