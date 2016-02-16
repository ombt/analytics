#include <stdlib.h>
#include "complex.h"

main(int argc, char **argv)
{
	MustBeTrue(argc == 2);
	srand(atol(argv[1]));

	Complex<double> a(rand(), rand());
	cerr << "a is ... " << a << endl;

	Complex<double> b(rand(), rand());
	cerr << "b is ... " << b << endl;

	Complex<double> c(a);
	cerr << "c(a) is ... " << c << endl;

	a += b;
	cerr << "a += b is ... " << a << endl;

	a -= c;
	cerr << "a -= c is ... " << a << endl;

	a *= c;
	cerr << "a *= c is ... " << a << endl;

	a /= c;
	cerr << "a /= c is ... " << a << endl;

	cerr << "a is ... " << a << endl;
	cerr << "b is ... " << b << endl;

	cerr << "a + b is ... " << (a+b) << endl;
	cerr << "a - b is ... " << (a-b) << endl;
	cerr << "a * b is ... " << (a*b) << endl;
	cerr << "a / b is ... " << (a/b) << endl;

	if (a == b)
		cerr << "a == b is true" << endl;
	else
		cerr << "a == b is false" << endl;

	if (a != b)
		cerr << "a != b is true" << endl;
	else
		cerr << "a != b is false" << endl;

	if (a < b)
		cerr << "a < b is true" << endl;
	else
		cerr << "a < b is false" << endl;

	if (a > b)
		cerr << "a > b is true" << endl;
	else
		cerr << "a > b is false" << endl;

	if (a <= b)
		cerr << "a <= b is true" << endl;
	else
		cerr << "a <= b is false" << endl;

	if (a >= b)
		cerr << "a >= b is true" << endl;
	else
		cerr << "a >= b is false" << endl;

	return(0);
}
