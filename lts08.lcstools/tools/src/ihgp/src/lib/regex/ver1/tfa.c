#include <sysent.h>
#include <stdlib.h>
#include "fa.h"

main(int argc, char **argv)
{
	if (argc != 2)
	{
		fprintf(stderr, "usage: %s number_of_links\n", argv[0]);
		exit(2);
	}
	FAstate *plink;
	FAstateList mylist;
	int imax = atoi(argv[1]);
	for (int i = 0; i < imax; i++)
	{
		plink = new FAstate(2*i);
		if (i%2 == 0)
		{
			mylist.append(plink);
		}
		else
		{	
			mylist.prepend(plink);
		}
		plink = mylist.findState(2*i);
		if (plink)
		{
			fprintf(stdout, "findState(%d) = %d\n",
				2*i, plink->getState());
		}
		else
		{
			fprintf(stdout, "did NOT find link %d, %lx\n", 
				2*i, plink);
		}
	}
	FAstateIterator myiter(mylist);
	for (i = 1; (plink = myiter()) != (Link *)0; i++)
	{
		fprintf(stdout, "found link %d, %lx\n", 
			plink->getState(), plink);
	}
	for (i = 0; i < imax; i++)
	{
		fprintf(stdout, "looking for %d\n", 2*i);
		plink = mylist.findState(2*i);
		if (plink)
		{
			fprintf(stdout, "findState(%d) = %d\n",
				2*i, plink->getState());
		}
		else
		{
			fprintf(stdout, "did NOT find link %d, %lx\n", 
				2*i, plink);
		}
	}
	exit(0);
}
