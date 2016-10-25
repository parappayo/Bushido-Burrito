
# this is not the original lis.py, but a customized version
# see: http://norvig.com/lispy.html

import math, operator

Symbol = str
List = list
Number = (int, float)
Environment = dict

def tokenize(input):
	return input.replace('(', ' ( ').replace(')', ' ) ').split()

def atom(token):
	try: return int(token)
	except ValueError:
		try: return float(token)
		except ValueError:
			return Symbol(token)

def parse(tokens):
	if len(tokens) == 0:
		raise SyntaxError('unmatched ( in input')
	token = tokens.pop(0)
	if token == '(':
		innerList = []
		while tokens[0] != ')':
			innerList.append(parse(tokens))
		tokens.pop(0)
		return innerList
	elif token == ')':
		raise SyntaxError('unmatched ) in input')
	else:
		return atom(token)

def standard_environment():
	environment = Environment()
	environment.update(vars(math))
	environment.update({
			'+': operator.add,
			'-': operator.sub,
			'*': operator.mul,
			'/': operator.div,
			'=': operator.eq,
			'>': operator.gt,
			'<': operator.lt,
			'>=': operator.ge,
			'<=': operator.le,
			'abs': abs,
			'append': operator.add,
			'apply': apply,
			'begin': lambda *x: x[-1],
			'car': lambda x: x[0],
			'cdr': lambda x: x[1:],
			'cons': lambda x, y: [x] + y,
			'eq?': operator.is_,
			'equal?': operator.eq,
			'length': len,
			'list': lambda *x: List(x),
			'map': map,
			'max': max,
			'min': min,
			'not': operator.not_,
			'null?': lambda x: x == [],
			'number?': lambda x: isinstance(x, Number),
			'procedure?': callable,
			'round': round,
			'symbol?': lambda x: isinstance(x, Symbol),
		})
	return environment

global_environment = standard_environment()

def eval(expression, env=global_environment):
	if isinstance(expression, Symbol):
		return env[expression]
	elif not isinstance(expression, List):
		return expression
	elif expression[0] == 'if':
		(_, condition, consequent, alternative) = expression
		expression = consequent if eval(condition, env) else alternative
		return eval(expression, env)
	elif expression[0] == 'define':
		(_, identifier, expression) = expression
		env[identifier] = eval(expression, env)
	else:
		procedure = eval(expression[0], env)
		args = [eval(arg, env) for arg in expression[1:]]
		return procedure(*args)

def eval_str(input):
	return eval(parse(tokenize(input)))

def scheme_str(expression):
	if isinstance(expression, List):
		return '(' + ' '.join(map(scheme_str, expression)) + ')'
	else:
		return str(expression)

def repl(prompt='> '):
	while True:
		input_str = raw_input(prompt)
		val = eval_str(input_str)
		print(scheme_str(val))

if __name__ == '__main__':
	repl()
