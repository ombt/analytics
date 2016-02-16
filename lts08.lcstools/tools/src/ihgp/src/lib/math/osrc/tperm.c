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

	Matrix<double> m(nrows, ncols);

	for (int ir = 0 ; ir < nrows; ir++)
	{
		for (int ic = 0; ic < ncols; ic++)
		{
			m(ir, ic) = strtod(argv[arg++], NULL);
		}
	}
	cout << "m is ... " << m << endl;

	Vector<int> pv(nrows);
	for (ir = 0; ir < nrows; ir++)
	{
		pv[ir] = atoi(argv[arg++]);
	}
	cout << "pv is ... " << pv << endl << endl;

	Matrix<double> pm(nrows, ncols);
	MustBeTrue(PermVectorToPermMatrix(pm, pv) == OK);
	cout << "pm is ... " << pm << endl;
	cout << "pm*m is ... " << pm*m << endl;

	return(0);
}
