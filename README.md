# hat-trie-python
Python wrapper for https://github.com/Tessil/hat-trie

Still incomplete, only basic functionality is supported. Sets are not implemented yet. Only tested on Windows Python 3.6 x64, but lower versions and other operating systems *should* work also.

Install with `python setup.py install` (requires Cython and a C++ compiler)

Example usage:
```
from hattrie import HatTrieMap

htm = HatTrieMap()
htm[b"/foo"] = b"1"
htm[b"/foo/bar"] = b"2"
print(list(htm.longest_prefix(b"/foo"))) # returns [b'1']
print(list(htm.longest_prefix(b"/foo/baz"))) # returns [b'1']
print(list(htm.longest_prefix(b"/foo/bar/baz"))) # returns [b'2', b'1']
print(list(htm.longest_prefix(b"/foo/bar/"))) # returns [b'2', b'1']
print(list(htm.longest_prefix(b"/bar"))) # returns []
print(list(htm.longest_prefix(b""))) # returns []
```
