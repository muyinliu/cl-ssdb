(defsystem "cl-ssdb-test"
  :name "cl-ssdb-test"
  :description "test case for cl-ssdb"
  :author "Muyinliu Xing <muyinliu@gmail.com>, Vsevolod Dyomkin <vseloved@gmail.com>"
  :depends-on ("cl-ssdb" "prove")
  :defsystem-depends-on ("prove-asdf")
  :components ((:module "test"
                        :serial t
                        :components ((:file "cl-ssdb-test"))))
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
