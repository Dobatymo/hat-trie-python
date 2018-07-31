# distutils: language=c++

from cython.operator cimport dereference as deref, preincrement as inc
from libcpp.string cimport string
from libcpp.utility cimport pair
from libcpp cimport bool as cbool

from htrie_map cimport htrie_map

cdef class HatTrieMap(object):

	cdef htrie_map[char, string] hattrie

	def __init__(self):
		pass

	cpdef cbool empty(self):
		return self.hattrie.empty()

	cpdef size_t size(self):
		return self.hattrie.size()

	cpdef size_t max_size(self):
		return self.hattrie.max_size()

	cpdef size_t max_key_size(self):
		return self.hattrie.max_key_size()

	cpdef void shrink_to_fit(self):
		self.hattrie.shrink_to_fit()

	cpdef void clear(self):
		self.hattrie.clear()

	cpdef insert(self, string key, string value):
		return self.hattrie.insert(key, value).second

	cpdef size_t erase(self, string key):
		return self.hattrie.erase(key)

	cpdef size_t erase_prefix(self, string prefix):
		return self.hattrie.erase_prefix(prefix)

	cpdef string at(self, string key):
		return self.hattrie.at(key)

	def __getitem__(self, key):
		try:
			return self.getitem(key)
		except IndexError:
			raise KeyError

	def __setitem__(self, key, value):
		self.setitem(key, value)

	cdef string getitem(self, string key) nogil except +:
		return self.hattrie[key]

	cdef void setitem(self, string key, string value) nogil:
		self.hattrie[key] = value

	cpdef size_t count(self, string key):
		return self.hattrie.count(key)

	cpdef string find(self, string key):
		return deref(self.hattrie.find(key))

	def longest_prefix(self, string key):
		cdef htrie_map[char, string].const_iterator it = self.hattrie.const_longest_prefix(key)
		while it != self.hattrie.cend():
			yield deref(it)
			inc(it)

	@property
	def max_load_factor(self):
		return self.hattrie.max_load_factor()

	@max_load_factor.setter
	def max_load_factor(self, float ml):
		self.hattrie.max_load_factor(ml)

	@property
	def burst_threshold(self):
		return self.hattrie.burst_threshold()

	@burst_threshold.setter
	def burst_threshold(self, size_t threshold):
		self.hattrie.burst_threshold(threshold)
