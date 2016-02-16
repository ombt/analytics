// test case for shared-memory/semaphore code.

// headers
#include <stdlib.h>
#include <iostream.h>
#include <string.h>
#include "fsem.h"
#include "vshm5.h"

// dummy class
struct Dummy {
	Dummy() {
		strcpy(buf, "I'm initialized !!!  ");
	}
	~Dummy() {
	}
	char buf[BUFSIZ];
};

// main entry into test case
int
main(int argc, char **argv)
{
	// check number of arguments
	if (argc != 2)
	{
		cout << "usage: t1 key" << endl;
		return(2);
	}

	// try/catch block for everything
	try {
		// attach to shared memory
		key_t key = atoi(argv[1]);
		SharedMemory<Dummy> shm(key);
		int shmid = shm.getShmId();

		// get semaphore
		SemaphoreFile sem(argv[1]);

		// check if we own the shared memory
		if (shm.isOwner())
		{
			// gain ownership
			MustBeTrue(sem.P(-1) == OK);

			// get length of initial msg
			int ilen = strlen(shm->buf);

			// release ownship
			MustBeTrue(sem.V() == OK);

			// sleep for a bit to synchronize
			sleep(5);

			for (char c = 'a'; c <= 'z'; c++)
			{
				// gain ownership
				MustBeTrue(sem.P(-1) == OK);

				// write to shared memory
				shm->buf[ilen-1] = c;

				// release ownership
				MustBeTrue(sem.V() == OK);

				// sleep a bit
				sleep(1);
			}

			// gain ownership
			MustBeTrue(sem.P(-1) == OK);

			// write to shared memory
			strcpy(shm->buf, "all done");

			// release ownership
			MustBeTrue(sem.V() == OK);
		}
		else
		{
			// reader process
			for (int done=0; !done; )
			{
				// gain ownership
				MustBeTrue(sem.P(-1) == OK);

				// read shared memory
				cout << shm->buf << endl;

				// are we done
				if (strcmp(shm->buf, "all done") == 0)
					done = 1;

				// release ownership
				MustBeTrue(sem.V() == OK);

				// sleep a bit
				sleep(1);
			}

			// delete shared memory
			SharedMemory<Dummy>::removeSharedMemory(shmid);
		}
	}
	catch (const char *pe)
	{
		cout << pe << endl;
		return(2);
	}

	// all done
	return(0);
}

