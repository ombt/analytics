// test case for shared-memory/semaphore code.

// headers
#include <stdlib.h>
#include <iostream.h>
#include <string.h>
#include "vsem.h"
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
	key_t shmkey = -1;
	key_t rdkey = -1;
	key_t wrkey = -1;
	int shmid = -1;
	int lastuser = 0;

	// check number of arguments
	if (argc != 4 && argc != 6)
	{
		cout << "usage: t2 shmkey readkey writekey [rd_no wr_no]" << endl;
		return(2);
	}

	// try/catch block for everything
	try {
		// get keys
		shmkey = atoi(argv[1]);
		rdkey = atoi(argv[2]);
		wrkey = atoi(argv[3]);

		// number of readers and writers
		int rd_no = 0;
		int wr_no = 1;
		if (argc == 6)
		{
			rd_no = atoi(argv[4]);
			wr_no = atoi(argv[5]);
		}

		// attach to shared memory
		SharedMemory<Dummy> shm(shmkey);
		shmid = shm.getShmId();

		// check if we own the shared memory
		if (shm.isOwner())
		{
			// not the last user
			lastuser = 0;

			// get semaphore
			Semaphore writer(wrkey, 0666, wr_no);
			Semaphore reader(rdkey, 0666, rd_no);

			// gain ownership
			MustBeTrue(writer.P(-1) == OK);

			// get length of initial msg
			int ilen = strlen(shm->buf);
			ilen--;

			// let reader proceed
			MustBeTrue(reader.V() == OK);

			for (char c = 'a'; c <= 'z'; c++)
			{
				// gain ownership
				MustBeTrue(writer.P(-1) == OK);

				// write to shared memory
				shm->buf[ilen] = c;
				shm->buf[ilen+1] = '\0';
				ilen++;

				// release ownership
				MustBeTrue(reader.V() == OK);
			}

			// get permission to write 
			MustBeTrue(writer.P(-1) == OK);

			// write to shared memory
			strcpy(shm->buf, "all done");

			// let reader proceed
			MustBeTrue(reader.V() == OK);
		}
		else
		{
			// is the last user
			lastuser = 1;

			// get semaphore
			Semaphore writer(wrkey, 0666, wr_no);
			Semaphore reader(rdkey, 0666, rd_no);

			// reader process
			for (int done=0; !done; )
			{
				// get permission to read
				MustBeTrue(reader.P(-1) == OK);

				// read shared memory
				cout << shm->buf << endl;

				// are we done
				if (strcmp(shm->buf, "all done") == 0)
					done = 1;

				// let writer write
				MustBeTrue(writer.V() == OK);

				// relax, take a break.
				sleep(1);
			}

		}
	}
	catch (const char *pe)
	{
		cout << pe << endl;
		return(2);
	}

	// delete resources
	if (lastuser)
	{
		SharedMemory<Dummy>::removeSharedMemory(shmid);
		Semaphore::removeLockFile(rdkey);
		Semaphore::removeLockFile(wrkey);
	}

	// all done
	return(0);
}

