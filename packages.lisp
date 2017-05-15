(in-package :cl-user)

(defpackage #:cl-ssdb
  (:use #:cl #:rutil)
  (:nicknames #:ssdb)
  (:shadow #:quit #:set #:get #:substr)
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
           #:ssdb-connection-error

           ;; Server Commands
           #:ping
           #:clear_binlog
           #:compact
           #:auth
           #:dbsize
           #:info
           #:flushdb

           ;; IP Filter Commands
           #:list_allow_ip
           #:add_allow_ip
           #:del_allow_ip
           #:list_deny_ip
           #:add_deny_ip
           #:del_deny_ip

           ;; Key Value Commands
           #:set
           #:setx
           #:setnx
           #:expire
           #:ttl
           #:get
           #:getset
           #:del
           #:incr
           #:exists
           #:getbit
           #:setbit
           #:bitcount
           #:countbit
           #:substr
           #:strlen
           #:keys
           #:rkeys
           #:scan
           #:rscan
           #:multi_set
           #:multi_get
           #:multi_del

           ;; Hashmap Commands
           #:hset
           #:hget
           #:hdel
           #:hincr
           #:hexists
           #:hsize
           #:hlist
           #:hrlist
           #:hkeys
           #:hgetall
           #:hscan
           #:hrscan
           #:hclear
           #:multi_hset
           #:multi_hget
           #:multi_hdel

           ;; Sorted Set Commands
           #:zset
           #:zget
           #:zdel
           #:zincr
           #:zexists
           #:zsize
           #:zlist
           #:zrlist
           #:zkeys
           #:zscan
           #:zrscan
           #:zrank
           #:zrrank
           #:zrange
           #:zrrange
           #:zclear
           #:zcount
           #:zsum
           #:zavg
           #:zremrangebyrank
           #:zremrangebyscore
           #:zpop_front
           #:zpop_back
           #:multi_zset
           #:multi_zget
           #:multi_zdel

           ;; List Commands
           #:qpush_front
           #:qpush_back
           #:qpop_front
           #:qpop_back
           #:qpush
           #:qpop
           #:qfront
           #:qback
           #:qsize
           #:qclear
           #:qget
           #:qset
           #:qrange
           #:qslice
           #:qtrim_front
           #:qtrim_back
           #:qlist
           #:qrlist))
