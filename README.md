# CL-SSDB - A fast and robus Common Lisp client for SSDB

Note: [SSDB](http://ssdb.io/), A high performance NoSQL database supporting many data structures, an alternative to Redis.

## Install
```shell
git clone https://github.com/muyinliu/cl-ssdb
cp -r cl-ssdb ~/quicklisp/local-projects/cl-ssdb
```

```lisp
(ql:quickload 'cl-ssdb)
```
```=>
To load "cl-ssdb":
  Load 1 ASDF system:
    cl-ssdb
; Loading "cl-ssdb"

(CL-SSDB)
```

## Dependencies
* [usocket](http://common-lisp.net/project/usocket/)
* [flexi-streams](http://common-lisp.net/project/flexi-streams/)
* [rutils](http://github.com/vseloved/rutils)
* [cl-ppcre](http://www.weitz.de/cl-ppcre/)

## Usage
### connect to SSDB
```lisp
(ssdb:connect)
```
```=>
#<SSDB-CONNECTION {100C74B673}>
```

### auth with password
```lisp
(ssdb:auth "8AgYA/ougM9DCvtS9l172ddhb+v/nIAPvVpJjMdzHz0VnkB6Ji3qC904O1XuOj+6ZD9cqJq3xgsPQRUzGDA9YZfI8z/hA5G6fIxnB9g/VLUo4GrEHRJ5bMV3h8MknaHreQQ7wjxuzgkNLfrxsev6ZULCXWUizbNU3hthMIQjjtS6L+yRnOcKBH+f7IsCyZJsikCmNSFpyN2DaKqFnqTJphueuodkKAqK+N3iCjsrhuucvW3GkZOpXkBILicSDZ36dXQnKDQPctr8w4RTLzbg0lb7b5qcO134A6aVRl4WrBScwRf6HNB+r0p+8zeWAcmdtIQbYwY0wh7A6tS0mWOpTTD5BQCiqL+WwZkL3i2K3wAK0tx3WI9g8I4k8JBwxdLwi0I1UW2dF5oMpk4KppB6nqckya4ybkyGAFw6op3IhAa6m/jvWZUaZrN8im/tlcCoDFfQCywWx4V06eqa35221c+9DbpXfFvJcFxZ6xKJkf0I34SIarLI+pVqm/k3Q0Dc")
```
```=>
"ok"
```

### command examples
```lisp
(ssdb:ping)
```
```=>
"ok"
```

```lisp
(ssdb:set "key1" "value1")
```
```=>
"ok"
```

```lisp
(ssdb:get "key1")
```
```=>
"value1"
```

## Run test case
In Common Lisp REPL:
```lisp
(asdf:test-system :cl-ssdb)
```

OR in Shell:
```shell
sbcl --eval "(asdf:test-system :cl-ssdb)" --eval "(quit)"
```

## License
MIT (See LICENSE file for details).
