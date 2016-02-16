// test sys-v shared memory class

// headers
#include <unistd.h>
#include "vshm4.h"

void
usage(const char *cmd)
{
	cout << "usage: " << cmd << " key nelem attach_address" << endl;
	return;
}

struct Test {
	Test(): s(0), l(0)
	{
		DUMPS("calling Test::Test() ...");
	}
	~Test()
	{
		DUMPS("calling Test::~Test() ...");
	}
	short s;
	long l;
	short buf[100];
};

main(int argc, char **argv)
{
	if (argc != 4)
	{
		usage(argv[0]);
		return(2);
	}

	key_t key = atoi(argv[1]);
	int nelem = atoi(argv[2]);
	Test *pamem = (Test *)atol(argv[3]);
	int saveid = -1;

	try {
		SharedMemory<Test> shm(key, nelem, 0666, pamem);
		SharedMemory<Test> shm2;
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
			int idx;
			for (idx = 0; idx < nelem; idx++)
			{
				shm[idx].s = idx;
				shm[idx].l = idx;
			}
			for (idx = 0; idx < nelem; idx++)
			{
				DUMP(shm[idx].s);
				DUMP(shm[idx].l);
			}
			for (idx = 0; idx < nelem; idx++)
			{
				DUMP(((Test *)shm + idx)->s);
				DUMP(((Test *)shm + idx)->l);
			}
			try {
				DUMP(shm[idx].s);
				DUMPS("OOR INDEX TEST FAILED !!!");
				MustBeTrue(idx < nelem);
			}
			catch (const char *pe) {
				cerr << pe << endl;
				DUMPS("OOR INDEX TEST PASSED !!!");
			}
		}
		catch (const char *pe)
		{
			ERRORD("accessing memory failed.", pe, errno);
			return(2);
		}
		try {
			DUMP(shm[0].s);
			DUMP(shm[0].l);
DUMPS("creating 4 more shms !!!");
			SharedMemory<Test> shm3(shm);
			shm3[0].s += 1;
			shm3[0].l += 1;
			DUMP(shm3[0].s);
			DUMP(shm3[0].l);
			SharedMemory<Test> shm4(shm);
			shm4[0].s += 2;
			shm4[0].l += 2;
			DUMP(shm4[0].s);
			DUMP(shm4[0].l);
			SharedMemory<Test> shm5(shm);
			shm5[0].s += 3;
			shm5[0].l += 3;
			DUMP(shm5[0].s);
			DUMP(shm5[0].l);
			SharedMemory<Test> shm6(shm);
			DUMP(shm6[0].s);
			DUMP(shm6[0].l);
DUMPS("DONE creating 4 more shms !!!");
			system("ipcs -bmo");
			sleep(5);
		}
		catch (const char *pe) {
			ERROR("constuctor shm3 failed ...", errno);
		}
		try {
			DUMP(shm[0].s);
			DUMP(shm[0].l);
			SharedMemory<Test> shm7(shm);
			DUMP(shm7[0].s);
			DUMP(shm7[0].l);
		}
		catch (const char *pe) {
			ERROR("DUMP after shm3 failed !!!", errno);
		}
	}
	catch (const char *pe)
	{
		ERROR("constructor failed.", errno);
		return(2);
	}

	DUMPS("sleeping for 5 seconds, before removing ...");
	sleep(5);
	SharedMemory<long>::removeSharedMemory(saveid);

	return(0);
}
