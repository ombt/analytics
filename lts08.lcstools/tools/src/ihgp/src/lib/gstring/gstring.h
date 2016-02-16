#ifndef __GSTRING_H
#define __GSTRING_H
// generic string class definitions

// headers
#include <stdio.h>
#include <stdlib.h>
#include <iostream.h>

// local headers
#include "returns.h"
#include "debug.h"

// forward declarations
template <class DataType> class GString;

// forward declaration of friend functions
template <class DataType>
ostream &
operator<<(ostream &, const GString<DataType> &);

template <class DataType>
istream &
operator>>(istream &, GString<DataType> &);

// generic string class definition
template <class DataType> class GString {
public:
	// constructors and destructor
	GString();
	GString(DataType);
	GString(int, const DataType * = NULL);
	GString(const GString<DataType> &);
	~GString();

	// assignment
	GString<DataType> &operator=(const GString<DataType> &);

	// access operator
	DataType &operator[](int);
	const DataType &operator[](int) const;

	// logical operators
	int operator==(const GString<DataType> &) const;
	int operator!=(const GString<DataType> &) const;
	int operator<(const GString<DataType> &) const;
	int operator<=(const GString<DataType> &) const;
	int operator>(const GString<DataType> &) const;
	int operator>=(const GString<DataType> &) const;

	// substring operator
	GString<DataType> operator()(int) const;
	GString<DataType> operator()(int, int) const;

	// concatenation operators
	GString<DataType> &operator+=(const GString<DataType> &);
	GString<DataType> operator+(const GString<DataType> &) const;

	// string length
	int gstrlen() const;
	inline int maxgstrlen() const {
		return(maxsize);
	}

	// casting operation
	operator const DataType *() const;
	operator DataType *();

	// input and output
	friend ostream &operator<< <>(ostream &, const GString<DataType> &);
	friend istream &operator>> <>(istream &, GString<DataType> &);

private:
	// utility functions
	int wordcmp(const GString<DataType> &) const;
	void wordncpy(DataType *, const DataType *, int) const;

protected:
	int size;
	int maxsize;
	DataType *buffer;
};

#endif
