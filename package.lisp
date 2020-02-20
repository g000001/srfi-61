;;;; package.lisp

(cl:in-package cl-user)


(eval-when (:compile-toplevel :load-toplevel :execute)
  (intern "=>" 'cl-user)
  (intern (string '#:else) 'cl-user))


(defpackage "https://github.com/g000001/srfi-61"
  (:use)
  (:export cond =>))


(defpackage "https://github.com/g000001/srfi-61#internals"
  (:use "https://github.com/g000001/srfi-61"
        cl
        fiveam
        mbe)
  (:shadowing-import-from "https://github.com/g000001/srfi-61"
                          cond)
  (:shadow T))


;;; *EOF*


