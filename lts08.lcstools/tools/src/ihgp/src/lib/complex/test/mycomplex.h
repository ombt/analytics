#ifndef __COMPLEX_H
#define __COMPLEX_H
// complex number class

// headers
#include <stdlib.h>
#include <iostream.h>
#include <math.h>
#include <errno.h>

// local headers
#include "returns.h"
#include "debug.h"

// forward declarations 
template <class T> class Complex;
template <class T> Complex<T> log(const Complex<T> &);

// complex class definition
template <class T> class Complex
{
public:
	// constructors and destructor
	Complex();
	Complex(T);
	Complex(T, T);
	Complex(const Complex<T> &);
	~Complex();

	// arithmetic operations
	Complex<T> &operator=(const Complex<T> &);
	Complex<T> operator+(const Complex<T> &) const;

	// logical operators 
	int operator==(const Complex<T> &) const;
	int operator!=(const Complex<T> &) const;

	// mathematical functions
	friend Complex<T> log<>(const Complex<T> &);

protected:
	// internal data
	T x, y;
};

#endif
