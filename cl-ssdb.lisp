(in-package :ssdb)


;; Utils.

(defun ensure-string (obj)
  (typecase obj
    (string obj)
    (symbol (string obj))
    (t (princ-to-string obj))))

;;; Conditions

(define-condition ssdb-error (error)
  ((error :initform nil
          :initarg :error
          :reader ssdb-error-error)
   (message :initform nil
            :initarg :message
            :reader ssdb-error-message))
  (:report (lambda (e stream)
             (format stream
                     "SSDB error: ~A~:[~;~2&~:*~A~]"
                     (ssdb-error-error e)
                     (ssdb-error-message e))))
  (:documentation "Any SSDB-related error."))

(define-condition ssdb-connection-error (ssdb-error)
  ()
  (:documentation "Conditions of this type are signaled when errors occur
that break the connection stream.  They offer a :RECONNECT restart."))

(define-condition ssdb-error-reply (ssdb-error)
  ()
  (:documentation "Error reply is received from SSDB server."))

(define-condition ssdb-bad-reply (ssdb-error)
  ()
  (:documentation "SSDB protocol error is detected."))


;;; Sending commands to the server

(defgeneric tell (cmd &rest args)
  (:documentation "Send a command to SSDB server over a socket connection.
CMD is the command name (a string or a symbol), and ARGS are its arguments
\(keyword arguments are also supported)."))

(defmethod tell :after (cmd &rest args)
  (declare (ignore cmd args))
  (force-output (conn-stream *connection*)))

(defmethod tell (cmd &rest args)
  (let* ((all-args (cl:append (ppcre:split "-" (ensure-string (string-downcase cmd)))
                              args))
         (command (with-output-to-string (stream)
                    (loop for arg in all-args
                       do (let ((arg (ensure-string arg)))
                            (format stream "~A~%~A~%"
                                    (length arg)
                                    arg)))
                    (format stream "~%")))
         (soc (flex:flexi-stream-stream (conn-stream *connection*))))
    (when *echo-p*
      (format *echo-stream* "> ~A~%" command))
    (write-sequence (flex:string-to-octets command :external-format :utf-8) soc)))


;; Pipelining

(defvar *pipelined* nil
  "Indicates, that commands are sent in pipelined mode.")

(defvar *pipeline* nil
  "A list of expected results from the current pipeline.")

(defmacro with-pipelining (&body body)
  "Delay execution of EXPECT's inside BODY to the end, so that all
commands are first sent to the server and then their output is received
and collected into a list.  So commands return :PIPELINED instead of the
expected results."
  `(if *pipelined*
       (progn
         (warn "Already in a pipeline.")
         ,@body)
       (with-reconnect-restart
         (let (*pipeline*)
           (let ((*pipelined* t))
             ,@body)
           (mapcar #'expect (reverse *pipeline*))))))


;;; Receiving replies

(defgeneric expect (type)
  (:documentation "Receive and process the reply of the given type from SSDB server."))

(defmethod expect :around (type)
  (if *pipelined*
      (progn (push type *pipeline*)
             :pipelined)
      (call-next-method)))

(defun receive ()
  (let* ((conn-stream (conn-stream *connection*))
         result)
    (loop
       do (let ((size-string (read-line conn-stream nil nil)))
            (when (or (null size-string)
                      (zerop (length size-string)))
              (loop-finish))
            (let ((size (parse-integer size-string :junk-allowed t)))
              (when (or (null size)
                        (<= size 0))
                (error 'ssdb-bad-reply
                       :message (format nil "Received ~S as the initial reply line."
                                        size-string)))

              (let ((result-temp (make-array size :element-type 'character)))
                (read-sequence result-temp conn-stream)
                (push result-temp result)
                ;; Ignore each #\Newline after data
                (read-char conn-stream nil nil)))))
    (setf result (reverse result))
    (when *echo-p*
      (format *echo-stream* "> ~S~%" result))
    (let ((status (car result)))
      ;; status: ok, not_found, error, fail, client_error
      (when (or (equal "noauth" status)
                (equal "error" status)
                (equal "fail" status)
                (equal "client_error" status))
        (error 'ssdb-error-reply :message (second result))))
    result))

(defmethod expect ((type (eql :status)))
  "Receive and process status reply, which is just a string."
  (car (receive)))

(defmethod expect ((type (eql :integer)))
  (parse-integer (second (receive))))

(defmethod expect ((type (eql :boolean)))
  (ecase (parse-integer (second (receive)))
    (1 t)
    (0 nil)))

(defmethod expect ((type (eql :list)))
  "Receive and process data reply, which is a list of string."
  (rest (receive)))

(defmethod expect ((type (eql :bulk)))
  "Receive and process data reply, which is just a string."
  (let* ((result    (receive))
         (data-list (rest result)))
    (when *echo-p* (format *echo-stream* "< ~S~%" data-list))
    (when data-list
      (strjoin #\Newline data-list))))

(defmethod expect ((type (eql :end)))
  ;; Used for commands QUIT and SHUTDOWN (does nothing)
  )

;;; Command definition

(defvar *cmd-prefix* 'ssdb
  "Prefix for functions names that implement SSDB commands.")

(defmacro def-cmd (cmd (&rest args) reply-type docstring)
  "Define and export a function with the name <*CMD-REDIX*>-<CMD> for
processing a SSDB command CMD.  Here REPLY-TYPE is the expected reply
format."
  `(eval-always
     (defun ,cmd ,args
       ,docstring
       (return-from ,cmd
         (with-reconnect-restart
           ,(cond-it
              ((position '&optional args)
               `(apply #'tell ',cmd ,@(subseq args 0 it)
                       (let ((optional-args (list ,@(nthcdr (1+ it) args))))
                         (subseq optional-args 0 (position nil optional-args)))))
              ((position '&rest args)
               `(apply #'tell ',cmd ,@(subseq args 0 it) ,(nth (1+ it) args)))
              (t `(tell ',cmd ,@args)))
           (prog1 (expect ,reply-type)
             (unless *pipelined*
               (clear-input (conn-stream *connection*)))))))
     (import ',cmd '#:ssdb)
     (export ',cmd '#:ssdb)))

;;; end
