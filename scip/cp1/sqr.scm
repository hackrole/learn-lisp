(define (square x) (* x x))
(define (average x y) (/ (+ x y) 2))
(define (sqrt x)
  (define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.0001))
  (define (improve guess x)
    (average (/ x guess) guess))
  (define (sqrt-iter guess x)
    (if (good-enough? guess x)
        guess
        (sqrt-iter (improve guess x) x)))
  (sqrt-iter 1.0 x))

(define (squ3 x) (* x x x))
(define (sqrt3 x)
  (define (good-enough? guess x)
    (< (/ (abs (- (squ3 guess) x)) x) 0.0001))
  (define (improve guess x)
    (/ (+ (/ x (square guess)) (* 2 guess)) 3))
  (define (sqrt3-iter guess x)
    (if (good-enough? guess x)
        guess
        (sqrt3-iter (improve guess x) x)))
  (sqrt3-iter 1.0 x))


(sqrt 8)
