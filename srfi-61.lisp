;;;; srfi-61.lisp

(cl:in-package :srfi-61-internal)

(def-suite srfi-61)

(in-suite srfi-61)

(defmacro call-with-values (producer consumer)
  `(multiple-value-call ,consumer (funcall ,producer)))

(define-syntax cond
  (syntax-rules (:=> :ELSE)

    ((COND (:ELSE else1 else2 ***))
     ;; The (IF #T (BEGIN ***)) wrapper ensures that there may be no
     ;; internal definitions in the body of the clause.  R5RS mandates
     ;; this in text (by referring to each subform of the clauses as
     ;; <expression>) but not in its reference implementation of COND,
     ;; which just expands to (BEGIN ***) with no (IF #T ***) wrapper.
     (IF :TRUE (PROGN else1 else2 ***)))

    ((COND (test :=> receiver) more-clause ***)
     (with ((T (gensym)))
       (LET ((T test))
         (COND/MAYBE-MORE T
                          (funcall receiver T)
                          more-clause ***))))

    ((COND (generator guard :=> receiver) more-clause ***)
     (with ((T (gensym)))
       (CALL-WITH-VALUES (LAMBDA () generator)
                         (LAMBDA (&REST T)
                           (COND/MAYBE-MORE (APPLY guard    T)
                                            (APPLY receiver T)
                                            more-clause ***)))))

    ((COND (test) more-clause ***)
     (with ((T (gensym)))
       (LET ((T test))
         (COND/MAYBE-MORE T T more-clause ***))))

    ((COND (test body1 body2 ***) more-clause ***)
     (COND/MAYBE-MORE test
                      (PROGN body1 body2 ***)
                      more-clause ***))))

(define-syntax cond/maybe-more
  (syntax-rules ()
    ((COND/MAYBE-MORE test consequent)
     (IF test
         consequent))
    ((COND/MAYBE-MORE test consequent clause ***)
     (IF test
         consequent
         (COND clause ***)))))

(test cond
  (is (equal (cond (8 #'numberp :=> #'list))
             '(8)))
  (is-true (cond ((funcall #'numberp 8) :=> #'values)))
  (is (= (let ((alist '((a . 1) (b . 2) (c . 3))))
           (cond ((assoc 'a alist) #'values :=> #'cdr)
                 (:else nil)))
         1))
  (is-false (let ((alist '((a . 1) (b . 2) (c . 3))))
              (cond ((assoc 'z alist) #'values :=> #'cdr)
                    (:else nil))))
  (is (eq 'a (srfi-61:cond (cl:t 'a)
                           (cl:t 'b)
                           (:else 'c))))
  (is (eq 'b (srfi-61:cond (cl:nil 'a)
                           (cl:t 'b)
                           (:else 'c)))))
