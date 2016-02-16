// test semaphore junk

// headers
#include "vsem.h"

// main entry point
main(int argc, char **argv)
{
	if (argc != 4)
	{
		cerr << "usage: tvsem key waittime holdtime" << endl;
		return(2);
	}

	key_t key = atoi(argv[1]);
	int waittime = atoi(argv[2]);
	int holdtime = atoi(argv[3]);
	if (holdtime < 0) holdtime = 0;

	cout << "running Semaphore(" << key << ") ..." << endl;
	try {
		Semaphore vsem(key);

		cout << "running P(" << waittime << ") ..." << endl;
		try {
			switch (vsem.P(waittime))
			{
			case OK:
				cout << "running sleep(" << holdtime << ") ..." << endl;
				sleep(holdtime);
				cout << "running V() ... " << endl;
				try {
					vsem.V();
				}
				catch (const char *pe)
				{
					ERRORD("V() failed.", pe, errno);
				}
				break;
			case EAGAIN:
				cout << "timed out waiting for semaphore ..." << endl;
				break;
			default:
				cout << "some type of failure ..." << endl;
				break;
			}
		}
		catch (const char *pe)
		{
			ERRORD("P() failed.", pe, errno);
		}
	}
	catch (const char *pe)
	{
		ERRORD("constructor failed.", pe, errno);
	}
	return(0);
}
