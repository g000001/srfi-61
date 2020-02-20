;;;; srfi-61.asd

(cl:in-package :asdf)


(defsystem :srfi-61
  :version "20200221"
  :description "SRFI 61 for CL: A more general cond clause"
  :long-description "SRFI 61 for CL: A more general cond clause
https://srfi.schemers.org/srfi-61"
  :author "Taylor Campbell"
  :maintainer "CHIBA Masaomi"  
  :serial t
  :depends-on (:mbe :fiveam)
  :components ((:file "package")
               (:file "srfi-61")))


(defmethod perform :after ((o load-op) (c (eql (find-system :srfi-61))))
  (let ((name "https://github.com/g000001/srfi-61")
        (nickname :srfi-61))
    (if (and (find-package nickname)
             (not (eq (find-package nickname)
                      (find-package name))))
        (warn "~A: A package with name ~A already exists." name nickname)
        (rename-package name name `(,nickname)))))


(defmethod perform ((o test-op) (c (eql (find-system :srfi-61))))
  (let ((*package*
         (find-package
          "https://github.com/g000001/srfi-61#internals")))
    (eval
     (read-from-string
      "
      (or (let ((result (run 'srfi-61)))
            (explain! result)
            (results-status result))
          (error \"test-op failed\") )"))))


;;; *EOF*
