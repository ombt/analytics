// test sys-v shared memory class

// headers
#include <unistd.h>
#include "vshm3.h"

class Test {
public:
	// member functions
	Test(const char *ps) {
		DUMPS("Test(const char *) called !!!");
		strcpy(buf, ps);
		DUMP((void *)this);
	}
	Test(const Test &src) {
		DUMPS("Test(const Test &) called !!!");
		strcpy(buf, src.buf);
		DUMP((void *)this);
	}
	~Test() {
		DUMPS("~Test() called !!!");
		DUMP((void *)this);
	}

	// data
	char buf[BUFSIZ];
};

void
usage(const char *cmd)
{
	cout << "usage: " << cmd << " key size attach_address" << endl;
	return;
}

main(int argc, char **argv)
{
TRACE();
	if (argc != 4)
	{
TRACE();
		usage(argv[0]);
TRACE();
		return(2);
	}

TRACE();
	key_t key = atoi(argv[1]);
TRACE();
	size_t size = atoi(argv[2]);
TRACE();
	void *pamem = (void *)atol(argv[3]);
TRACE();
	int saveid = -1;
	int saveid2 = -1;
TRACE();

	DUMPS("standard shared memory tests ...");
TRACE();
	try {
TRACE();
		SharedMemory shm(key, size, 0666, pamem);
TRACE();
		saveid = shm.getShmId();
TRACE();
		SharedMemory shmk(key+1, 2*size, 0666, NULL);
TRACE();
		saveid2 = shmk.getShmId();
TRACE();
		try {
TRACE();
			long *pl = (long *)(void *)shm;
TRACE();
			*pl = 1;
TRACE();
			DUMP(*pl);
			SharedMemory shm2(shm);
			DUMP(++(*(long *)(void *)shm2));
			SharedMemory shm3(shm2);
			DUMP(++(*(long *)(void *)shm3));
			SharedMemory shm4(shm3);
			DUMP(++(*(long *)(void *)shm4));
			SharedMemory shm5(shm4);
			DUMP(++(*(long *)(void *)shm5));
			SharedMemory shm6;
TRACE();
			shm6 = shm;
			DUMP(++(*(long *)(void *)shm6));
			system("ipcs -bmo");
TRACE();
			sleep(5);
TRACE();
		}
		catch (const char *pe)
		{
TRACE();
			ERRORD("accessing memory failed.", pe, errno);
TRACE();
			return(2);
		}
	}
	catch (const char *pe)
	{
TRACE();
		ERROR("constructor failed.", errno);
TRACE();
		return(2);
	}

	DUMPS("sleep(3) ...");
	sleep(3);
TRACE();
	SharedMemory::removeSharedMemory(saveid);
TRACE();

	DUMPS("shared memory allocation tests ...");
	try {
TRACE();
		SharedMemory shm(key, size, 0666, pamem);
DUMP((void *)shm);
TRACE();
		try {
TRACE();
			Test *pt = new ((void *)shm) Test("eat me !!!");
DUMP((void *)pt);
TRACE();
			MustBeTrue(pt != NULL);
TRACE();
			DUMP(pt->buf);
TRACE();
			try {
TRACE();
				// the following does not work
				// since you are trying to delete
				// shared-memory, not heap memory.
				// must call destructor directly.
				//
				// delete pt;
				//
				pt->Test::~Test();
TRACE();
			}
			catch (...)
			{
TRACE();
				DUMPS("destructor failed !!! OK.");
			}
TRACE();
		}
		catch (const char *pe)
		{
TRACE();
			ERRORD("funny new failed !!!", pe, errno);
TRACE();
			return(2);
		}
TRACE();
		saveid = shm.getShmId();
TRACE();
	}
	catch (const char *pe)
	{
TRACE();
		ERROR("constructor failed.", errno);
TRACE();
		return(2);
	}

	DUMPS("sleep(3) ...");
	sleep(3);
TRACE();
	SharedMemory::removeSharedMemory(saveid);
TRACE();
	SharedMemory::removeSharedMemory(saveid2);
TRACE();


	return(0);
}
