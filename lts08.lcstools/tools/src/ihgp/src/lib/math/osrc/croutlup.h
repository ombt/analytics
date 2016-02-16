#ifndef __CROUTLUP_H
#define __CROUTLUP_H

// Crout LUP decomposition definitions

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
BackwardSub(Matrix<T> &, Vector<T> &, Vector<T> &, T);

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

#endif
