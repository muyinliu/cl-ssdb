;;; CL-SSDB commands

(in-package #:ssdb)


;;; Server commands

(def-cmd ping () :status
  "Ping server.
Note: It's NOT a public command, but it works.")

(def-cmd auth (pass) :status
  "Available since: 1.7.0.0

Authenticate the connection.

Warning: The password is sent in plain-text over the network!

Parameters
password - the password

Return Value
Status reply.")

(def-cmd dbsize () :integer
  "Return the approximate size of the database, in bytes. If compression is enabled, the size will be of the compressed data.

Return Value
Size in bytes.")

(def-cmd info (&optional opt) :bulk
  "Return information about the server.

Parameters
opt - Optional, could be cmd, leveldb

Return Value
Key-Value list.

The key-value list is return as: k1 v1 k2 v2 ...")

;;; IP Filter commands

(def-cmd list_allow_ip () :list
  "Available since: 1.9.3

List all allow ip rules.

Parameters
None.

Return Value
List reply.")

(def-cmd add_allow_ip (ip_rule) :status
  "Available since: 1.9.3

Add one allow ip rule.

Warning: After you have modify any allow/deny rule, you must modify both the configuration file! Or the rules will be reload from configuration file after you restart ssdb-server.

Parameters
rule - IP address filter rule, specify only the prefix, 127.0.1, 127.0, etc.

Return Value
Status reply.")

(def-cmd del_allow_ip (ip_rule) :status
  "Available since: 1.9.3

Delete one allow ip rule.

Warning: After you have modify any allow/deny rule, you must modify both the configuration file! Or the rules will be reload from configuration file after you restart ssdb-server.

Parameters
rule - IP address filter rule, specify only the prefix, 127.0.1, 127.0, etc.

Return Value
Status reply.")

(def-cmd list_deny_ip () :list
  "Available since: 1.9.3

List all deny ip rules.

Parameters
None.

Return Value
List reply.")

(def-cmd add_deny_ip (ip_rule) :status
  "Available since: 1.9.3

Add one deny ip rule.

Warning: After you have modify any allow/deny rule, you must modify both the configuration file! Or the rules will be reload from configuration file after you restart ssdb-server.

Parameters
rule - IP address filter rule, specify only the prefix, 127.0.1, 127.0, etc.

Return Value
Status reply.")

(def-cmd del_deny_ip (ip_rule) :status
  "Available since: 1.9.3

Delete one deny ip rule.

Warning: After you have modify any allow/deny rule, you must modify both the configuration file! Or the rules will be reload from configuration file after you restart ssdb-server.

Parameters
rule - IP address filter rule, specify only the prefix, 127.0.1, 127.0, etc.

Return Value
Status reply.")

;;; Key Value commands

(def-cmd set (key value) :status
  "Set the value of the key.

Parameters
key -
value -

Return Value
false on error, other values indicate OK.")

(def-cmd setx (key value ttl) :status
  "Set the value of the key, with a time to live.

Unlike Redis, the ttl will not be remove when later set the same key!

Parameters
key -
value -
ttl - number of seconds to live.

Return Value
false on error, other values indicate OK.")

(def-cmd setnx (key value) :boolean
  "Set the string value in argument as value of the key if and only if the key doesn't exist.

Parameters
key -
value -

Return Value
1: value is set, 0: key already exists.")

(def-cmd expire (key ttl) :boolean
  "Set the time left to live in seconds, only for keys of KV type.

Parameters
key -
ttl - number of seconds to live.

Return Value
If the key exists and ttl is set, return 1, otherwise return 0.")

(def-cmd ttl (key) :integer
  "Returns the time left to live in seconds, only for keys of KV type.

Parameters
key -

Return Value
Time to live of the key, in seconds, -1 if there is no associated expire to the key.")

(def-cmd get (key) :bulk
  "Get the value related to the specified key.

Parameters
key -

Return Value
Value reply.

Return the value to the key, if the key does not exists, return not_found Status Code.")

(def-cmd getset (key value) :bulk
  "Sets a value and returns the previous entry at that key.
Parameters

key - 
value -

Return Value
If the key already exists, the value related to that key is returned. Otherwise return not_found Status Code. The value is either added or updated.")

(def-cmd del (key) :status
  "Delete specified key.
Parameters

key - 

Return Value
Status reply. You can not determine whether the key exists or not by delete command.")

(def-cmd incr (key &optional num) :integer
  "Since 1.7.0.1, *incr methods return error if value cannot be converted to integer.
Increment the number stored at key by num. The num argument could be a negative integer. The old number is first converted to an integer before increment, assuming it was stored as literal integer.
Parameters

key - 
num - Optional, must be a signed integer, default is 1

Return Value
The new value. If the old value cannot be converted to an integer, returns error Status Code.")

(def-cmd exists (key) :boolean
  "Verify if the specified key exists.
Parameters

key - 

Return Value
If the key exists, return 1, otherwise return 0.")

(def-cmd getbit (key offset) :integer
  "Return a single bit out of a string.
Parameters

key - 
offset - bit offset.

Return Value
0 or 1.")

(def-cmd setbit (key offset val) :integer
  "Changes a single bit of a string. The string is auto expanded.
Parameters

key - 
offset - bit offset, must in range of [0, 1073741824].
val - 0 or 1.

Return Value
The value of the bit before it was set: 0 or 1. If val is not 0 or 1, returns false.")

(def-cmd bitcount (key &optional start end) :integer
  "Count the number of set bits \(population counting) in a string. Like Redis's bitcount.
Parameters

key - 
start - Optional, inclusive, if start is negative, count from start'th character from the end of string.
end - Optional, inclusive.

Return Value
The number of bits set to 1.")

(def-cmd countbit (key &optional start size) :integer
  "Count the number of set bits \(population counting) in a string. Unlike bitcount, it take part of the string by start and size, not start and end.
Parameters

key - 
start - Optional, inclusive, if start is negative, count from start'th character from the end of string.
size - Optional, if size is negative, then that many characters will be omitted from the end of string.

Return Value
The number of bits set to 1.")

(def-cmd substr (key start size) :bulk
  "Return part of a string, like PHP's substr() function.
Parameters

key - 
start - Optional, the offset of first byte returned. If start is negative, the returned string will start at the start'th character from the end of string.
size - Optional, number of bytes returned. If size is negative, then that many characters will be omitted from the end of string.

Return Value
The extracted part of the string.")

(def-cmd strlen (key) :integer
  "Return the number of bytes of a string.
Parameters

key - 

Return Value
The number of bytes of the string, if key not exists, returns 0.")


(def-cmd keys (key_start key_end limit) :list
  "Refer to scan command for more information about how it work.

Parameters

Return Value
Return list of keys.")

(def-cmd rkeys (key_start key_end limit) :list
  "Since 1.9.0
Like keys, but in reverse order.")

(def-cmd scan (key_start key_end limit) :list
  "List key-value pairs with keys in range \(key_start, key_end].
\(\"\", \"\"] means no range limit.
This command can do wildchar * like search, but only prefix search, and the * char must never occur in key_start and key_end!
Parameters

key_start - The lower bound\(not included) of keys to be returned, empty string means -inf(no limit).
key_end - The upper bound\(inclusive) of keys to be returned, empty string means +inf\(no limit).
limit - Up to that many pairs will be returned.

Return Value
false on error, otherwise an associative array containing the key-value pairs.")

(def-cmd rscan (key_start key_end limit) :list
  "Like scan, but in reverse order.")

(def-cmd multi_set (&rest key-value-plist) :integer
  "Set multiple key-value pairs\(kvs) in one method call.
Parameters

key1 -
value1 -
...

Return Value
false on error, other values indicate OK.")

(def-cmd multi_get (&rest keys) :list
  "Get the values related to the specified multiple keys
Parameters

key1 -
...

Return Value
Key-value list.
The keys not found will not be included in the reply, the key-value list is return as: k1 v1 k2 v2 ...")

(def-cmd multi_del (&rest keys) :integer
  "Delete specified multiple keys.
Parameters

key1 -
...

Return Value
false on error, other values indicate OK.")

;;; Hashmap commands

(def-cmd hset (name key value) :boolean
  "Set the string value in argument as value of the key of a hashmap.
Parameters

name - The name of the hashmap
key - The key of the key-value pair in the hashmap
value - The value of the key-value pair in the hashmap

Return Value
Returns 1 if key is a new key in the hashmap and value is set, else returns 0.")

(def-cmd hget (name key) :bulk
  "Get the value related to the specified key of a hashmap
Parameters

name - The name of the hashmap
key - The key of the key-value pair in the hashmap

Return Value
Value reply.
Return the value to the key, if the key does not exists, return not_found Status Code.")

(def-cmd hdel (name key) :boolean
  "Delete specified key of a hashmap. To delete the whole hashmap, use hclear.
Parameters

name - The name of the hashmap
key - The key of the key-value pair in the hashmap

Return Value
If the key exists, return 1, otherwise return 0.")

(def-cmd hincr (name key &optional num) :integer
  "Since 1.7.0.1, *incr methods return error if value cannot be converted to integer.
Increment the number stored at key in a hashmap by num. The num argument could be a negative integer. The old number is first converted to an integer before increment, assuming it was stored as literal integer.
Parameters

name - the name of the hashmap
`key - 
num - Optional, must be a signed integer, default is 1

Return Value
The new value. If the old value cannot be converted to an integer, returns error Status Code.")

(def-cmd hexists (name key) :boolean
  "Verify if the specified key exists in a hashmap.
Parameters

name - The name of the hashmap
key - 

Return Value
If the key exists, return 1, otherwise return 0.")

(def-cmd hsize (name) :integer
  "Return the number of key-value pairs in the hashmap.
Parameters

name - The name of the hashmap

Return Value
Integer reply.")

(def-cmd hlist (name_start name_end limit) :list
  "List hashmap names in range \(name_start, name_end].
\(\"\", \"\"] means no range limit.
Refer to scan command for more information about how it work.
Parameters

name_start - The lower bound\(not included) of names to be returned, empty string means -inf\(no limit).
name_end - The upper bound\(inclusive) of names to be returned, empty string means +inf\(no limit).
limit - Up to that many elements will be returned.

Return Value
Key-Value list.
The key-value list is return as: k1 v1 k2 v2 ...")

(def-cmd hrlist (name_start name_end limit) :list
  "Like hlist, but in reverse order.")

(def-cmd hkeys (name key_start key_end limit) :list
  "List keys of a hashmap in range \(key_start, key_end].
\(\"\", \"\"] means no range limit.
Parameters

name - The name of the hashmap
key_start - The lower bound\(not included) of keys to be returned, empty string means -inf\(no limit).
key_end - The upper bound\(inclusive) of keys to be returned, empty string means +inf\(no limit).
limit - Up to that many elements will be returned.

Return Value
Key list.
The key list is return as: k1 k2 ...")

(def-cmd hgetall (name) :list
  "Returns the whole hash, as an array of strings indexed by strings.
Parameters

name - The name of the hashmap

Return Value
Key-Value list.
The key-value list is return as: k1 v1 k2 v2 ...")

(def-cmd hscan (name key_start key_end limit) :list
  "List key-value pairs of a hashmap with keys in range \(key_start, key_end].
(\"\", \"\"] means no range limit.
Refer to scan command for more information about how it work.
Parameters

name - The name of the hashmap
key_start - The lower bound\(not included) of keys to be returned, empty string means -inf\(no limit).
key_end - The upper bound\(inclusive) of keys to be returned, empty string means +inf\(no limit).
limit - Up to that many pairs will be returned.

Return Value
Key-Value list.
The key-value list is return as: k1 v1 k2 v2 ...")

(def-cmd hrscan (name key_start key_end limit) :list
  "Like hscan, but in reverse order.")

(def-cmd hclear (name) :integer
  "Delete all keys in a hashmap.
Parameters

name - The name of the hashmap.

Return Value
The number of key deleted in that hashmap.")

(def-cmd multi_hset (name &rest key-value-plist) :status
  "Set multiple key-value pairs\(kvs) of a hashmap in one method call.
Parameters

name - 
key1 -
value1 -
...

Return Value
false on error, other values indicate OK.")

(def-cmd multi_hget (name &rest keys) :list
  "Get the values related to the specified multiple keys of a hashmap.
Parameters

name -
key1 -
...

Return Value
Key-value list.
The keys not found will not be included in the reply, the key-value list is return as: k1 v1 k2 v2 ...")

(def-cmd multi_hdel (name &rest keys) :boolean
  "Delete specified multiple keys in a hashmap.
Parameters

name -
key1 -
...

Return Value
false on error, other values indicate OK.")

;;; Sorted Set

(def-cmd zset (name key score) :boolean
  "Set the score of the key of a zset.
Parameters

name - Name of the zset
key - 
score - 

Return Value")

(def-cmd zget (name key) :integer
  "Get the score related to the specified key of a zset
Parameters

name - Name of the zset
key - 

Return Value")

(def-cmd zdel (name key) :status
  "Delete specified key of a zset.
Parameters

name - Name of the zset
key - 

Return Value")

(def-cmd zincr (name key num) :integer
  "Increment the number stored at key in a zset by num.
Parameters

name - Name of the zset
key - 
num - Must be a signed integer.

Return Value")

(def-cmd zexists (name key) :boolean
  "Verify if the specified key exists in a zset.
Parameters

name - Name of the zset
key - 

Return Value")

(def-cmd zsize (name) :integer
  "Return the number of pairs of a zset.
Parameters

name - The name of the zset

Return Value")

(def-cmd zlist (name_start name_end limit) :list
  "List zset names in range (name_start, name_end].
Refer to scan command for more information about how it work.
Parameters

name - Name of the zset
name_start - 
name_end - 
limit - 

Return Value")

(def-cmd zrlist (name_start name_end limit) :list
  "List zset names in range \(name_start, name_end], in reverse order.
Parameters

name - Name of the zset
name_start - 
name_end - 
limit - 

Return Value")

(def-cmd zkeys (name key_start score_start score_end limit) :list
  "List keys in a zset.
Parameters

name - Name of the zset
key_start -
score_start -
score_end -
limit -

Return Value")

(def-cmd zscan (name key_start score_start score_end limit) :list
  "List key-score pairs where key-score in range \(key_start+score_start, score_end].
Refer to scan command for more information about how it work.
Parameters

name - Name of the zset

Return Value
key-score list")

(def-cmd zrscan (name key_start score_start score_end limit) :list
  "List key-score pairs of a zset, in reverse order. See method zkeys\().
Parameters

name - Name of the zset

Return Value")

(def-cmd zrank (name key) :integer
  "Returns the rank\(index) of a given key in the specified sorted set.
Parameters

name - Name of the zset
key -

Return Value")

(def-cmd zrrank (name key) :integer
  "Returns the rank\(index) of a given key in the specified sorted set, in reverse order.
Parameters

name - Name of the zset

Return Value")

(def-cmd zrange (name offset limit) :list
  "Returns a range of key-score pairs by index range [offset, offset + limit).
Parameters

name - Name of the zset
offset - Positive integer, the returned pairs will start at this offset.
limit - Positive integer, up to this number of pairs will be returned. 

Return Value
key-score list")

(def-cmd zrrange (name offset limit) :list
  "Returns a range of key-score pairs by index range [offset, offset + limit), in reverse order.
Parameters

name - Name of the zset

Return Value")

(def-cmd zclear (name) :integer
  "Delete all keys in a zset.
Parameters

name - Name of the zset

Return Value")

(def-cmd zcount (name score_start score_end) :integer
  "Returns the number of elements of the sorted set stored at the specified key which have scores in the range [start,end].
Parameters

name - The name of the zset.
score_start - The minimum score related to keys\(inclusive), empty string means -inf\(no limit).
score_end - The maximum score related to keys\(inclusive), empty string means +inf\(no limit). 

Return Value")

(def-cmd zsum (name score_start score_end) :integer
  "Returns the sum of elements of the sorted set stored at the specified key which have scores in the range [start,end].
Parameters

name - The name of the zset.
score_start - The minimum score related to keys\(inclusive), empty string means -inf\(no limit).
score_end - The maximum score related to keys\(inclusive), empty string means +inf\(no limit). 

Return Value")

(def-cmd zavg (name score_start score_end) :integer
  "Returns the average of elements of the sorted set stored at the specified key which have scores in the range [start,end].
Parameters

name - The name of the zset.
score_start - The minimum score related to keys\(inclusive), empty string means -inf\(no limit).
score_end - The maximum score related to keys\(inclusive), empty string means +inf\(no limit). 

Return Value")

(def-cmd zremrangebyrank (name start end) :integer
  "Delete the elements of the zset which have rank in the range [start,end].
Parameters

name - Name of the zset

Return Value
count of deleted keys")

(def-cmd zremrangebyscore (name start end) :integer
  "Delete the elements of the zset which have score in the range [start,end].
Parameters

name - Name of the zset

Return Value")

(def-cmd zpop_front (name limit) :list
  "Since 1.9.0
Delete and return limit element\(s) from front of the zset.
Parameters

name - The name of the zset
limit -

Return Value")

(def-cmd zpop_back (name limit) :list
  "Since 1.9.0
Delete and return limit element\(s) from back of the zset.
Parameters

name - The name of the zset
limit - 

Return Value")

(def-cmd multi_zset (name &rest key-score-plist) :integer
  "Set multiple key-score pairs\(kvs) of a zset in one method call.
Parameters

name -
key1 -
score1 -
...

Return Value
false on error, other values indicate OK.")

(def-cmd multi_zget (name &rest keys) :list
  "Get the values related to the specified multiple keys of a zset.
Parameters

name -
key1 -
...

Return Value
Key-value list.
The keys not found will not be included in the reply, the key-value list is return as: k1 v1 k2 v2 ...")

(def-cmd multi_zdel (name &rest keys) :integer
  "Delete specified multiple keys of a zset.
Parameters

name -
key1 -
...

Return Value
false on error, other values indicate OK.")

;;; List commands

(def-cmd qpush_front (name &rest items) :integer
  "Add one or more than one element to the head of the queue.
Parameters

name - 
item1 -
...

Return Value
The length of the list after the push operation, false on error.")

(def-cmd qpush_back (name &rest items) :integer
  "Add an or more than one element to the end of the queue.
Parameters

name - 
item1 -
...

Return Value
The length of the list after the push operation, false on error.")

(def-cmd qpop_front (name &optional size) :list
  "Pop out one or more elements from the head of a queue.
Parameters

name - 
size - Optional, number of elements to pop, default is 1

Return Value
false on error. When size is not specified or less than 2, returns null if queue empty, otherwise the item removed. When size is specified and greater than or equal to 2, returns an array of elements removed.")

(def-cmd qpop_back (name &optional size) :list
  "Pop out one or more elements from the tail of a queue.
Parameters

name - 
size - Optional, number of elements to pop, default is 1

Return Value
false on error. When size is not specified or less than 2, returns null if queue empty, otherwise the item removed. When size is specified and greater than or equal to 2, returns an array of elements removed.")

(def-cmd qpush (name &rest items) :integer
  "Alias of qpush_back")

(def-cmd qpop (name size) :list
  "Alias of qpop_front")

(def-cmd qfront (name) :bulk
  "Returns the first element of a queue.
Parameters

name - 

Return Value
false on error, null if queue empty, otherwise the item returned.")

(def-cmd qback (name) :bulk
  "Returns the last element of a queue.
Parameters

name - 

Return Value
false on error, null if queue empty, otherwise the item returned.")

(def-cmd qsize (name) :integer
  "Returns the number of items in the queue.
Parameters

name - 

Return Value
false on error, otherwise an integer, 0 if the queue does not exist.")

(def-cmd qclear (name) :integer
  "Clear the queue.
Parameters

name - 

Return Value
false on error.")

(def-cmd qget (name index) :bulk
  "Returns the element a the specified index\(position). 0 the first element, 1 the second ... -1 the last element.
Parameters

name - 
index - negative intexes accepted.

Return Value
false on error, null if no element corresponds to this index, otherwise the item returned.")

(def-cmd qset (name index val) :status
  "Sets the list element at index to value. An error is returned for out of range indexes.
Parameters

name - 
index - negative intexes accepted.
val - 

Return Value
false on error, other values indicate OK.")

(def-cmd qrange (name offset limit) :list
  "Returns a portion of elements from the queue at the specified range [offset, offset + limit].
Parameters

name - 
offset - 
limit - 

Return Value
false on error, otherwise an array containing items.")

(def-cmd qslice (name begin end) :list
  "Returns a portion of elements from the queue at the specified range [begin, end]. begin and end could be negative.
Parameters

name - 
begin - 
end - 

Return Value
false on error, otherwise an array containing items.")

(def-cmd qtrim_front (name size) :integer
  "Remove multi elements from the head of a queue.
Parameters

name - 
size - Number of elements to delete.

Return Value
false on error. Return the number of elements removed.")

(def-cmd qtrim_back (name size) :integer
  "Remove multi elements from the tail of a queue.
Parameters

name - 
size - Number of elements to delete.

Return Value
false on error. Return the number of elements removed.")

(def-cmd qlist (name_start name_end limit) :list
  "List list/queue names in range \(name_start, name_end].
\(\"\", \"\"] means no range limit.
Refer to scan command for more information about how it work.

Parameters
name_start - The lower bound\(not included) of names to be returned, empty string means -inf\(no limit).
name_end - The upper bound\(inclusive) of names to be returned, empty string means +inf\(no limit).
limit - Up to that many elements will be returned.

Return Value
false on error, otherwise an array containing the names.")

(def-cmd qrlist (name_start name_end limit) :list
  "Like qlist, but in reverse order.")


;;; not supported commands: flushdb - use ssdb-cli for that

;;; end
