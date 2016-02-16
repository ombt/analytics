// functions for system V shared memory class

// headers
#include "vshm.h"

// constructors and destuctor
SharedMemory::SharedMemory():
	shmid(-1), key(-1), size(0), mode(0), 
	pamem(NULL), pmem(NULL), original(0)
{
	// nothing to do
}

SharedMemory::SharedMemory(key_t k, size_t s, int m, void *pa):
	shmid(-1), key(k), size(s), mode(m), 
	pamem(pa), pmem(NULL), original(1)
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

SharedMemory::SharedMemory(const SharedMemory &src):
	shmid(src.shmid), key(src.key), size(src.size), mode(src.mode), 
	pamem(src.pamem), pmem(src.pmem), original(0)
{
	// we do nothing since this is a copy.
}

SharedMemory::~SharedMemory()
{
	// check if this is an original. if so, then detach
	// and clean-up. if not, then do nothing
	//
	if (original && pmem != NULL)
		(void) shmdt((char *)pmem);
	pmem = NULL;
	shmid = -1;
}

// assignment operator
SharedMemory &
SharedMemory::operator=(const SharedMemory &rhs)
{
	// can not assign to an original object.
	MustBeTrue(!original);

	// check for self-assignment
	if (this == &rhs)
		return(*this);

	// copy all the data
	shmid = rhs.shmid;
	key = rhs.key;
	size = rhs.size;
	mode = rhs.mode;
	pamem = rhs.pamem;
	pmem = rhs.pmem;
	original = 0;

	// all done
	return(*this);
}

// access operators
SharedMemory::operator void *() const
{
	return(pmem);
}

// delete shared memory segment
void
SharedMemory::removeSharedMemory(int shmid)
{
	if (shmid >= 0)
		(void) shmctl(shmid, IPC_RMID, 0);
	return;
}

