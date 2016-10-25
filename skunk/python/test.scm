
(define assert (lambda (x)
	(if (= x (quote true))
		()
		(print (quote Failure!)))))

(assert (= (+ 1 2) 3))
(assert (= (+ 3 5) 8))
