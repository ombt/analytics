#ifndef __LUP_H
#define __LUP_H

// LUP decomposition definitions

// headers
#include <stdlib.h>
#include <iostream.h>
#include <math.h>

// local headers
#include "returns.h"
#include "debug.h"
#include "vector.h"
#include "matrix.h"
#include "epsilon.h"

// LUP operations declarations
template <class T>
int
ForwardSub(Matrix<T> &, Vector<T> &, Vector<T> &, Vector<int> &, T);

template <class T>
int
ForwardSub(Matrix<T> &, Vector<T> &, Vector<T> &, T);

template <class T>
int
BackwardSub(Matrix<T> &, Vector<T> &, Vector<T> &, Vector<int> &, T);

template <class T>
int
BackwardSub(Matrix<T> &, Vector<T> &, Vector<T> &, T);

template <class T>
int
DoolittleLUP_ByRow(Matrix<T> &, Matrix<T> &l, Matrix<T> &u, Vector<int> &, T);

template <class T>
int
SolveUsingDoolittleLUP_ByRow(Matrix<T> &, Vector<T> &, Vector<T> &, T);

template <class T>
int
CroutLUP_ByRow(Matrix<T> &, Matrix<T> &l, Matrix<T> &u, Vector<int> &, T);

template <class T>
int
SolveUsingCroutLUP_ByRow(Matrix<T> &, Vector<T> &, Vector<T> &, T);

template <class T>
int
CroutLUP_ByCol(Matrix<T> &, Matrix<T> &l, Matrix<T> &u, Vector<int> &, T);

template <class T>
int
SolveUsingCroutLUP_ByCol(Matrix<T> &, Vector<T> &, Vector<T> &, T);

template <class T>
int
CroutLUP_ByCol_Pivot(Matrix<T> &, Matrix<T> &l, Matrix<T> &u, Vector<int> &, T);

template <class T>
int
SolveUsingCroutLUP_ByCol_Pivot(Matrix<T> &, Vector<T> &, Vector<T> &, T);

template <class T>
int
Gaussian_NoPivoting(Matrix<T> &, Vector<T> &, Vector<int> &, T);

template <class T>
int
GaussianLUP_Pivoting(Matrix<T> &, Vector<int> &, T);

template <class T>
int
SolveUsingGaussianLUP_Pivoting(Matrix<T> &, Vector<T> &, Vector<T> &, Vector<int> &, T);

template <class TM, class TV>
int
PermVectorToPermMatrix(Matrix<TM> &, Vector<TV> &);

#endif
