#include <stdlib.h>
#include <stdio.h>
#include <iostream.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <semaphore.h>
#include <errno.h>
#include "returns.h"
#include "debug.h"

void 
usage(const char *cmd)
{
	cerr << "usage: " << cmd << " filename" << endl;
	return;
}

main(int argc, char **argv)
{
	if (argc != 2)
	{
		ERROR("file name not given.", EINVAL);
		usage(argv[0]);
		return(2);
	}

	DUMP(argv[1]);
	if (sem_unlink(argv[1]) == NOTOK)
	{
		ERRORD("sem_unlink failed.", argv[optind], errno);
		return(2);
	}
	DUMPS("success in unlinking semaphore !!!");
	return(0);
}
