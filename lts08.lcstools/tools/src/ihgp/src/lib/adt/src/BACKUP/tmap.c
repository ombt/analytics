// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "map.h"

main(int argc, char **argv)
{
	// check input
	MustBeTrue(argc > 1);

	// sieve of Erast... to generate primes.
	int maxprime = atoi(argv[1]);
	MustBeTrue(maxprime > 1);

	// initialize prime array to all primes
	Map<int, int> primes;
	int ip;
	for (ip=1; ip <= maxprime; ip++)
	{
		primes[ip] = 1;
	}

	// remove composite numbers
	primes[1] = 0;
	for (ip = 2; ip <= maxprime; ip++)
	{
		if (primes[ip])
		{
			cout << "PRIME NUMBER ... " << ip << endl;
			for (int ip2 = 2*ip; ip2 <= maxprime; ip2 += ip)
			{
				primes[ip2] = 0;
			}
		}
	}

	// user iterator to print prime numbers
	MapIterator<int, int> iter(primes);
	for ( ; ! iter.done(); iter++)
	{
		if (iter.data())
			cout << "(USE ITERATOR) PRIME NUMBER ... " << iter.key() << endl;
	}

	// print prime numbers
	cout << "primes are ... " << primes << endl;

	// remove all numbers
	for (ip = 1; ip <= maxprime; ip++)
	{
		MustBeTrue(primes.remove(ip) == OK);
		cout << "maxprimes after delete of number ";
		cout << ip << " is ... " << primes << endl;
	}
	return(0);
}



