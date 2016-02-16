/* test of regular expression class */
#include <sysent.h>
#include <stdlib.h>
#include <errno.h>
#include "regExpr.h"

main(int argc, char **argv)
{
	if (argc <= 2)
	{
		fprintf(stderr, "usage: %s regular_expression string.\n", argv[0]);
		exit(2);
	}
	RegularExpr *prex;

	fprintf(stderr, "processing RE %s ...\n", argv[1]);
	prex = new RegularExpr(argv[1]);
	if (prex == (RegularExpr *)0)
	{
		fprintf(stderr, "RegularExpr new failed, errno = %d.\n", errno);
		exit(2);
	}

	fprintf(stderr, "dump NFA ...\n");
	prex->getFA()->dumpFA();

	char ans[32];
	fprintf(stderr, "convert to a DFA ??? [y/n] \n");
	fscanf(stdin, "%s", &ans);
	if (*ans == 'y' || *ans == 'Y')
	{
		fprintf(stderr, "convert NFA to DFA ...\n");
		if (prex->NFAtoDFA() != OK)
		{
			fprintf(stderr, "NFAtoDFA failed, status = %d\n", prex->getStatus());
			exit(2);
		}
		fprintf(stderr, "dump DFA ...\n");
		prex->getFA()->dumpFA();
		fprintf(stderr, "check string using DFA ...\n");
	}
	else
	{
		fprintf(stderr, "dump NFA ...\n");
		prex->getFA()->dumpFA();
		fprintf(stderr, "check string using NFA ...\n");
	}

	if (prex->match(argv[2]) == MATCH)
	{
		fprintf(stderr, "WE HAVE A MATCH !!!\n");
	}
	else
	{
		fprintf(stderr, "WE DO NOT HAVE A MATCH !!!\n");
	}

	fprintf(stderr, "delete FA ...\n");
	delete prex;
	exit(0);
}
