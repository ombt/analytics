#ifndef __VSHM3_H
#define __VSHM3_H
// header for reference-counted SYSTEM-V shared memory class

// unix headers
#include <stdlib.h>
#include <iostream.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

// local headers
#include "debug.h"
#include "returns.h"

// forward declarations
class SharedMemory;
class SharedMemoryData;

// class for shared memory data, reference-counted
class SharedMemoryData {
	// friend class
	friend class SharedMemory;

private:
	// constructors and destructor
	SharedMemoryData(key_t k, size_t s, int m, void *pa):
		shmid(-1), key(k), size(s), mode(m), 
		pamem(pa), pmem(NULL),
		counter(0)
	{
		if (key > 0)
		{
			// get shared memory and create it, if necessary.
			shmid = shmget(key, size, IPC_CREAT|mode);
			MustBeTrue(shmid >= 0);

			// attach memory to process space
			if (pamem == (void *)-1)
				pmem = shmat(shmid, NULL, 0);
			else
				pmem = shmat(shmid, pamem, 0);
			MustBeTrue(pmem != (void *)NOTOK);
		}
	}
	~SharedMemoryData()
	{
		counter = 0;
		if (pmem != NULL)
			(void) shmdt((char *)pmem);
		pmem = NULL;
		shmid = -1;
	}

	// counter operations
	int increment()
	{
		return(++counter);
	}
	int decrement()
	{
		return(--counter);
	}
	int getCounter() const
	{
		return(counter);
	}
	int setCounter(int c)
	{
		counter = c;
		return(counter);
	}

	// data for shared memory segment
	int shmid;
	key_t key;
	size_t size;
	int mode;
	void *pamem;
	void *pmem;

	// reference counter 
	int counter;

};

// class for shared memory
class SharedMemory {
public:
	// constructors and destructor
	SharedMemory():
		prep(new SharedMemoryData(-1, -1, 0, NULL)) {
		MustBeTrue(prep != NULL);
		prep->increment();
	}
	SharedMemory(key_t k, size_t s, int m = 0666, void *pa = NULL):
		prep(new SharedMemoryData(k, s, m, pa)) {
		MustBeTrue(prep != NULL);
		prep->increment();
	}
	SharedMemory(const SharedMemory &p):
		prep(p.prep) {
		MustBeTrue(prep != NULL);
		prep->increment();
	}
	~SharedMemory() {
		if (prep->decrement() <= 0)
			delete prep;
		prep = NULL;
	}

	// assignment
	SharedMemory &operator=(const SharedMemory &rhs) {
		rhs.prep->increment();
		if (prep->decrement() <= 0)
		{
			delete prep;
			prep = NULL;
		}
		prep = rhs.prep;
		MustBeTrue(prep != NULL);
		return(*this);
	}

	// pointer operators
	operator void *() const {
		MustBeTrue(prep != NULL);
		return(prep->pmem);
	}
	int getShmId() const
	{
		MustBeTrue(prep != NULL);
		return(prep->shmid);
	}

	// delete shared memory segment
	static void removeSharedMemory(int shmid)
	{
		if (shmid >= 0)
			(void) shmctl(shmid, IPC_RMID, 0);
		return;
	}

protected:
	// internal data
	SharedMemoryData *prep;
};

#endif

