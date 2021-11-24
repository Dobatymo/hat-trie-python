# distutils: language=c++

from cpython.ref cimport PyObject
from cython.operator cimport dereference as deref
from cython.operator cimport preincrement as inc
from htrie_map cimport htrie_map
from libcpp cimport bool as cbool
from libcpp.string cimport string
from smartptr cimport PyObjectSmartPtr

ctypedef PyObject *c_value_t
ctypedef object p_value_t

cdef class HatTrieMap:

	cdef htrie_map[char, PyObjectSmartPtr] hattrie

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

	def __getitem__(self, string key):
		try:
			return <p_value_t>self.hattrie.at(key).get()
		except IndexError:
			raise KeyError(key)

	def __setitem__(self, string key, object value):
		self.hattrie.insert(key, PyObjectSmartPtr(<c_value_t>value))

	def __delitem__(self, string key):
		cdef size_t num = self.hattrie.erase(key)
		if num == 0:
			raise KeyError(key)

	def __contains__(self, string key):
		try:
			self.hattrie.at(key)
			return True
		except IndexError:
			return False

	def keys(self):
		cdef htrie_map[char, PyObjectSmartPtr].const_iterator it = self.hattrie.const_begin()
		while it != self.hattrie.cend():
			yield it.key()
			inc(it)

	def values(self):
		cdef htrie_map[char, PyObjectSmartPtr].const_iterator it = self.hattrie.const_begin()
		while it != self.hattrie.cend():
			yield <p_value_t>it.value().get()
			inc(it)

	def items(self):
		cdef htrie_map[char, PyObjectSmartPtr].const_iterator it = self.hattrie.const_begin()
		while it != self.hattrie.cend():
			yield (it.key(), <p_value_t>it.value().get())
			inc(it)

	def __iter__(self):
		return self.keys()

	def pop(self, string key):
		raise NotImplementedError

	cpdef cbool insert(self, string key, object value):
		return self.hattrie.insert(key, PyObjectSmartPtr(<c_value_t>value)).second

	def update(self, map):
		for k, v in map.items():
			self.hattrie.insert(<string>k, PyObjectSmartPtr(<c_value_t>v))

	cpdef size_t count(self, string key):
		return self.hattrie.count(key)

	def longest_prefix(self, string key):
		cdef htrie_map[char, PyObjectSmartPtr].const_iterator it = self.hattrie.const_longest_prefix(key)
		while it != self.hattrie.cend():
			yield (it.key(), <p_value_t>it.value().get())
			inc(it)

	cpdef size_t erase_prefix(self, string prefix):
		return self.hattrie.erase_prefix(prefix)

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
