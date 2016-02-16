#include <stdlib.h>
#include "mycomplex.h"

main(int argc, char **argv)
{
	MustBeTrue(argc == 2);
	srand(atol(argv[1]));

	Complex<double> a(rand(), rand());
	cerr << "a is ... " << a << endl;

	Complex<double> b(rand(), rand());
	cerr << "b is ... " << b << endl;

	Complex<double> c(a);
	cerr << "copy a to c, c(a) is ... " << c << endl;

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

	Complex<double> d(1,1);
	cerr << "d is ... " << d << endl;
	cerr << "log(exp(d)) is ... " << log(exp(d)) << endl;
	cerr << "asin(sin(d)) is ... " << asin(sin(d)) << endl;
	cerr << "asinh(sinh(d)) is ... " << asinh(sinh(d)) << endl;

	Complex<double> e(1,-1);
	cerr << "e is ... " << e << endl;
	cerr << "log(exp(e)) is ... " << log(exp(e)) << endl;
	cerr << "asin(sin(e)) is ... " << asin(sin(e)) << endl;
	cerr << "asinh(sinh(e)) is ... " << asinh(sinh(e)) << endl;

	return(0);
}
