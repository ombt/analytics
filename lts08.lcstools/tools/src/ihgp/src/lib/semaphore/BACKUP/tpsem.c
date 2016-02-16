// test semaphore junk

// headers
#include "psem.h"

// main entry point
main(int argc, char **argv)
{
	if (argc != 4)
	{
		cerr << "usage: tpsem filename waittime holdtime" << endl;
		return(2);
	}

	char *fname = argv[1];

	int waittime = atoi(argv[2]);
	int holdtime = atoi(argv[3]);
	if (holdtime < 0) holdtime = 0;

	cout << "running SemaphoreFile(" << fname << ") ..." << endl;
	Semaphore psem(fname);

	cout << "running P(" << waittime << ") ..." << endl;
	switch (psem.P(waittime))
	{
	case OK:
		cout << "running sleep(" << holdtime << ") ..." << endl;
		sleep(holdtime);
		cout << "running V() ... " << endl;
		psem.V();
		break;
	case EAGAIN:
		cout << "timed out waiting for semaphore ..." << endl;
		break;
	default:
		cout << "some type of failure ..." << endl;
		break;
	}

	return(0);
}
