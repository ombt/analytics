// complex class functions

// headers
#include "mycomplex.h"

// local definitions
#define plusi Complex<T>(0.0, 1.0)
#define minusi Complex<T>(0.0, -1.0)
#define plusone Complex<T>(1.0, 0.0)
#define minusone Complex<T>(-1.0, 0.0)

// constructors and destructor
template <class T>
Complex<T>::Complex():
	x(0), y(0)
{
	// do nothing
}

template <class T>
Complex<T>::Complex(T srcx):
	x(srcx), y(0)
{
	// do nothing
}

template <class T>
Complex<T>::Complex(T srcx, T srcy):
	x(srcx), y(srcy)
{
	// do nothing
}

template <class T>
Complex<T>::Complex(const Complex<T> &src): 
	x(src.x), y(src.y)
{
	// do nothing
}

template <class T>
Complex<T>::~Complex() 
{
	// do nothing
}

// arithmetic operators
template <class T>
Complex<T> &
Complex<T>::operator=(const Complex<T> &c)
{
	x = c.x;
	y = c.y;
	return(*this);
}

template <class T>
Complex<T>
Complex<T>::operator+(const Complex<T> &c) const
{
	return(Complex<T>(x+c.x, y+c.y));
}

// logical operators
template <class T>
int
Complex<T>::operator==(const Complex<T> &c) const
{
	return((x == c.x) && (y == c.y));
}

template <class T>
int
Complex<T>::operator!=(const Complex<T> &c) const
{
	return((x != c.x) || (y != c.y));
}

// mathematical functions
template <class T>
Complex<T>
log(const Complex<T> &c)
{
	MustBeTrue((c.x != 0.0) || (c.y != 0.0));
	return(Complex<T>(c.x, c.y));
}

