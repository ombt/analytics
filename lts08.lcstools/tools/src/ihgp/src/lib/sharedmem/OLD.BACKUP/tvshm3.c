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
	if (argc != 4)
	{
		usage(argv[0]);
		return(2);
	}

	key_t key = atoi(argv[1]);
	size_t size = atoi(argv[2]);
	void *pamem = (void *)atol(argv[3]);
	int saveid = -1;

	DUMPS("standard shared memory tests ...");
	try {
		SharedMemory shm(key, size, 0666, pamem);
		SharedMemory shm2;
		try {
			cerr << "over-writing original ";
			shm = shm2;
			DUMPS("OVER-WRITE TEST FAILED !!!");
			MustBeTrue(0);
		}
		catch (const char *pe)
		{
			cerr << pe << endl;
			DUMPS("OVER-WRITE TEST PASSED !!!");
		}
		saveid = shm.getShmId();
		try {
			long *pl = (long *)(void *)shm;
			*pl = 1;
			DUMP(*pl);
		}
		catch (const char *pe)
		{
			ERRORD("accessing memory failed.", pe, errno);
			return(2);
		}
	}
	catch (const char *pe)
	{
		ERROR("constructor failed.", errno);
		return(2);
	}

#if 0
	DUMPS("sleeping for 5 seconds, before removing ...");
	sleep(5);
#endif
	SharedMemory::removeSharedMemory(saveid);

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
TRACE();

#if 0
	DUMPS("sleeping for 5 seconds, before removing ...");
	sleep(5);
#endif
TRACE();
	SharedMemory::removeSharedMemory(saveid);
TRACE();


	return(0);
}
