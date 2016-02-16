/* regular expression main */
#include <sysent.h>
#include <stdlib.h>
#include <errno.h>
#include "regx.h"
#include "debug.h"

static const int BufSize = 8192;

submain(int argc, char **argv)
{
	/* check number of arguments */
	if (argc < 2)
	{
		errno = EINVAL;
		ERROR("usage: regx regular_expression [files ...]", errno);
		return(2);
	}

	/* create regular expression object */
	Regx regx(argv[1]);
	if ((errno = regx.getStatus()) != OK)
	{
		ERROR("main: regular expr constructor failed.", errno);
		return(2);
	}

	/* read input */
	char inbuf[BufSize+1];
	if (argc == 2)
	{
		/* read stdin */
		while (fgets(inbuf, BufSize, stdin) != (char *)0)
		{
			char *pin;
			inbuf[BufSize] = 0;
			switch (regx.match(inbuf))
			{
			case MATCH:
				for (pin = inbuf; *pin != 0 && *pin != '\n'; 
				     pin++) ;
				if (*pin == '\n') *pin = 0;
				fprintf(stdout, "%s\n", inbuf);
				break;
			case NOMATCH:
				break;
			default:
				ERROR("match failed.", NOTOK);
				return(2);
			}
		}
		return(0);
	}

	/* open and read files */
	for (int arg = 2; arg < argc; arg++)
	{
		FILE *infd = fopen(argv[arg], "r");
		if (infd == (FILE *)0)
		{
			ERROR("fopen failed.", errno);
			continue;
		}
		while (fgets(inbuf, BufSize, infd) != (char *)0)
		{
			char *pin;
			inbuf[BufSize] = 0;
			switch (regx.match(inbuf))
			{
			case MATCH:
				for (pin = inbuf; *pin != 0 && *pin != '\n'; 
				     pin++) ;
				if (*pin == '\n') *pin = 0;
				fprintf(stdout, "%s\n", inbuf);
				break;
			case NOMATCH:
				break;
			default:
				ERROR("match failed.", NOTOK);
				return(2);
			}
		}
		fclose(infd);
	}
	return(0);
}

main(int argc, char **argv)
{
	exit(submain(argc, argv));
}
