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
	cerr << "usage: " << cmd << " [-e] [-i init_value] filename" << endl;
	return;
}

main(int argc, char **argv)
{
	int c;
	int flags = O_RDWR|O_CREAT;
	unsigned int value = 1;

	while ((c = getopt(argc, argv, "ei:")) != EOF)
	{
		switch (c)
		{
		case 'e':
			DUMPS("exclusive create !!!");
			flags |= O_EXCL;
			DUMP(flags);
			break;
		case 'i':
			DUMPS("setting initial value !!!");
			value = atoi(optarg);
			DUMP(value);
			break;
		default:
			ERRORD("invalid argument", (char)c, EINVAL);
			return(2);
		}
	}

	if (optind >= argc)
	{
		ERROR("file name not given.", EINVAL);
		return(2);
	}

	mode_t oldumask = umask(0L);

	DUMP(argv[optind]);
	DUMP(flags);
	DUMP(0666L);
	DUMP(value);

	errno = 0;
	umask(0);
	sem_t *sem = sem_open(argv[optind], flags, (unsigned long)0666L, value);
	if (sem == (sem_t *)-1)
	{
		ERRORD("sem_open failed.", argv[optind], errno);
		return(2);
	}
	else
	{
		DUMPS("success in opening/creating semaphore !!!");
		sem_close(sem);
	}
	return(0);
}
