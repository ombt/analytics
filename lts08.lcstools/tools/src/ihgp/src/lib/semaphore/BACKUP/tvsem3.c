// test semaphore junk

// headers
#include "vsem.h"

// main entry point
main(int argc, char **argv)
{
	if (argc != 4 && argc != 3)
	{
		cerr << "usage: tvsem key [ P waittime | V }" << endl;
		return(2);
	}

	key_t key = atoi(argv[1]);
	char oper = argv[2][0];
	int waittime = 0;
	if (argc == 4)
		waittime = atoi(argv[3]);

	cout << "running Semaphore(" << key << ") ..." << endl;
	try {
		Semaphore vsem(key);
		if (oper == 'P' || oper == 'p')
		{
			cout << "running P(" << waittime << ") ..." << endl;
			vsem.P(waittime);
		}
		else if (oper == 'V' || oper == 'v')
		{
			cout << "running V() ..." << endl;
			vsem.V();
		}
		else
		{
			cout << "unknown operation: " << oper << endl;
		}
	}
	catch (const char *pe)
	{
		ERRORD("semaphore failed.", pe, errno);
	}
	return(0);
}
