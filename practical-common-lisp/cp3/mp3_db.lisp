(defun make-cd (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))


;; this is the global db
(defvar *db* nil)

;; add records
(defun add-record (cd) (push cd *db*))

(add-record (make-cd "Roses" "Kathy Mattea" 7 t))
(add-record (make-cd "Fly" "Dixie Chicks" 8 t))
(add-record (make-cd "Home" "Dixie Chicks" 9 t))

;; dump db for human readable
(defun dump-db ()
  (dolist (cd *db*)
    (format t "~{~a: ~10t~a~%~}~%" cd)))

;; utils for input cd
(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))

(defun prompt-for-cd ()
  (make-cd
   (prompt-read "Title")
   (prompt-read "Artist")
   (or (parse-integer (prompt-read "Rating") :junk-allowed t))
   (y-or-n-p "Ripped [y/n]: ")))

;; loops for add cd
(defun add-cds ()
  (loop (add-record (prompt-for-cd))
     (if (not (y-or-n-p "Another? [y/n]: ")) (return))))

;; save/load db to file
(defun save-db (filename)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))

(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
        (setf *db* (read in)))))

;; CURD for db
(defun select-by-artist (artist)
  (remove-if-not
   #'(lambda (cd) (equal (getf cd :artist) artist))
   *db*))
;; general select func
(defun select (selector-fn)
  (remove-if-not selector-fn *db*))

(defun artist-selector (artist)
  #'(lambda (cd) (equal (getf cd :artist) artist)))

;; general selector func
(defun where (&key title artist rating (ripped nil ripped-p))
  #'(lambda (cd)
            (and
             (if title (equal (getf cd :title) title) t)
             (if artist (equal (getf cd :artist) artist) t)
             (if rating (equal (getf cd :rating) rating) t)
             (if ripped-p (equal (getf cd :ripped) ripped) t))))
;; update rows
(defun update (selector-fn &key title artist rating (ripped nil ripped-p))
  (setf *db*
        (mapcar
         #'(lambda (row)
             (when (funcall selector-fn row)
               (if title (setf (getf row :title) title))
               (if artist (setf (getf row :artist) artist))
               (if rating (setf (getf row :rating) rating))
               (if ripped-p (setf (getf row :ripped) ripped)))
             row) *db*)))
;; delete rows
(defun delete-rows (selector-fn)
  (setf *db* (remove-if selector-fn *db*)))

;; remove duplication code
(defun make-comparison-expr (field value)
  (list 'equal (list 'getf 'cd field) value))
(defun make-comparison-expr2 (field value)
  `(equal (getf cd ,field) ,value))

(defun make-comparison-list (fields)
  (loop while fields
     collecting (make-comparison-expr2 (pop fields) (pop fields))))

(defmacro where2 (&rest clauses)
  `#'(lambda (cd) (and ,@(make-comparison-list clauses))))