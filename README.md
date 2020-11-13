# hat-trie-python

Python wrapper for https://github.com/Tessil/hat-trie (MIT License)

It's still incomplete, not all functionality is supported. Sets are not implemented yet.
Tested on Linux 2.7+, Windows 3.5+, MacOS 2.7+. It should work on Windows 2.7 also, however it's tricky to compile.

## Install

- `pip install hat-trie-python` (requires Cython and a C++11 compiler)

## Example usage:
```
from hattrie import HatTrieMap
htm = HatTrieMap()
htm[b"/foo"] = b"1"
htm[b"/foo/bar"] = b"2"
print(list(htm.longest_prefix(b"/foo"))) # returns [(b'/foo', b'1')]
print(list(htm.longest_prefix(b"/foo/baz"))) # returns [(b'/foo', b'1')]
print(list(htm.longest_prefix(b"/foo/bar/baz"))) # returns [(b'/foo/bar', b'2'), (b'/foo', b'1')]
print(list(htm.longest_prefix(b"/foo/bar/"))) # returns [(b'/foo/bar', b'2'), (b'/foo', b'1')]
print(list(htm.longest_prefix(b"/bar"))) # returns []
print(list(htm.longest_prefix(b""))) # returns []
```

Any Python object is supported as value, however only bytes are supported as keys.
