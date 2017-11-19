;; sample file to test the utest.lisp
(load "utest.lisp")

(deftest test-+ ()
  (check
    (= (+ 1 2) 3)
    (= (+ 1 2 3) 6)
    (= (+ -1 -3) -4)))

(deftest test-* ()
  (check
    (= (* 2 2) 5)
    (= (* 3 5) 15)))

(deftest test-arithmetic ()
  (combine-results
    (test-+)
    (test-*)))