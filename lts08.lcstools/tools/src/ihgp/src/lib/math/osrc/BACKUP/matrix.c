// matrix class functions

// headers
#include <stdlib.h>
#include <math.h>

// local headers
#include "matrix.h"

// local definitions
#define local_abs(x) (((x) < 0) ? (-(x)) : (x))

// define epsilon for comparisons
template <class T>
T Matrix<T>::epsilon = -1.0;

// constructors and destructor
template <class T>
Matrix<T>::Matrix(unsigned int rows, unsigned int cols):
	matrix(NULL), nrows(rows), ncols(cols)
{
	// check dimensions
	MustBeTrue(nrows > 0 && ncols > 0);

	// allocate a matrix
	matrix = new T [nrows*ncols];
	MustBeTrue(matrix != NULL);
	for (unsigned ia = 0; ia < nrows*ncols; ia++)
	{
		matrix[ia] = 0;
	}

	// check for epsilon
	if (epsilon < 0.0)
		epsilon = calcEpsilon((T)(0.0));
}

template <class T>
Matrix<T>::Matrix(const Matrix<T> &m):
	matrix(NULL), nrows(m.nrows), ncols(m.ncols)
{
	// store dimensions
	MustBeTrue(nrows > 0 && ncols > 0);

	// allocate a matrix
	matrix = new T [nrows*ncols];
	MustBeTrue(matrix != NULL);
	for (unsigned int ia = 0; ia < nrows*ncols; ia++)
	{
		matrix[ia] = m.matrix[ia];
	}
}

template <class T>
Matrix<T>::~Matrix()
{
	delete [] matrix;
	matrix = NULL;
}

// assignment operations
template <class T>
Matrix<T> &
Matrix<T>::operator=(const Matrix<T> &m)
{
	// check if assigning to itself
	if (this != &m)
	{
		// delete matrix
		delete [] matrix;
		matrix = NULL;

		// store new matrix dimension
		nrows = m.nrows;
		ncols = m.ncols;
		MustBeTrue(nrows > 0 && ncols > 0);

		// allocate a matrix
		matrix = new T [nrows*ncols];
		MustBeTrue(matrix != NULL);
		for (int ia = 0; ia < nrows*ncols; ia++)
		{
			matrix[ia] = m.matrix[ia];
		}
	}
	return(*this);
}

template <class T>
T &
Matrix<T>::operator()(unsigned int row, unsigned int col)
{
	MustBeTrue(row < nrows && col < ncols);
	return(matrix[row*ncols+col]);
}

template <class T>
T &
Matrix<T>::operator()(unsigned int row, unsigned int col) const
{
	MustBeTrue(row < nrows && col < ncols);
	return(matrix[row*ncols+col]);
}

// matrix operations
template <class T>
Matrix<T> &
Matrix<T>::operator+=(const Matrix<T> &m)
{
	// check that rows and columns match
	MustBeTrue(nrows == m.nrows && ncols == m.ncols);

	// add element by element
	for (unsigned int ia = 0; ia < nrows*ncols; ia++)
	{
		matrix[ia] += m.matrix[ia];
	}

	// all done
	return(*this);
}

template <class T>
Matrix<T> &
Matrix<T>::operator-=(const Matrix<T> &m)
{
	// check that rows and columns match
	MustBeTrue(nrows == m.nrows && ncols == m.ncols);

	// subtract element by element
	for (unsigned int ia = 0; ia < nrows*ncols; ia++)
	{
		matrix[ia] -= m.matrix[ia];
	}

	// all done
	return(*this);
}

template <class T>
Matrix<T> &
Matrix<T>::operator*=(const Matrix<T> &m)
{
	// check that rows and columns match
	MustBeTrue(ncols == m.nrows && ncols > 0);

	// get size of new matrix
	unsigned int newnrows = nrows;
	unsigned int newncols = m.ncols;
	MustBeTrue(newnrows > 0 && newncols > 0);
	unsigned int nsum = ncols;

	// allocate a new matrix
	T *newmatrix = new T [newnrows*newncols];
	MustBeTrue(newmatrix != NULL);

	// multiply element by element
	for (unsigned int ir = 0; ir < newnrows; ir++)
	{
		for (unsigned int ic = 0; ic < newncols; ic++)
		{
			newmatrix[ir*newncols+ic] = 0;
			for (unsigned int is = 0; is < nsum; is++)
			{
				newmatrix[ir*newncols+ic] += 
				matrix[ir*ncols+is]*m.matrix[is*m.ncols+ic];
			}
		}
	}

	// delete old matrix and save new one
	delete [] matrix;
	matrix = newmatrix;
	nrows = newnrows;
	ncols = newncols;

	// all done
	return(*this);
}

template <class T>
Matrix<T>
Matrix<T>::operator+(const Matrix<T> &m) const
{
	return(Matrix<T>(*this) += m);
}

template <class T>
Matrix<T>
Matrix<T>::operator-(const Matrix<T> &m) const
{
	return(Matrix<T>(*this) -= m);
}

template <class T>
Matrix<T>
Matrix<T>::operator*(const Matrix<T> &m) const
{
	return(Matrix<T>(*this) *= m);
}

// matrix and vector operations
template <class T>
Vector<T>
Matrix<T>::operator*(const Vector<T> &v) const
{
	// check that rows and columns match
	MustBeTrue(ncols == v.getDimension() && ncols > 0);

	// new vector to hold results
	Vector<T> newv(nrows);

	// multiply element by element
	for (unsigned int ir = 0; ir < nrows; ir++)
	{
		for (unsigned int is = 0; is < ncols; is++)
		{
			newv[ir] += matrix[ir*ncols+is]*v[is];
		}
	}

	// all done
	return(newv);
}

template <class T>
Vector<T>
operator*(const Vector<T> &v, const Matrix<T> &m)
{
	// check that rows and columns match
	MustBeTrue(v.getDimension() == m.nrows && m.nrows > 0);

	// new vector to hold results
	Vector<T> newv(m.ncols);

	// multiply element by element
	for (unsigned int ic = 0; ic < m.ncols; ic++)
	{
		for (unsigned int is = 0; is < m.nrows; is++)
		{
			newv[ic] += v[is]*m.matrix[is*ncols+ic];
		}
	}

	// all done
	return(newv);
}

// matrix and scalar operations
template <class T>
Matrix<T> &
Matrix<T>::operator*=(const T &n)
{
	// check dimensions
	MustBeTrue(nrows > 0 && ncols > 0);

	// multiply matrix by scalar
	for (unsigned int ia = 0; ia < nrows*ncols; ia++)
	{
		matrix[ia] *= n;
	}

	// all done
	return(*this);
}

template <class T>
Matrix<T> &
Matrix<T>::operator/=(const T &n)
{
	// check dimensions
	MustBeTrue(nrows > 0 && ncols > 0);
	MustBeTrue(n != 0.0);

	// divide matrix by scalar
	for (unsigned int ia = 0; ia < nrows*ncols; ia++)
	{
		matrix[ia] /= n;
	}

	// all done 
	return(*this);
}


template <class T>
Matrix<T>
Matrix<T>::operator*(const T &n) const
{
	return(Matrix<T>(*this) *= n);
}

template <class T>
Matrix<T>
Matrix<T>::operator/(const T &n) const
{
	return(Matrix<T>(*this) /= n);
}

template <class T>
Matrix<T>
operator*(const T &n, const Matrix<T> &m)
{
	// switch around and multiply
	return(m*n);
}

// logical operators
template <class T>
int
Matrix<T>::operator==(const Matrix<T> &m) const
{
	// check if the same matrix
	if (this == &m) return(1);

	// check if dimensions are the same
	if (nrows != m.nrows || ncols != m.ncols) return(0);

	// compare element by element
	for (unsigned int ia = 0; ia < nrows*ncols; ia++)
	{
		T delta = matrix[ia] - m.matrix[ia];
		if (delta < 0.0)
			delta = -1.0*delta;
		if (delta > epsilon)
		{      
			// a mismatch
			return(0);
		}
	}

	// matrices are the same
	return(1);
}

template <class T>
int
Matrix<T>::operator!=(const Matrix<T> &m) const
{
	return( ! (*this == m));
}

// print matrix
template <class T>
void
Matrix<T>::dump(ostream &os) const
{
	os << "matrix[" << nrows << "," << ncols << "] = {" << endl;
	for (unsigned int ir = 0; ir < nrows; ir++)
	{
		for (unsigned int ic = 0; ic < ncols; ic++)
		{
			os << matrix[ir*ncols+ic] << " ";
		}
		os << endl;
	}
	os << "}" << endl;
	return;
}

template <class T>
ostream &
operator<<(ostream &os, const Matrix<T> &m)
{
	m.dump(os);
	return(os);
}

