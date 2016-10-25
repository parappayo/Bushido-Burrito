
# this is not the original lis.py, but a customized version
# see: http://norvig.com/lispy.html

from __future__ import print_function
import sys, math, operator

Symbol = str
List = list
Number = (int, float)

class Environment(dict):
	def __init__(self, params=(), args=(), outer=None):
		self.update(zip(params, args))
		self.outer = outer

	def find(self, identifier):
		if identifier in self:
			return self
		elif self.outer != None:
			return self.outer.find(identifier)
		else:
			return None

class Procedure(object):
	def __init__(self, params, body, environment):
		self.params, self.body, self.environment = params, body, environment

	def __call__(self, *args):
		return eval(self.body, Environment(self.params, args, self.environment))

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
	if token == "'":
		innerList = ['quote']
		innerList.append(parse(tokens))
		return innerList
	elif token == '(':
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
			'print': print,
			'procedure?': callable,
			'round': round,
			'symbol?': lambda x: isinstance(x, Symbol),
		})
	return environment

global_environment = standard_environment()

def eval(expression, env=global_environment):
	if isinstance(expression, Symbol):
		local_env = env.find(expression)
		if local_env == None:
			raise SyntaxError('unknown identifier ' + expression)
		return local_env[expression]
	elif not isinstance(expression, List):
		return expression
	elif expression[0] == 'quote':
		(_, inner_expression) = expression
		return inner_expression
	elif expression[0] == 'if':
		(_, condition, consequent, alternative) = expression
		expression = consequent if eval(condition, env) else alternative
		return eval(expression, env)
	elif expression[0] == 'define':
		(_, identifier, expression) = expression
		env[identifier] = eval(expression, env)
	elif expression[0] == 'set!':
		(_, identifier, inner_expression) = expression
		environment.find(identifier)[identifier] = eval(inner_expression, env)
	elif expression[0] == 'lambda':
		(_, params, body) = expression
		return Procedure(params, body, env)
	else:
		procedure = eval(expression[0], env)
		args = [eval(arg, env) for arg in expression[1:]]
		return procedure(*args)

def eval_str(input):
	result = None
	tokens = tokenize(input)
	while len(tokens) > 0:
		result = eval(parse(tokens))
	return result

def eval_file(path):
	file = open(path, 'r')
	return eval_str(file.read())

def scheme_str(expression):
	if isinstance(expression, List):
		return '(' + ' '.join(map(scheme_str, expression)) + ')'
	else:
		return str(expression)

def repl(prompt='> '):
	while True:
		input_str = raw_input(prompt)
		if len(input_str) == 0:
			sys.exit()
		val = eval_str(input_str)
		print(scheme_str(val))

if __name__ == '__main__':
	if len(sys.argv) > 1:
		print(scheme_str(eval_file(sys.argv[1])))
	else:
		repl()
