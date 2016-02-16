// add header for graphing

// headers
#include <stdio.h>
#include <stdlib.h>
#include <iostream.h>
#include <string.h>
#include <math.h>

// local headers
#include "returns.h"
#include "debug.h"

// externs
extern char *optarg;
extern int optind;

// usage message
void
usage(char *cmd)
{
	cerr << "usage: " << cmd << endl;
	cerr << "\tadd header for plotting." << endl;
	return;
}

// main entry point
main(int argc, char **argv)
{
	// get comand line options
	for (int c = 0; (c = getopt(argc, argv, "?")) != EOF; )
	{
		switch (c)
		{
		case '?':
			usage(argv[0]);
			return(0);

		default:
			ERROR("invalid option", EINVAL);
			usage(argv[0]);
			return(2);
		}
	}

	// attach header
	cout << "++++ START OPTIONS ++++" << endl;
	cout << "++++ START DATA ++++" << endl;

	// just read stdin and write to stdout.
	while ( ! cin.eof())
	{
		// read in x,y point
		double tmpx, tmpy;
		cin >> tmpx >> tmpy;

		// write out new points
		cout << tmpx << " " << tmpy << endl;
	}

	// all done
	return(0);
}

