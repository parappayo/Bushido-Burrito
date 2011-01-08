
class FormulaParser
{
	public var errors :Array<String>;
	public var result :ParseNode;

	public function new()
	{
		errors = new Array<String>();
	}

	public function parse(tokens :FormulaTokenizer) :Bool
	{
		result = new ParseNode();
		return parseExpression(tokens.result, 0, result);
	}

	public function parseExpression(tokens :Array<Token>, position :Int, node :ParseNode) :Bool
	{
		node.tokensConsumed = 0;

		if (tokens.length == 0) {
			node.type = ParseNode.NULL;
			return true;
		}
	
		var token = tokens[position];

		if (token.type == Token.WHITESPACE) {
			position += 1;
			token = tokens[position];
		}
		if (token.type == Token.WHITESPACE) {
			errors.push("error in tokenizer, adjacent whitespace tokens found");
		}

		if (token.type == Token.NUMBER ||
			token.type == Token.X_VAR ||
			token.type == Token.T_VAR ||
			token.type == Token.PI ) {

			if (parseBinaryOp(tokens, position, node)) {
				return true;
			}

			// else it's a stand-alone value
			if (token.type == Token.NUMBER) {
				node.type = ParseNode.NUMBER_CONST;
				node.value = token.value;
			}

		}

		if (token.type == Token.L_PAREN) {
			return parseParensExpr(tokens, position, node);
		}

		errors.push("invalid expression");
		return false;
	}

	public function parseParensExpr(tokens :Array<Token>, position :Int, node :ParseNode) :Bool
	{
		var token :Token;
		var innerNode :ParseNode;

		node.tokensConsumed = 0;

		token = tokens[position];
		if (token.type != Token.L_PAREN) { return false; }

		innerNode = new ParseNode();
		var result :Bool = parseExpression(tokens, position+1, innerNode);
		if (!result) {
			errors.push("invalid expression between parenthesis");
			return false;
		}

		token = tokens[position + innerNode.tokensConsumed];
		if (token.type != Token.R_PAREN) {
			errors.push("unmatched parenthesis");
			return false;
		}

		node.tokensConsumed = innerNode.tokensConsumed + 2;
		return true;
	}

	
	public function parseBinaryOp(tokens :Array<Token>, position :Int, node :ParseNode) :Bool
	{
		return false;  // stub
	}

	public function parseUnaryOp(tokens :Array<Token>, position :Int, node :ParseNode) :Bool
	{
		return false;  // stub
	}
}
