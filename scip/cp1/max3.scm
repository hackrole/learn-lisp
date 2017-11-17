(define (max2 a b)
  (if (> a b)
      a
      b))
(define (max3 a b c)
  (max a (max b c)))

(define (max3-1 a b c)
  (define (max a b) (if (> a b) a b))
  (max a (max b c)))

(max3 3 5 1)
(max3-1 5 2 55)
