
(define assert (lambda (x)
	(if (= x 'true)
		()
		(print 'Failure))))

(assert (= (+ 1 2) 3))
(assert (= (+ 3 5) 8))
