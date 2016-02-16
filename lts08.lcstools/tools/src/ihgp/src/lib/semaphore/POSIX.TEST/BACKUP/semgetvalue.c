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
	sem_t *sem = sem_open(argv[1], 0);
	if (sem == (sem_t *)-1)
	{
		ERRORD("sem_open failed.", argv[1], errno);
		return(2);
	}
	int value;
	if (sem_getvalue(sem, &value) != OK)
	{
		ERROR("sem_getvalue failed.", errno);
		return(2);
	}
	sem_close(sem);
	DUMP(value);
	return(0);
}
