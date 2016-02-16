#include "complex.h"
#include "vector.h"
#include "matrix.h"
#include "lup.h"

main(int argc, char **argv)
{
	MustBeTrue(argc > 3);
	int arg = 1;
	unsigned int nrows = atoi(argv[arg++]);
	unsigned int ncols = atoi(argv[arg++]);

	Matrix<float> m(nrows, ncols);

	for (int ir = 0 ; ir < nrows; ir++)
	{
		for (int ic = 0; ic < ncols; ic++)
		{
			m(ir, ic) = strtod(argv[arg++], NULL);
		}
	}
	cout << "m is ... " << m << endl;

	Vector<int> p(nrows);
	Vector<float> x(nrows), y(nrows), z(nrows), t(nrows);
	for (ir = 0; ir < nrows; ir++)
	{
		x[ir] = 0.0;
		z[ir] = 0.0;
		y[ir] = strtod(argv[arg++], NULL);
	}
	cout << "y is ... " << y << endl << endl;

	MustBeTrue(SolveUsingDoolittleLUP_ByRow(m, x, y, float(0.0)) == OK);
	cout << "DOOLITTLE: x is ... " << x << endl;
	cout << "DOOLITTLE: m*x = " << (m*x) << endl;
	cout << "DOOLITTLE: y = " << y << endl;

	MustBeTrue(SolveUsingCroutLUP_ByRow(m, x, y, float(0.0)) == OK);
	cout << "CROUT: x is ... " << x << endl;
	cout << "CROUT: m*x = " << (m*x) << endl;
	cout << "CROUT: y = " << y << endl;

	MustBeTrue(SolveUsingCroutLUP_ByCol_Pivot(m, x, y, float(0.0)) == OK);
	cout << "CROUT PIVOT: x is ... " << x << endl;

	return(0);
}
