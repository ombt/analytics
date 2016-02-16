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
#define EPSILON -1.0

// forward declarations
template <class T> class Matrix;

// required math operations
extern float conj(const float &);
extern double conj(const double &);
extern long double conj(const long double &);

// matrix operations declarations
template <class T> int transpose(Matrix<T> &);
template <class T> int conjugate(Matrix<T> &);
template <class T> int adjoint(Matrix<T> &);
template <class T> int inverseGauss(Matrix<T> &, T);
template <class T> int solveGauss(Matrix<T> &, Vector<T> &, Vector<T> &, T);

#if 0
template <class T> int determinant(const Matrix<T> &, T &, T = EPSILON);
template <class T> int trace(const Matrix<T> &, T &);
#endif

#endif
