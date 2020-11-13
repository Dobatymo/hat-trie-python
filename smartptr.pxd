# distutils: language=c++

from cpython.ref cimport PyObject

cdef extern from "smartptr.h":
	cdef cppclass PyObjectSmartPtr:

		PyObject *ptr

		PyObjectSmartPtr(PyObject *) except +
		PyObject *get() const
		ssize_t refcount() const
