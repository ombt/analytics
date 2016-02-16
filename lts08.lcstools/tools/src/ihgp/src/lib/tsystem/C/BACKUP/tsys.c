/* headers */
#include <stdio.h>

/* extern */
extern tsystem();

/* test function */
main(argc, argv)
int argc;
char **argv;
{
	int arg, tmout;
	char cmdbuf[BUFSIZ];

	if (argc < 3)
	{
		fprintf(stderr, "%s tmout_in_secs command \n", argv[0]);
		return(2);
	}
	else
	{
		cmdbuf[0] = 0;
		tmout = atoi(argv[1]);
		for (arg = 2; arg < argc; arg++)
		{
			strcat(cmdbuf, argv[arg]);
			strcat(cmdbuf, " ");
		}
		return(tsystem(cmdbuf, tmout));
	}
}
