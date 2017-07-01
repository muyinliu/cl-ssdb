(defsystem "cl-ssdb"
  :name "cl-ssdb"
  :description "SSDB client for Common Lisp."
  :version "0.0.1"
  :author "Muyinliu Xing <muyinliu@gmail.com>, Vsevolod Dyomkin <vseloved@gmail.com>"
  :license "MIT"
  :depends-on ("rutils" "cl-ppcre" "usocket" "flexi-streams" "parse-number" "babel")
  :in-order-to ((test-op (test-op "cl-ssdb-test")))
  :serial t
  :components ((:file "packages")
               (:file "connection")
               (:file "cl-ssdb")
               (:file "commands")))
