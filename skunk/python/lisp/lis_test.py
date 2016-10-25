import unittest, lis

class TestEval(unittest.TestCase):

	def test_add(self):
		self.assertEqual(lis.eval_str("(+ 1 2)"), 3)

	def test_sub(self):
		self.assertEqual(lis.eval_str("(- 1 2)"), -1)

	def test_mul(self):
		self.assertEqual(lis.eval_str("(* 2 3)"), 6)

	def test_div(self):
		self.assertEqual(lis.eval_str("(/ 10 2)"), 5)

	def test_eq(self):
		self.assertEqual(lis.eval_str("(= 1 2)"), False)

	def test_eq2(self):
		self.assertEqual(lis.eval_str("(= 2 2)"), True)

	def test_length(self):
		self.assertEqual(lis.eval_str("(length '(1 2 3))"), 3)

	def test_length2(self):
		self.assertEqual(lis.eval_str("(length '(1))"), 1)

	def test_length3(self):
		self.assertEqual(lis.eval_str("(length '())"), 0)

	def test_cons(self):
		self.assertEqual(lis.eval_str("(cons 1 '())"), [1])

	def test_cons2(self):
		self.assertEqual(lis.eval_str("(cons 1 '(2))"), [1, 2])

if __name__ == '__main__':
	unittest.main()
