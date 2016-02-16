#include "vector.h"
#include "matrix.h"
#include "lup.h"

main(int argc, char **argv)
{
	// check the number of arguments
	MustBeTrue(argc > 3);

	// get number of rows and columns
	int arg = 1;
	unsigned int nrows = atoi(argv[arg++]);
	unsigned int ncols = atoi(argv[arg++]);

	// define matrix and initialize elements
	Matrix<double> m(nrows, ncols);
	for (int ir = 0 ; ir < nrows; ir++)
	{
		for (int ic = 0; ic < ncols; ic++)
		{
			m(ir, ic) = strtod(argv[arg++], NULL);
		}
	}
	cout << "m is ... " << m << endl;

	// initialize inhomogeneous part.
	Vector<double> y(nrows);
	for (ir = 0; ir < nrows; ir++)
	{
		y[ir] = strtod(argv[arg++], NULL);
	}
	cout << "y is ... " << y << endl << endl;

	// solve using crout LUP with pivoting
	Matrix<double> m2(m);
	Vector<double> y2(y);
	Vector<int> pv2(nrows);
	Matrix<double> l2(nrows, nrows);
	Matrix<double> u2(nrows, nrows);
	if (CroutLUP_ByCol_Pivot(m2, l2, u2, pv2, 0.0) != OK)
		cout << "CroutLUP_ByCol_Pivot FAILED !!!" << endl;
	else
		cout << "CroutLUP_ByCol_Pivot PASSED !!!" << endl;
	cout << "m2 is ... " << m2 << endl;
	cout << "l2 is ... " << l2 << endl;
	cout << "u2 is ... " << u2 << endl;
	cout << "l2*u2 is ... " << l2*u2 << endl;
	cout << "pv2 is ... " << pv2 << endl;

	// solve using crout LUP with no pivoting
	Matrix<double> m3(m);
	Vector<double> y3(y);
	Vector<int> pv3(nrows);
	Matrix<double> l3(nrows, nrows);
	Matrix<double> u3(nrows, nrows);
	if (CroutLUP_ByCol(m3, l3, u3, pv3, 0.0) != OK)
		cout << "CroutLUP_ByCol FAILED !!!" << endl;
	else
		cout << "CroutLUP_ByCol PASSED !!!" << endl;
	cout << "m3 is ... " << m3 << endl;
	cout << "l3 is ... " << l3 << endl;
	cout << "u3 is ... " << u3 << endl;
	cout << "l3*u3 is ... " << l3*u3 << endl;
	cout << "pv3 is ... " << pv3 << endl;

	// solve using crout LUP with pivoting
	Matrix<double> m4(m);
	Vector<double> y4(y);
	Vector<double> x4(nrows);
	if (SolveUsingCroutLUP_ByCol_Pivot(m4, x4, y4, 0.0) != OK)
		cout << "SolveUsingCroutLUP_ByCol_Pivot FAILED !!!" << endl;
	else
		cout << "SolveUsingCroutLUP_ByCol_Pivot PASSED !!!" << endl;
	cout << "m4 is ... " << m4 << endl;
	cout << "x4 is ... " << x4 << endl;
	cout << "y4 is ... " << y4 << endl;

	// solve using crout LUP with no pivoting
	Matrix<double> m5(m);
	Vector<double> y5(y);
	Vector<double> x5(nrows);
	if (SolveUsingCroutLUP_ByCol(m5, x5, y5, 0.0) != OK)
		cout << "SolveUsingCroutLUP_ByCol FAILED !!!" << endl;
	else
		cout << "SolveUsingCroutLUP_ByCol PASSED !!!" << endl;
	cout << "m5 is ... " << m5 << endl;
	cout << "x5 is ... " << x5 << endl;
	cout << "y5 is ... " << y5 << endl;

	return(0);
}
