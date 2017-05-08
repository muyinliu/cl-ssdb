(in-package :cl-user)

(defpackage #:cl-ssdb
  (:use #:cl #:rutil)
  (:nicknames #:ssdb)
  (:shadow #:quit #:set #:get #:substr #:append
           #+:sbcl #:defconstant)
  #+:sb-package-locks (:lock t)
  (:export #:ssdb-connection
           #:connect
           #:disconnect
           #:reconnect
           #:*connection*
           #:open-connection
           #:close-connection
           #:connected-p
           #:with-connection
           #:with-recursive-connection
           #:with-persistent-connection
           #:with-pipelining

           ;; Debug
           #:*echo-p*
           #:*echo-stream*

           #:def-cmd
           #:export
           #:tell

           ;; Conditions
           #:ssdb-error
           #:ssdb-bad-reply
           #:ssdb-error-reply
           #:ssdb-connection-error))
