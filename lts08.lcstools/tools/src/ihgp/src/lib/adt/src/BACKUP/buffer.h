#ifndef __BUFFER_H
#define __BUFFER_H
// buffer class definition

// headers
#include <stdlib.h>
#include <iostream.h>

// local headers
#include "returns.h"
#include "debug.h"

// buffer class
template <class DataType> class Buffer {
public:
        // constructors and destructor
        Buffer(int sz):
		size(sz), ptr(new DataType [sz]) {
		mustBeTrue(size > 0);
		mustBeTrue(ptr != NULL);
	}
	Buffer(const Buffer &src):
		size(src.size), ptr(new DataType [src.size]) {
		mustBeTrue(size > 0);
		mustBeTrue(ptr != NULL);
	}
        ~Buffer() {
		delete [] ptr;
		ptr = NULL;
		size = 0;
	}

        // operators
        Buffer &operator=(const Buffer &rhs) {
		if (this != &rhs)
		{
			delete [] ptr;
			size = rhs.size;
			mustBeTrue(size > 0);
			ptr = new DataType [rhs.size];
			mustBeTrue(ptr != NULL);
			for (int idx=0; idx < size; idx++)
				ptr[idx] = rhs.ptr[idx];
		}
		return(*this);
	}
        DataType &operator[](int idx) {
		mustBeTrue(0 <= idx && idx < size);
		return(ptr[idx]);
	}
	DataType &operator*() {
		return(*ptr);
	}
	operator DataType *() {
		return(ptr);
	}
	DataType *operator&() {
		return(ptr);
	}

private:
	// not allowed
	Buffer();

protected:
        // internal data
	int size;
        DataType *ptr;
};

#endif
