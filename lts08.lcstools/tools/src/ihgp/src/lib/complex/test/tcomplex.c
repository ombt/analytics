#include <stdlib.h>
#include <iostream.h>
#include "mycomplex.h"

main(int argc, char **argv)
{
	MustBeTrue(argc == 2);
	srand(atol(argv[1]));

	Complex<double> a(rand(), rand());
	Complex<double> b;
	b = ::log(a);

	return(0);
}
