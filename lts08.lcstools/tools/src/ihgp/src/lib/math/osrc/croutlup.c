//
// this file contain functions for solving a linear set of 
// equations using gaussian eliminination or LUP decomposition.
//
// given the equation M*x = y where M is an nxn matrix and x, y
// n-dimensioned vectors. Solve for x given M and y. There are
// two direct methods of solving this set of equations. On uses
// gaussian elimination and the other uses an LU decomposition.
//
// gaussian elimination reduces a matrix to upper triangular
// form. once the matrix is in this form, the back substitution
// is used to solve for x.
//
// the second form factors M into two matrices, a lower triangular
// matrix L and an upper triangualr matrix U, which satisfy
// relation, A = L*U.
//
// once L*U is known, solving for x is as follows.
// for x. matrix M is decomposed into L and U, then solved as
// follows.
//
// let M*x = y where M is an nxn matrix and x, and y are
// n-dimension vectors. Then let M = L*U where L is lower
// triangular and U is upper triangular. the solution for x
// is given by:
//
//	M*x = L*U*x = y
//
// let z = U*x, then
//
//	L*U*x = L*z = y and U*x = z.
//
// to solve for x, first solve L*z = y. Use forward substituion since
// L is lower triangular. Then once you have z, solve for x
// using the equation:
//
//	U*x = z.
//
// solve using back substitution since U is upper triangular. this then
// gives you x, the original problem.
// 
// there two basic ways to calculate L and U. one makes L a unit
// lower triangular matrix (l(i, i) = 1, 1<= i <= n). this is doolittle's
// method. the second method makes U unit upper triangular matrix
// (u(i, i) = 1, 1 <= i <= n);
//

// required headers
#include <stdio.h>
#include "lup.h"

//
// given a lower-triangular matrix, calculate solution using 
// forward substitution 
//
template <class T>
int
ForwardSub(Matrix<T> &m, Vector<T> &x, Vector<T> &y, Vector<int> &p, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// start forward substitution
	for (int i = 0; i < max; i++)
	{
		// check for a singular matrix
		if (fabs(m(i, i)) <= ep)
			return(NOTOK);

		// solve for x by substituting previous solutions
		x[i] = y[p[i]];
		for (int j = 0; j < i; j++)
		{
			x[i] -= m(i, j)*x[j];
		}
		x[i] /= m(i, i);
	}

	// all done
	return(OK);
}

//
// given a lower-triangular matrix, calculate solution using 
// forward substitution 
//
template <class T>
int
ForwardSub(Matrix<T> &m, Vector<T> &x, Vector<T> &y, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// start forward substitution
	for (int i = 0; i < max; i++)
	{
		// check for a singular matrix
		if (fabs(m(i, i)) <= ep)
			return(NOTOK);

		// solve for x by substituting previous solutions
		x[i] = y[i];
		for (int j = 0; j < i; j++)
		{
			x[i] -= m(i, j)*x[j];
		}
		x[i] /= m(i, i);
	}

	// all done
	return(OK);
}

//
// given an upper-triangular matrix, calculate solution using 
// backward substitution 
//
template <class T>
int
BackwardSub(Matrix<T> &m, Vector<T> &x, Vector<T> &y, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// start backward substitution
	for (int i = max-1; i >= 0; i--)
	{
		// check for a singular matrix
		if (fabs(m(i, i)) <= ep)
			return(NOTOK);

		// solve for x by substituting previous solutions
		x[i] = y[i];
		for (int j = i+1; j < max; j++)
		{
			x[i] -= m(i, j)*x[j];
		}
		x[i] /= m(i, i);
	}

	// all done
	return(OK);
}

//
// given a matrix, calculate LU decomposition using Crout's
// method. this method calculates column by column with no 
// pivoting.
//
template <class T>
int
CroutLUP_ByCol(Matrix<T> &m, Matrix<T> &l, Matrix<T> &u, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// assign lower diagonal elements the value 1
	for (int i = 0; i < max; i++)
	{
		u(i, i) = 1.0;
	}

	// start calculating L and U matrices
	for (i = 0; i < max; i++)
	{
		// calculate lower matrix
		for (int j = i; j < max; j++)
		{
			l(j, i) = m(j, i);
			for (int k = 0; k < i; k++)
			{
				l(j, i) -= l(j, k)*u(k, i);
			}
		}

		// calculate upper matrix
		for (j = i+1; j < max; j++)
		{
			u(i, j) = m(i, j);
			for (int k = 0; k < i; k++)
			{
				u(i, j) -= l(i, k)*u(k, j);
			}
			if (fabs(l(i, i)) <= ep)
				return(NOTOK);
			else
				u(i, j) /= l(i, i);
		}
	}

	// all done
	return(OK);
}

// solve using crout's method by col, no pivoting.
template <class T>
int
SolveUsingCroutLUP_ByCol(Matrix<T> &m, Vector<T> &x, Vector<T> &y, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// get L and U matrices via Crout's method, that is,
	// the diagonal elements of L are set equal to 1.
	Matrix<T> l(m.nrows, m.ncols);
	Matrix<T> u(m.nrows, m.ncols);
	if (CroutLUP_ByCol(m, l, u, ep) != OK)
		return(NOTOK);

	// solve for z-vector, then for x-vector.
	Vector<T> z(m.nrows);
	if (ForwardSub(l, z, y, ep) != OK)
		return(NOTOK);
	if (BackwardSub(u, x, z, ep) != OK)
		return(NOTOK);

	// all done
	return(OK);
}

//
//
// given a matrix, calculate LU decomposition using Crout's
// method. this method calculates column by column with
// pivoting.
//
template <class T>
int
CroutLUP_ByCol_Pivot(Matrix<T> &m, Matrix<T> &l, Matrix<T> &u, Vector<int> &p, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// assign lower diagonal elements the value 1
	for (int i = 0; i < max; i++)
	{
		u(i, i) = 1.0;
		p[i] = i;
	}

	// start calculating L and U matrices
	for (i = 0; i < max; i++)
	{
		// calculate lower matrix
		for (int j = i; j < max; j++)
		{
			l(j, i) = m(p[j], i);
			for (int k = 0; k < i; k++)
			{
				l(j, i) -= l(j, k)*u(k, i);
			}
		}

		// find pivot row
		int imax = i;
		for (j = i+1; j < max; j++)
		{
			if (fabs(l(j, i)) > fabs(l(imax, i)))
				imax = j;
		}
		if (imax != i)
		{
			int tmp = p[i];
			p[i] = p[imax];
			p[imax] = tmp;
		}

		// calculate upper matrix
		for (j = i+1; j < max; j++)
		{
			u(i, j) = m(p[i], j);
			for (int k = 0; k < i; k++)
			{
				u(i, j) -= l(i, k)*u(k, j);
			}
			if (fabs(l(i, i)) <= ep)
				return(NOTOK);
			else
				u(i, j) /= l(i, i);
		}
	}

	// all done
	return(OK);
}

// solve using crout's method by col, no pivoting.
template <class T>
int
SolveUsingCroutLUP_ByCol_Pivot(Matrix<T> &m, Vector<T> &x, Vector<T> &y, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// get L and U matrices via Crout's method, that is,
	// the diagonal elements of L are set equal to 1.
	Matrix<T> l(m.nrows, m.ncols);
	Matrix<T> u(m.nrows, m.ncols);
	Vector<int> p(m.nrows);
	if (CroutLUP_ByCol_Pivot(m, l, u, p, ep) != OK)
		return(NOTOK);

	// solve for z-vector, then for x-vector.
	Vector<T> z(m.nrows);
	if (ForwardSub(l, z, y, p, ep) != OK)
		return(NOTOK);
	if (BackwardSub(u, x, z, ep) != OK)
		return(NOTOK);

	// all done
	return(OK);
}

