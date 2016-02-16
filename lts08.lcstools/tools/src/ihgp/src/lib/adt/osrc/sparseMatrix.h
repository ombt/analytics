#ifndef __SPARSE_MATRIX_H
#define __SPARSE_MATRIX_H

// sparse matrix class definitions

// headers
#include <stdlib.h>
#include <iostream.h>
#include <math.h>

// local headers
#include "returns.h"
#include "debug.h"
#include "array.h"
#include "vector.h"
#include "binaryTree.h"

// forward declarations
template <class T> class SparseMatrix;
template <class T> Vector<T> operator*(const Vector<T> &, const SparseMatrix<T> &);
template <class T> SparseMatrix<T> operator*(const T &, const SparseMatrix<T> &);
template <class T> SparseMatrix<T> operator*(T, const SparseMatrix<T> &);
template <class T> ostream &operator<<(ostream &, const SparseMatrix<T> &);
template <class T> ostream &operator<<(ostream &, const SparseMatrixElement<T> &);

// sparse matrix element class
template <class T> class SparseMatrixElement
{
public:
	// friend classes
	friend class SparseMatrix<T>;

	// print data
	friend ostream &operator<<(ostream &os, 
		const SparseMatrixElement<T> &sme) {
		os << sme.col << "," << *sme.data << endl;
		return(os);
	};

protected:
        SparseMatrixElement(unsigned int c, const T &d):
		col(c), data(new T(d)) {
		MustBeTrue(data != NULL);
	}
        SparseMatrixElement(const SparseMatrixElement &sme):
		col(sme.col), data(new T(*sme.data)) {
		MustBeTrue(data != NULL);
	}
        ~SparseMatrixElement() {
		delete data;
		data = NULL;
	}

        // assignment and relational operators
        SparseMatrixElement &operator=(const SparseMatrixElement &sme) {
		if (this != &sme)
		{
			// delete old data
			delete data;

			// copy new data
			col = sme.col;
			data = new T(*sme.data);
		}
		return(*this);
	}
        int operator==(const SparseMatrixElement &sme) const {
		return(col == sme.col);
	}
        int operator!=(const SparseMatrixElement &sme) const {
		return(col != sme.col);
	}
        int operator<(const SparseMatrixElement &sme) const {
		return(col < sme.col);
	}
        int operator<=(const SparseMatrixElement &sme) const {
		return(col <= sme.col);
	}
        int operator>(const SparseMatrixElement &sme) const {
		return(col > sme.col);
	}
        int operator>=(const SparseMatrixElement &sme) const {
		return(col >= sme.col);
	}

        // internal data
        unsigned int col;
        T *data;
};

// matrix class definition
template <class T> class SparseMatrix
{
public:
	// constructors and destructor
	SparseMatrix(unsigned int, unsigned int);
	SparseMatrix(const SparseMatrix &);
	~SparseMatrix();

	// assignment operators
	SparseMatrix &operator=(const SparseMatrix &);
	T &operator()(unsigned int, unsigned int);
	T &operator()(unsigned int, unsigned int) const;

	// matrix operations
	SparseMatrix &operator+=(const SparseMatrix &);
	SparseMatrix &operator-=(const SparseMatrix &);
	SparseMatrix &operator*=(const SparseMatrix &);
	SparseMatrix operator+(const SparseMatrix &) const;
	SparseMatrix operator-(const SparseMatrix &) const;
	SparseMatrix operator*(const SparseMatrix &) const;

	// matrix and vector operations
	Vector<T> operator*(const Vector<T> &) const;
	friend Vector<T> operator*(const Vector<T> &, const SparseMatrix<T> &);

	// matrix and scalar operations
	SparseMatrix &operator*=(const T &);
	SparseMatrix &operator/=(const T &);
	SparseMatrix operator*(const T &) const;
	SparseMatrix operator/(const T &) const;
	friend SparseMatrix<T> operator*(const T &, const SparseMatrix<T> &);

	// logical operators
	int operator==(const SparseMatrix &) const;
	int operator!=(const SparseMatrix &) const;

	// other functions
	inline unsigned int getRows() { return(nrows); }
	inline unsigned int getCols() { return(ncols); }
	void dump(ostream & = cout) const;
	friend ostream &operator<<(ostream &, const SparseMatrix<T> &);

protected:
	// internal data
	Array<BinaryTree<SparseMatrixElement<T> > > matrix;
	unsigned int nrows, ncols;
};

#endif

