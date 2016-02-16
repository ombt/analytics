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
BackwardSub(Matrix<T> &m, Vector<T> &x, Vector<T> &y, Vector<int> &p, T ep)
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
		if (fabs(m(p[i], i)) <= ep)
			return(NOTOK);

		// solve for x by substituting previous solutions
		x[i] = y[p[i]];
		for (int j = i+1; j < max; j++)
		{
			x[i] -= m(p[i], j)*x[j];
		}
		x[i] /= m(p[i], i);
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
// given a matrix, calculate LU decomposition using Doolittle's
// method. scan row-by-row. no pivoting.
//
template <class T>
int
DoolittleLUP_ByRow(Matrix<T> &m, Matrix<T> &l, Matrix<T> &u, Vector<int> &p, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// assign lower diagonal elements the value 1 and
	// initialize permutation vector
	for (int k = 0; k < max; k++)
	{
		l(k, k) = 1.0;
		p[k] = k;
	}

	// start calculating L and U matrices
	for (k = 0; k < max; k++)
	{
		// calculate lower matrix
		for (int j = 0; j < k; j++)
		{
			l(k, j) = m(k, j);
			for (int i = 0; i < j; i++)
			{
				l(k, j) -= l(k, i)*u(i, j);
			}
			if (fabs(u(j, j)) <= ep)
				return(NOTOK);
			else
				l(k, j) /= u(j, j);
		}

		// calculate upper matrix
		for (j = k; j < max; j++)
		{
			u(k, j) = m(k, j);
			for (int i = 0; i < k; i++)
			{
				u(k, j) -= l(k, i)*u(i, j);
			}
		}
	}

	// all done
	return(OK);
}

// solve using doolittle's method by row, no pivoting.
template <class T>
int
SolveUsingDoolittleLUP_ByRow(Matrix<T> &m, Vector<T> &x, Vector<T> &y, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// get L and U matrices via Doolittle's method, that is,
	// the diagonal elements of L are set equal to 1.
	Matrix<T> l(m.nrows, m.ncols);
	Matrix<T> u(m.nrows, m.ncols);
	Vector<int> p(m.nrows);
	if (DoolittleLUP_ByRow(m, l, u, p, ep) != OK)
		return(NOTOK);

	// solve for z-vector, then for x-vector.
	Vector<T> z(m.nrows);
	if (ForwardSub(l, z, y, p, ep) != OK)
		return(NOTOK);
	if (BackwardSub(u, x, z, p, ep) != OK)
		return(NOTOK);

	// all done
	return(OK);
}

//
// given a matrix, calculate LU decomposition using Crout's
// method. this method calculates row by row. no pivoting.
//
template <class T>
int
CroutLUP_ByRow(Matrix<T> &m, Matrix<T> &l, Matrix<T> &u, Vector<int> &p, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// assign lower diagonal elements the value 1 and
	// initialize permutation vector
	for (int k = 0; k < max; k++)
	{
		u(k, k) = 1.0;
		p[k] = k;
	}

	// start calculating L and U matrices
	for (k = 0; k < max; k++)
	{
		// calculate lower matrix
		for (int j = 0; j <= k; j++)
		{
			l(k, j) = m(k, j);
			for (int i = 0; i < j; i++)
			{
				l(k, j) -= l(k, i)*u(i, j);
			}
		}

		// calculate upper matrix
		for (j = k+1; j < max; j++)
		{
			u(k, j) = m(k, j);
			for (int i = 0; i < k; i++)
			{
				u(k, j) -= l(k, i)*u(i, j);
			}
			if (fabs(l(k, k)) <= ep)
				return(NOTOK);
			else
				u(k, j) /= l(k, k);
		}
	}

	// all done
	return(OK);
}

// solve using crout's method by row, no pivoting.
template <class T>
int
SolveUsingCroutLUP_ByRow(Matrix<T> &m, Vector<T> &x, Vector<T> &y, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// get L and U matrices via Crout's method, that is,
	// the diagonal elements of L are set equal to 1.
	Matrix<T> l(m.nrows, m.ncols);
	Matrix<T> u(m.nrows, m.ncols);
	Vector<int> p(m.nrows);
	if (CroutLUP_ByRow(m, l, u, p, ep) != OK)
		return(NOTOK);

	// solve for z-vector, then for x-vector.
	Vector<T> z(m.nrows);
	if (ForwardSub(l, z, y, p, ep) != OK)
		return(NOTOK);
	if (BackwardSub(u, x, z, p, ep) != OK)
		return(NOTOK);

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
CroutLUP_ByCol(Matrix<T> &m, Matrix<T> &l, Matrix<T> &u, Vector<int> &p, T ep)
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
	Vector<int> p(m.nrows);
	if (CroutLUP_ByCol(m, l, u, p, ep) != OK)
		return(NOTOK);

	// solve for z-vector, then for x-vector.
	Vector<T> z(m.nrows);
	if (ForwardSub(l, z, y, p, ep) != OK)
		return(NOTOK);
	if (BackwardSub(u, x, z, p, ep) != OK)
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

//
// given a matrix, apply gaussian method. no pivoting in this one.
//
template <class T>
int
Gaussian_NoPivoting(Matrix<T> &m, Vector<T> &y, Vector<int> &p, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// start gaussian elimination process
	for (int k = 0; k < (max-1); k++)
	{
		// initialize pivot vector
		p[k] = k;

		// check for division by zero
		if (fabs(m(k, k)) <= ep)
			return(NOTOK);

		// row reduce.
		for (int i = k+1; i < max; i++)
		{
			T d = m(i, k)/m(k, k);
			m(i, k) = 0;
			for (int j = k+1; j < max; j++)
			{
				m(i, j) -= d*m(k, j);
			}
			y[i] -= d*y[k];
		}
	}
	p[k] = k;

	// all done
	return(OK);
}

//
// given a matrix, generate an LUP decomposition using Gaussian
// elimination with scaling and pivoting.
//
template <class T>
int
GaussianLUP_Pivoting(Matrix<T> &m, Vector<int> &p, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// generate scaling information for each row. initialize 
	// permutation array, p.
	Vector<T> s(max);
	for (int i = 0; i < max; i++)
	{
		p[i] = i;
		s[i] = fabs(m(i, 1));
		for (int j = 2; j < max; j++)
		{
			T tmp = fabs(m(i, j));
			if (tmp > s[i])
				s[i] = tmp;
		}
	}

	// start gaussian elimination process
	for (int k = 0; k < (max-1); k++)
	{
		// find pivot row
		int pivot = k;
		T tmpf = fabs(m(p[pivot], k))/s[p[pivot]];
		for (int i = k+1; i < max; i++)
		{
			T tmpf2 = fabs(m(p[i], k))/s[p[i]];
			if (tmpf2 > tmpf)
			{
				pivot = i;
				tmpf = tmpf2;
			}
		}
		if (pivot != k)
		{
			int tmpp = p[k];
			p[k] = p[pivot];
			p[pivot] = tmpp;
		}

		// check for division by zero
		if (fabs(m(p[k], k)) <= ep)
			return(NOTOK);

		// calculate L and U matrices
		for (i = k+1; i < max; i++)
		{
			// multiplier for column
			T d = m(p[i], k)/m(p[k], k);

			// save multiplier since it is L.
			m(p[i], k) = d;

			// reduce original matrix to get U.
			for (int j = k+1; j < max; j++)
			{
				m(p[i], j) -= d*m(p[k], j);
			}
		}
	}

	// all done
	return(OK);
}

//
// given a gaussian LUP decomposition of a matrix and a permutation vector,
// solve for x-vector using the given y-vector.
//
template <class T>
int
SolveUsingGaussianLUP_Pivoting(Matrix<T> &m, Vector<T> &x, Vector<T> &y, Vector<int> &p, T ep)
{
	// must be a square matrix
	MustBeTrue(m.nrows == m.ncols && m.nrows > 0);

	// check epsilon, set if invalid
	T minep = calcEpsilon(T(0));
	if ((ep = fabs(ep)) < minep)
		ep = minep;

	// get number of rows and columns
	int max = m.nrows;

	// update y-vector
	for (int k = 0; k < (max-1); k++)
	{
		for (int i = k+1; i < max; i++)
		{
			y[p[i]] -= m(p[i], k)*y[p[k]];
		}
	}

	// start backward substitution
	for (int i = max-1; i >= 0; i--)
	{
		// check for a singular matrix
		if (fabs(m(p[i], i)) <= ep)
			return(NOTOK);

		// solve for x by substituting previous solutions
		x[i] = y[p[i]];
		for (int j = i+1; j < max; j++)
		{
			x[i] -= m(p[i], j)*x[j];
		}
		x[i] /= m(p[i], i);
	}

	// all done
	return(OK);
}

// convert permutation vector to a permutation matrix.
template <class TM, class TV>
int
PermVectorToPermMatrix(Matrix<TM> &pm, Vector<TV> &pv)
{
	// must be a square matrix and vector must match
	MustBeTrue(pm.nrows == pm.ncols && pm.nrows > 0);
	MustBeTrue(pm.nrows == pv.getDimension());

	// get number of rows and columns
	int max = pm.nrows;

	// update matrix using vector
	for (int i = 0; i < max; i++)
	{
		for (int j = 0; j < max; j++)
		{
			pm(i, j) = 0;
		}
		pm(i, pv[i]) = 1;
	}

	// all done
	return(OK);
}
