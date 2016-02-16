#ifndef __MATRIXOPS_H
#define __MATRIXOPS_H

// matrix class definitions

// headers
#include <stdlib.h>
#include <iostream.h>
#include <math.h>

// local headers
#include "returns.h"
#include "debug.h"
#include "vector.h"

// local definitions
#define EPSILON 1.0e-8

// forward declarations
template <class T> class Matrix;
template <class T> int transpose(Matrix<T> &);
template <class T> int conjugate(Matrix<T> &);
template <class T> int inverse(Matrix<T> &, T = EPSILON);
template <class T> int solve(
	Matrix<T> &, Vector<T> &, Vector<T> &, T = EPSILON);
template <class T> int determinant(const Matrix<T> &, T &, T = EPSILON);
template <class T> int trace(const Matrix<T> &, T &);

#endif
