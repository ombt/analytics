#include "matrix.h"

main(int argc, char **argv)
{
	MustBeTrue(argc == 3);
	unsigned int nrows = atoi(argv[1]);
	unsigned int ncols = atoi(argv[2]);

	Matrix<double> m(nrows, ncols);
	cerr << "m is ... " << m << endl;

	for (int ir = 0 ; ir < nrows; ir++)
	{
		for (int ic = 0; ic < ncols; ic++)
		{
			m(ir, ic) = (ir+1)*(ic+1);
		}
	}
	cerr << "m is ... " << m << endl;

	cerr << "m*m is ... " << m*m << endl;

	cerr << "m+m is ... " << m+m << endl;

	cerr << "m-m is ... " << m-m << endl;

	cerr << "m*m/5.0 is ... " << m*m/5.0 << endl;

	cerr << "5.0*(m+m) is ... " << 5.0*(m+m) << endl;

	cerr << "(m+m)*5.0 is ... " << (m+m)*5.0 << endl;

	return(0);
}
