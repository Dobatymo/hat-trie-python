# distutils: language=c++

from cpython.ref cimport PyObject


cdef extern from "smartptr.h":
	cdef cppclass PyObjectSmartPtr:

		PyObjectSmartPtr(PyObject *) except +
		PyObject *get() const
		Py_ssize_t refcount() const
