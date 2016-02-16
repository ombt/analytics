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
	for (int i = 0; i < imax; i+=3)
	{
		fprintf(stdout, "inserting %d ...\n", i);
		plink = new FAstate(i);
		mylist.append(plink);
		mylist.dumpList();
		fprintf(stdout, "inserting %d ...\n", i+1);
		plink = new FAstate(i+1);
		mylist.append(plink);
		mylist.dumpList();
		fprintf(stdout, "inserting %d ...\n", i+2);
		plink = new FAstate(i+2);
		mylist.append(plink);
		mylist.dumpList();
		fprintf(stdout, "merging %d %d ...\n", i+1, i+2);
		mylist.mergeStates(i+1, i+2);
		mylist.dumpList();
	}
	exit(0);
}
