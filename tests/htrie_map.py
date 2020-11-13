from sys import getrefcount

from genutility.test import MyTestCase, parametrize

from hattrie import HatTrieMap

def get_key(i):
	return b"Key " + str(i).encode("ascii")

def get_value(i):
	return b"Value " + str(i).encode("ascii")

def get_filled_map(nb_elements, burst_threshold):
	map = HatTrieMap()
	map.burst_threshold = burst_threshold

	for i in range(nb_elements):
		map[get_key(i)] = get_value(i)

	return map

class HatTrieTests(MyTestCase):

	def _small_map(self):
		map = HatTrieMap()
		map[b"a"] = b"1"
		map[b"b"] = b"2"
		map[b"c"] = b"3"
		return map

	@parametrize(
		("abc", ),
		(b"abc", ),
		(1337, ),
		(13.37, ),
		([1, 2, 3], ),
		({1, 2, 3}, ),
	)
	def test_datatypes(self, value):
		map = HatTrieMap()
		key = b"key"
		map[key] = value
		self.assertEqual(map[key], value)

	def test_refcount(self):
		map = HatTrieMap()
		a = b"1ei4hb_s64"
		result_a = getrefcount(a)
		map[b"a"] = a
		del map[b"a"]
		result_b = getrefcount(a)
		self.assertNotIn(b"a", map)
		self.assertEqual(result_a, result_b)
		del map
		result_c = getrefcount(a)
		self.assertEqual(result_a, result_c)
		del a

	def test_keys(self):
		map = self._small_map()
		result = list(map.keys())
		truth = [b"a", b"b", b"c"]
		self.assertUnorderedSeqEqual(truth, result)

	def test_values(self):
		map = self._small_map()
		result = list(map.values())
		truth = [b"1", b"2", b"3"]
		self.assertUnorderedSeqEqual(truth, result)

	def test_items(self):
		map = self._small_map()
		result = dict(map.items())
		truth = {b"a": b"1", b"b": b"2", b"c": b"3"}
		self.assertEqual(truth, result)

	# from: trie_map_tests.cpp
	def test_longest_prefix(self):

		map = HatTrieMap()
		map.burst_threshold = 4
		map.update({
			b"a": 1,
			b"aa": 1,
			b"aaa": 1,
			b"aaaaa": 1,
			b"aaaaaa": 1,
			b"aaaaaaa": 1,
			b"ab": 1,
			b"abcde": 1,
			b"abcdf": 1,
			b"abcdg": 1,
			b"abcdh": 1,
			b"babc": 1,
		})

		self.assertEqual(next(map.longest_prefix(b"a")), (b"a", 1))
		self.assertEqual(next(map.longest_prefix(b"aa")), (b"aa", 1))
		self.assertEqual(next(map.longest_prefix(b"aaa")), (b"aaa", 1))
		self.assertEqual(next(map.longest_prefix(b"aaaa")), (b"aaa", 1))
		self.assertEqual(next(map.longest_prefix(b"ab")), (b"ab", 1))
		self.assertEqual(next(map.longest_prefix(b"abc")), (b"ab", 1))
		self.assertEqual(next(map.longest_prefix(b"abcd")), (b"ab", 1))
		self.assertEqual(next(map.longest_prefix(b"abcdz")), (b"ab", 1))
		self.assertEqual(next(map.longest_prefix(b"abcde")), (b"abcde", 1))
		self.assertEqual(next(map.longest_prefix(b"abcdef")), (b"abcde", 1))
		self.assertEqual(next(map.longest_prefix(b"abcdefg")), (b"abcde", 1))
		with self.assertRaises(StopIteration):
			next(map.longest_prefix(b"dabc"))
		with self.assertRaises(StopIteration):
			next(map.longest_prefix(b"b"))
		with self.assertRaises(StopIteration):
			next(map.longest_prefix(b"bab"))
		with self.assertRaises(StopIteration):
			next(map.longest_prefix(b"babd"))
		with self.assertRaises(StopIteration):
			next(map.longest_prefix(b""))

		map.insert(b"", 1)
		self.assertEqual(next(map.longest_prefix(b"dabc")), (b"", 1))
		self.assertEqual(next(map.longest_prefix(b"")), (b"", 1))

	# from: trie_map_tests.cpp
	def test_erase_prefix(self):
		map = get_filled_map(10000, 200)

		self.assertEqual(map.erase_prefix(b"Key 1"), 1111)
		self.assertEqual(map.size(), 8889)

		self.assertEqual(map.erase_prefix(b"Key 22"), 111)
		self.assertEqual(map.size(), 8778)

		self.assertEqual(map.erase_prefix(b"Key 333"), 11)
		self.assertEqual(map.size(), 8767)

		self.assertEqual(map.erase_prefix(b"Key 4444"), 1)
		self.assertEqual(map.size(), 8766)

		self.assertEqual(map.erase_prefix(b"Key 55555"), 0)
		self.assertEqual(map.size(), 8766)

		for key in map:
			self.assertEqual(key.find(b"Key 1"), -1)
			self.assertEqual(key.find(b"Key 22"), -1)
			self.assertEqual(key.find(b"Key 333"), -1)
			self.assertEqual(key.find(b"Key 4444"), -1)

		self.assertEqual(len(list(map)), map.size())

if __name__ == "__main__":
	import unittest
	unittest.main()
