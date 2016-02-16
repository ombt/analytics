// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "map.h"

main(int argc, char **argv)
{
	int imax = atoi(argv[1]);

	Map<int, int> *pmap = new Map<int, int>;
	for (int i = 1; i <= imax; i++)
	{
		(*pmap)[i] = i;
	}
	cerr << "map is ... " << *pmap << endl;

	Map<int, int> *pmap2 = new Map<int, int>(*pmap);
	cerr << "map2 is ... " << *pmap2 << endl;

	cerr << "deleting map ... " << endl;
	delete pmap;
	cerr << "map deleted ... " << endl;

	cerr << "map2 is ... " << *pmap2 << endl;

	cerr << "deleting map2 ... " << endl;
	delete pmap2;
	cerr << "map2 deleted ... " << endl;

	return(0);
}


