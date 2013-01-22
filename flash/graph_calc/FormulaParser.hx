
class FormulaParser
{
	public var errors :Array<String>;
	public var result :ParseNode;

	public function new()
	{
		errors = new Array<String>();
	}

	public function parse(tokens :FormulaTokenizer, node :ParseNode) :Bool
	{
		return parseExpression(tokens.result, 0, node);
	}

	public function parseExpression(
				tokens :Array<Token>,
				position :Int,
				node :ParseNode
		) :Bool
	{
		var retval :Bool = false;
		var tokensConsumed :Int = 0;
		node.tokensConsumed = 0;

		parseWhitespace(tokens, position, node);
		position += node.tokensConsumed;
		tokensConsumed += node.tokensConsumed;
	
		if (position >= tokens.length) {
			node.type = ParseNode.NULL;
			node.tokensConsumed = tokensConsumed;
			return true;
		}

		var token = tokens[position];

		if (token.type == Token.NUMBER) {
			node.type = ParseNode.NUMBER_CONST;
			node.value = token.value;
			tokensConsumed += 1;
			retval = true;
		}
		if (token.type == Token.PI) {
			node.type = ParseNode.NUMBER_CONST;
			node.value = Math.PI;
			tokensConsumed += 1;
			retval = true;
		}
		if (token.type == Token.X_VAR) {
			node.type = ParseNode.X_VALUE;
			tokensConsumed += 1;
			retval = true;
		}
		if (token.type == Token.T_VAR) {
			node.type = ParseNode.T_VALUE;
			tokensConsumed += 1;
			retval = true;
		}

		if (token.type == Token.L_PAREN) {
			retval = parseParensExpr(tokens, position, node);
			tokensConsumed += node.tokensConsumed;
		}

		if (!retval) {
			retval = parseUnaryOp(tokens, position, node);
			tokensConsumed += node.tokensConsumed;
		}

		if (retval) {
			var tempNode :ParseNode = new ParseNode();
			if (parseBinaryOp(
					tokens,
					position + tokensConsumed,
					tempNode,
					node)
				) {

				node.clone(tempNode);
				tokensConsumed += tempNode.tokensConsumed;
			}
		}

		if (!retval) {
			errors.push("invalid expression");
		}
		node.tokensConsumed = tokensConsumed;

		return retval;
	}

	private function parseWhitespace(
			tokens :Array<Token>,
			position :Int,
			node :ParseNode
		) :Bool
	{
		var retval :Bool = false;
		node.tokensConsumed = 0;

		if (position >= tokens.length) { return false; }
		var token :Token = tokens[position];

		if (token.type == Token.WHITESPACE) {
			node.tokensConsumed += 1;
			token = tokens[position + node.tokensConsumed];
			retval = true;
		}
		while (token.type == Token.WHITESPACE) {
			errors.push("error in tokenizer, adjacent whitespace tokens found");
			node.tokensConsumed += 1;
			token = tokens[position + node.tokensConsumed];
		}

		return retval;
	}

	private function parseParensExpr(
			tokens :Array<Token>,
			position :Int,
			node :ParseNode
		) :Bool
	{
		var tokensConsumed :Int = 0;
		node.tokensConsumed = 0;

		var token :Token = tokens[position];
		if (token.type != Token.L_PAREN) { return false; }
		tokensConsumed += 1;

		var result :Bool = parseExpression(tokens, position+1, node);
		if (!result) {
			errors.push("invalid expression between parenthesis");
			return false;
		}
		tokensConsumed += node.tokensConsumed;

		var whitespaceNode :ParseNode = new ParseNode();
		parseWhitespace(tokens, position, whitespaceNode);
		tokensConsumed += whitespaceNode.tokensConsumed;

		token = tokens[position + tokensConsumed];
		if (token.type != Token.R_PAREN) {
			errors.push("unmatched parenthesis");
			return false;
		}
		tokensConsumed += 1;

		node.tokensConsumed = tokensConsumed;
		return true;
	}

	
	private function parseBinaryOp(
			tokens :Array<Token>,
			position :Int,
			node :ParseNode,
			prevNode :ParseNode
		) :Bool
	{
		var tokensConsumed :Int = 0;

		parseWhitespace(tokens, position, node);
		position += node.tokensConsumed;
		tokensConsumed += node.tokensConsumed;

		if (position >= tokens.length) { return false; }
		var token :Token = tokens[position];

		if (token.type == Token.ADD) {
			node.type = ParseNode.ADD;
		} else if (token.type == Token.SUBTRACT) {
			node.type = ParseNode.SUBTRACT;
		} else if (token.type == Token.MULTIPLY) {
			node.type = ParseNode.MULTIPLY;
		} else if (token.type == Token.DIVIDE) {
			node.type = ParseNode.DIVIDE;
		} else {
			// not a binary op!
			return false;
		}

		node.left = new ParseNode();
		node.left.clone(prevNode);

		node.right = new ParseNode();
		if (!parseExpression(tokens, position+1, node.right)) {
			errors.push("invalid right operand");
			return false;
		}
		tokensConsumed += node.right.tokensConsumed;

		node.tokensConsumed = tokensConsumed;
		return true;
	}

	private function parseUnaryOp(
			tokens :Array<Token>,
			position :Int,
			node :ParseNode
		) :Bool
	{
		var retval :Bool = false;
		var tokensConsumed :Int = 0;
		var token = tokens[position];

		if (token.type == Token.SINE) {
			node.type = ParseNode.SINE;
		}
		else if (token.type == Token.COSINE) {
			node.type = ParseNode.COSINE;
		}
		else
		{
			// not a unary op
			return false;
		}

		tokensConsumed += 1;
		retval = true;

		// parse the operand
		node.left = new ParseNode();
		if (!parseExpression(tokens, position+1, node.left)) {
			errors.push("invalid operand");
			return false;
		}
		tokensConsumed += node.left.tokensConsumed;

		node.tokensConsumed = tokensConsumed;
		return retval;
	}
}
