#ifndef __POINTER_H
#define __POINTER_H
// pointer class definition

// headers
#include <stdlib.h>
#include <iostream.h>

// local headers
#include "returns.h"
#include "debug.h"

// forward declarations
template <class DataType> class Pointer;
template <class DataType> class Pointer_Data;

// reference-counted pointer class
template <class DataType> class Pointer_Data {
protected:
	// friends
	friend class Pointer<DataType>;

	// constructor and destructor
	Pointer_Data(DataType &src):
		data(&src), counts(1)
	{
		// do nothing
	}
	Pointer_Data(DataType *src):
		data(src), counts(1)
	{
		MustBeTrue(data != NULL);
	}
	virtual ~Pointer_Data()
	{
		delete data;
		data = NULL;
		counts = 0;
	}

private:
	// not allowed
	Pointer_Data();
	Pointer_Data(const Pointer_Data<DataType> &);
	Pointer_Data &operator=(const Pointer_Data<DataType> &);

protected:
	// internal data
	DataType *data;
	int counts;
};

// pointer class
template <class DataType> class Pointer {
public:
        // constructors and destructor
	Pointer(): 
		pdata(NULL)
	{
		// do nothing
	}
	Pointer(const Pointer<DataType> &src):
		pdata(src.pdata)
	{
		if (pdata != NULL)
			pdata->counts++;
	}
	Pointer(DataType *src): 
		pdata(NULL)
	{
		if (src != NULL)
		{
			pdata = new Pointer_Data<DataType>(src);
			MustBeTrue(pdata != NULL);
		}
	}
        ~Pointer() {
		if (pdata != NULL && --pdata->counts == 0)
			delete pdata;
		pdata = NULL;
	}

        // operators
        Pointer &operator=(const Pointer<DataType> &rhs) {
		if (this != &rhs)
		{
			if (rhs.pdata != NULL)
				rhs.pdata->counts++;
			if (pdata != NULL && --pdata->counts == 0)
				delete pdata;
			pdata = rhs.pdata;
		}
		return(*this);
	}
        Pointer &operator=(DataType *rhs) {
		if (pdata != NULL && pdata->data != rhs)
		{
			if (--pdata->counts == 0)
				delete pdata;
			pdata->data = rhs;
			pdata->counts = 1;
		}
		return(*this);
	}
	DataType &operator*() {
		MustBeTrue(pdata != NULL && pdata->data != NULL);
		return(*(pdata->data));
	}
	operator DataType *() {
		MustBeTrue(pdata != NULL);
		return(*(pdata->data));
		return(ptr);
	}
	DataType *operator&() {
		return(ptr);
	}
	DataType *operator->() {
		return(ptr);
	}

private:
	// not provided
	Pointer(const Pointer &);
        Pointer &operator=(const Pointer &);

protected:
        // internal data
        Pointer_Data<DataType> *pdata;
};

#endif
