#include <stdlib.h>
#include "set_List.h"

int
main(int argc, char **argv)
{
	MustBeTrue(argc == 3);

	unsigned long key = atol(argv[1]);
	int mmax = atoi(argv[2]);

	srand(key);

	Set_List<int> set1;
	Set_List<int> set2;

	for (int im = 1; im <= mmax; im++)
	{
		unsigned long newm = rand();
		set1 += newm;
		if (rand()%2 == 0)
			set2 += newm;
	}

	cerr << "--------------------------" << endl;
	cerr << "set1 is  ... " << set1 << endl;
	cerr << "set2 is  ... " << set2 << endl;
	cerr << "--------------------------" << endl;
	cerr << "set1 - set2 = " << (set1-set2) << endl;
	cerr << "--------------------------" << endl;
	cerr << "set1 | set2 = " << (set1|set2) << endl;
	cerr << "--------------------------" << endl;
	cerr << "set1 & set2 = " << (set1&set2) << endl;
	cerr << "--------------------------" << endl;

	return(0);
}
