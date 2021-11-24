#include <stdexcept>
#define PY_SSIZE_T_CLEAN
#include "Python.h"

class PyObjectSmartPtr {
protected:
    PyObject *ptr;

public:
    PyObjectSmartPtr(): ptr(nullptr) {
    }

    PyObjectSmartPtr(const PyObjectSmartPtr &other) : ptr(other.ptr) {
        Py_XINCREF(ptr);
    }

    PyObjectSmartPtr &operator=(const PyObjectSmartPtr &other) {
        if (this != &other)
        {
            Py_XDECREF(ptr);
            ptr = other.ptr;
            Py_XINCREF(ptr);
        }

        return *this;
    }

    ~PyObjectSmartPtr() {
        Py_XDECREF(ptr);
    }

    PyObjectSmartPtr(PyObject *ptr): ptr(ptr) {
        if (ptr == nullptr) {
            throw std::invalid_argument("nullptr");
        }
        Py_INCREF(ptr);
    }

    PyObject& operator*() {
        if (ptr == nullptr) {
            throw std::invalid_argument("nullptr");
        }
        return *ptr;
    }

    PyObject* operator->() {
        return ptr;
    }

    PyObject *get() const {
        return ptr;
    }

    Py_ssize_t refcount() const {
        if (ptr == nullptr) {
            throw std::invalid_argument("nullptr");
        }
        return Py_REFCNT(ptr);
    }
};
