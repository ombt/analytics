/* test of regular expression class */
#include <sysent.h>
#include <stdlib.h>
#include <errno.h>
#include "regExpr.h"

main(int argc, char **argv)
{
	if (argc <= 1)
	{
		fprintf(stderr, "usage: %s regular expression.\n", argv[0]);
		exit(2);
	}
	for (int arg = 1; arg < argc; arg++)
	{
		RegularExpr *prex;

		prex = new RegularExpr(argv[arg]);
		if (prex == (RegularExpr *)0)
		{
			fprintf(stderr, "RegularExpr new failed, errno = %d.\n", errno);
			exit(2);
		}
		fprintf(stderr, "dump NFA ...\n");
		prex->getNFA()->dumpFA();
		fprintf(stderr, "test of move ...\n");
		fprintf(stderr, "enter start state and input: ");
		int start, input;
		fscanf(stdin, "%d %d", &start, &input);
		fprintf(stderr, "move(start=%d, input=%d)\n", start, input);
		FA *pnfa = prex->getNFA();
		Set plist = pnfa->move(start, input);
		if (pnfa->getStatus() != OK)
		{
			fprintf(stderr, "1st move failed\n");
			exit(2);
		}
		else
		{
			fprintf(stderr, "start 1st dumpSet\n");
			plist.dumpSet();
			fprintf(stderr, "end 1st dumpSet\n");
			fprintf(stderr, "enter 2nd input: ");
			int input2;
			fscanf(stdin, "%d", &input2);
			fprintf(stderr, "move(move(%d, %d), %d)\n", 
				start, input, input2);
			Set plist2 = pnfa->move(plist, input2);
			if (pnfa->getStatus() != OK)
			{
				fprintf(stderr, "2nd move failed\n");
				exit(2);
			}
			else
			{
				fprintf(stderr, "start 2nd dumpSet\n");
				plist2.dumpSet();
				fprintf(stderr, "end 2nd dumpSet\n");
			}
		}
		fprintf(stderr, "test of epsilonClose ...\n");
		fprintf(stderr, "enter start state: ");
		fscanf(stdin, "%d", &start);
		fprintf(stderr, "ecl(start=%d)\n", start);
		pnfa = prex->getNFA();
		plist = pnfa->epsilonClosure(start);
		if (pnfa->getStatus() != OK)
		{
			fprintf(stderr, "1st epsilonClosure failed\n");
			exit(2);
		}
		else
		{
			fprintf(stderr, "start 1st dumpSet\n");
			plist.dumpSet();
			fprintf(stderr, "end 1st dumpSet\n");
			fprintf(stderr, "ecl(ecl(%d))\n", start);
			Set plist2 = pnfa->epsilonClosure(plist);
			if (pnfa->getStatus() != OK)
			{
				fprintf(stderr, "epsilonClosure move failed\n");
				exit(2);
			}
			else
			{
				fprintf(stderr, "start 2nd dumpSet\n");
				plist2.dumpSet();
				fprintf(stderr, "end 2nd dumpSet\n");
			}
		}
		fprintf(stderr, "test of move/epsilonClose ...\n");
		fprintf(stderr, "enter start state and input: ");
		fscanf(stdin, "%d %d", &start, &input);
		fprintf(stderr, "move(start=%d, input=%d)\n", start, input);
		pnfa = prex->getNFA();
		plist = pnfa->move(start, input);
		if (pnfa->getStatus() != OK)
		{
			fprintf(stderr, "1st move failed\n");
			exit(2);
		}
		else
		{
			fprintf(stderr, "start 1st dumpSet\n");
			plist.dumpSet();
			fprintf(stderr, "end 1st dumpSet\n");
			fprintf(stderr, "ecl(move(%d, %d))\n", start, input);
			Set plist2 = pnfa->epsilonClosure(plist);
			if (pnfa->getStatus() != OK)
			{
				fprintf(stderr, "epsilonClosure move failed\n");
				exit(2);
			}
			else
			{
				fprintf(stderr, "start 2nd dumpSet\n");
				plist2.dumpSet();
				fprintf(stderr, "end 2nd dumpSet\n");
			}
		}
		fprintf(stderr, "delete FA ...\n");
		delete prex;
	}
	exit(0);
}
