#include "complex.h"
#include "matrix.h"
#include "matrixops.h"

main(int argc, char **argv)
{
#if 0
	MustBeTrue(argc == 3);
	unsigned int nrows = atoi(argv[1]);
	unsigned int ncols = atoi(argv[2]);

	Matrix<Complex<double> > m(nrows, ncols);
	cerr << "m is ... " << m << endl;

	for (int ir = 0 ; ir < nrows; ir++)
	{
		for (int ic = 0; ic < ncols; ic++)
		{
			m(ir, ic) = Complex<double>(ir+1,ic+1);
		}
	}
	cerr << "m is ... " << m << endl;

	Matrix<Complex<double> > invm(m);

	MustBeTrue(inverseGauss(invm, Complex<double>(-1.0)) == OK);
	cerr << "inverse of m ... " << invm << endl;

	cerr << "m*invm ... " << m*invm << endl;

#else
	MustBeTrue(argc == 3);
	unsigned int nrows = atoi(argv[1]);
	unsigned int ncols = atoi(argv[2]);

	Matrix<double> m(nrows, ncols);
	cerr << "m is ... " << m << endl;

	for (int ir = 0 ; ir < nrows; ir++)
	{
		for (int ic = 0; ic < ncols; ic++)
		{
			m(ir, ic) = ir+ic+1;
		}
	}
	cerr << "m is ... " << m << endl;

	Matrix<double> invm(m);
	cerr << "invm is ... " << invm << endl;

	MustBeTrue(inverseGauss(invm, -1.0) == OK);
	cerr << "inverse of m ... " << invm << endl;

	cerr << "m*invm ... " << m*invm << endl;

#endif

	return(0);
}

