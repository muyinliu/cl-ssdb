(defsystem :cl-ssdb
  :name "cl-ssdb"
  :version "0.0.1"
  :description "SSDB client for Common Lisp."
  :author "Muyinliu Xing <muyinliu@gmail.com>"
  :depends-on (:rutils :cl-ppcre :usocket :flexi-streams)
  :serial t
  :components ((:file "packages")
               (:file "connection")
               (:file "cl-ssdb")
               (:file "commands")))

(defmethod perform ((o test-op)
                    (c (eql (find-system 'cl-ssdb))))
  (load (merge-pathnames "test/cl-ssdb-test.lisp" (system-source-directory c))))

(defsystem :cl-ssdb-test
  :name "cl-ssdb-test"
  :description "test case for cl-ssdb"
  :depends-on (:cl-ssdb)
  :components ((:module "test"
                        :serial t
                        :components ((:file "cl-ssdb-test")))))
