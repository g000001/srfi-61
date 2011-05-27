;;;; srfi-61.asd

(cl:in-package :asdf)

(defsystem :srfi-61
  :serial t
  :depends-on (:mbe)
  :components ((:file "package")
               (:file "srfi-61")))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-61))))
  (load-system :srfi-61)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :srfi-61-internal :srfi-61))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

