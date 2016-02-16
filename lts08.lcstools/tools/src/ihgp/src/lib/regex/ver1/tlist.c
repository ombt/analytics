#include <sysent.h>
#include <stdlib.h>
#include "linkList.h"

main(int argc, char **argv)
{
	if (argc != 2)
	{
		fprintf(stderr, "usage: %s number_of_links\n", argv[0]);
		exit(2);
	}
	List mylist;
	int imax = atoi(argv[1]);
	for (int i = 0; i < imax; i++)
	{
		Link *plink;
		plink = new Link;
		mylist.append(plink);
	}
	Iterator myiter(mylist);
	Link *plink;
	for (i = 1; (plink = myiter()) != (Link *)0; i++)
	{
		fprintf(stdout, "found link %d, %lx\n", i, plink);
	}
	exit(0);
}
