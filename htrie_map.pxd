# distutils: language=c++

from libcpp.string cimport string
from libcpp.utility cimport pair
from libcpp cimport bool

cdef extern from "htrie_map.h" namespace "tsl" nogil:
	cdef cppclass htrie_map[CharT, T]:

		cppclass iterator:
			T &operator*()
			iterator &operator++()
			bool operator==(const iterator& lhs, const iterator& rhs)
			bool operator!=(const iterator& lhs, const iterator& rhs)

		cppclass const_iterator:
			const T &operator*()
			const_iterator &operator++()
			bool operator==(const const_iterator& lhs, const const_iterator& rhs)
			bool operator!=(const const_iterator& lhs, const const_iterator& rhs)

		cppclass prefix_iterator:
			const T &operator*()
			prefix_iterator &operator++()
			bool operator==(const prefix_iterator& lhs, const prefix_iterator& rhs)
			bool operator!=(const prefix_iterator& lhs, const prefix_iterator& rhs)

		cppclass const_prefix_iterator:
			const T &operator*()
			const_prefix_iterator &operator++()
			bool operator==(const const_prefix_iterator& lhs, const const_prefix_iterator& rhs)
			bool operator!=(const const_prefix_iterator& lhs, const const_prefix_iterator& rhs)

		htrie_map()

		iterator begin()
		const_iterator const_begin "begin" () const
		const_iterator cbegin() const
		iterator end()
		const_iterator const_end "end" () const
		const_iterator cend() const

		bool empty() const
		size_t size() const
		size_t max_size() const
		size_t max_key_size() const
		void shrink_to_fit()
		void clear()

		pair[iterator, bool] insert_ks(const CharT* key, size_t key_size, const T &value)
		pair[iterator, bool] insert(const CharT* key, const T &value)
		pair[iterator, bool] insert(const string& key, const T &value)

		iterator erase(const_iterator pos)
		iterator erase(const_iterator first, const_iterator last)
		size_t erase_ks(const CharT* key, size_t key_size)
		size_t erase(const CharT* key)
		size_t erase(const string& key)
		size_t erase_prefix_ks(const CharT* prefix, size_t prefix_size)
		size_t erase_prefix(const CharT* prefix)
		size_t erase_prefix(const string& prefix)

		void swap(htrie_map &other)

		T& at_ks(const CharT* key, size_t key_size)
		const T& const_at_ks "at_ks" (const CharT* key, size_t key_size) const
		T& at(const CharT* key)
		const T& const_at "at" (const CharT* key) const
		T& at(const string& key)
		const T& const_at "at" (const string& key) const

		T &operator[](const CharT* key)
		T &operator[](const string& key) # string should be basic_string[CharT]

		size_t count_ks(const CharT* key, size_t key_size) const
		size_t count(const CharT* key) const
		size_t count(const string& key) const

		iterator find_ks(const CharT* key, size_t key_size)
		const_iterator const_find_ks "find_ks"(const CharT* key, size_t key_size) const
		iterator find(const CharT* key)
		const_iterator const_find "find" (const CharT* key) const
		iterator find(const string& key)
		const_iterator const_find "find" (const string& key) const

		pair[iterator, iterator] equal_range_ks(const CharT* key, size_t key_size)
		pair[const_iterator, const_iterator] const_equal_range_ks "equal_range_ks" (const CharT* key, size_t key_size) const
		pair[iterator, iterator] equal_range(const CharT* key)
		pair[const_iterator, const_iterator] const_equal_range "equal_range" (const CharT* key) const
		pair[iterator, iterator] equal_range(const string& key)
		pair[const_iterator, const_iterator] const_equal_range "equal_range" (const string& key) const

		pair[prefix_iterator, prefix_iterator] equal_prefix_range_ks(const CharT* prefix, size_t prefix_size)
		pair[const_prefix_iterator, const_prefix_iterator] const_equal_prefix_range_ks "equal_prefix_range_ks" (const CharT* prefix, size_t prefix_size) const
		pair[prefix_iterator, prefix_iterator] equal_prefix_range(const CharT* prefix)
		pair[const_prefix_iterator, const_prefix_iterator] const_equal_prefix_range "equal_prefix_range" (const CharT* prefix) const
		pair[prefix_iterator, prefix_iterator] equal_prefix_range(const string& prefix)
		pair[const_prefix_iterator, const_prefix_iterator] const_equal_prefix_range "equal_prefix_range" (const string& prefix) const

		iterator longest_prefix_ks(const CharT* key, size_t key_size)
		const_iterator const_longest_prefix_ks "longest_prefix_ks" (const CharT* key, size_t key_size) const
		iterator longest_prefix(const CharT* key)
		const_iterator const_longest_prefix "longest_prefix" (const CharT* key) const
		iterator longest_prefix(const string& key)
		const_iterator const_longest_prefix "longest_prefix" (const string& key) const

		float max_load_factor() const
		void max_load_factor(float ml)
		size_t burst_threshold() const
		void burst_threshold(size_t threshold)
