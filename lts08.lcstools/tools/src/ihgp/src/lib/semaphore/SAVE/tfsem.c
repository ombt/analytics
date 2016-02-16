// test semaphore junk

// headers
#include "fsem.h"

// main entry point
main(int argc, char **argv)
{
	if (argc != 4)
	{
		cerr << "usage: tfsem filename waittime holdtime" << endl;
		return(2);
	}

	char *fname = argv[1];

	int waittime = atoi(argv[2]);
	int holdtime = atoi(argv[3]);
	if (holdtime < 0) holdtime = 0;

	cout << "running SemaphoreFile(" << fname << ") ..." << endl;
	SemaphoreFile fsem(fname);

	cout << "running P(" << waittime << ") ..." << endl;
	switch (fsem.P(waittime))
	{
	case OK:
		cout << "running sleep(" << holdtime << ") ..." << endl;
		sleep(holdtime);
		cout << "running V() ... " << endl;
		fsem.V();
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
