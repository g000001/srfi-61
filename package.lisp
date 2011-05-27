;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :srfi-61
  (:export :cond))

(defpackage :srfi-61-internal
  (:use :srfi-61 :cl :fiveam :mbe)
  (:shadowing-import-from :srfi-61 :cond)
  (:shadow :t))

