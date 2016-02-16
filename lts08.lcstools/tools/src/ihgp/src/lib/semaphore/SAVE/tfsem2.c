// test semaphore junk

// headers
#include "fsem2.h"

// main entry point
main(int argc, char **argv)
{
	if (argc != 5)
	{
		cerr << "usage: tfsem filename wait_before_P wait_for_semaphore holdtime" << endl;
		return(2);
	}

	char *fname = argv[1];

	int waittime1 = atoi(argv[2]);
	if (waittime1 < 0) waittime1 = 0;

	int waittime2 = atoi(argv[3]);

	int holdtime = atoi(argv[4]);
	if (holdtime < 0) holdtime = 0;

	cout << "creating SemaphoreFile(" << fname << ") ..." << endl;
	SemaphoreFile fsem(fname);

	cout << "running sleep(" << waittime1 << ") before P() ..." << endl;
	sleep(waittime1);

	cout << "running P(" << waittime2 << ") ..." << endl;
	switch (fsem.P(waittime2))
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
