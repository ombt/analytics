// functions for system V shared memory class

// headers
#include "vshm2.h"

// constructors and destuctor
template <class DataType>
SharedMemory<DataType>::SharedMemory():
	shmid(-1), key(-1), size(0), mode(0), nelem(0),
	pamem(NULL), pmem(NULL), original(0)
{
	// nothing to do
}

template <class DataType>
SharedMemory<DataType>::SharedMemory(key_t k, int ne, int m, DataType *pa):
	shmid(-1), key(k), size(ne*sizeof(DataType)), mode(m), nelem(ne),
	pamem(pa), pmem(NULL), original(1)
{
	// size and number of elements must be greater than 0
	MustBeTrue(nelem > 0 && size > 0);

	// get shared memory and create it, if necessary.
	shmid = shmget(key, size, IPC_CREAT|mode);
	MustBeTrue(shmid >= 0);

	// attach memory to process space.
	//
	// NOTE: something to note here. if a process attaches the same shared
	// memory segment more than once, then the shared memory segment
	// is mapped more than once on the process memory space, that is,
	// you will have the same memory segment accessible from the same 
	// process using more than ONE address !!!
	// 
	if (pamem == (DataType *)-1)
		pmem = (DataType *)shmat(shmid, NULL, 0);
	else
		pmem = (DataType *)shmat(shmid, pamem, 0);
	MustBeTrue(pmem != (DataType *)NOTOK);
}

template <class DataType>
SharedMemory<DataType>::SharedMemory(const SharedMemory &src):
	shmid(src.shmid), key(src.key), size(src.size), 
	mode(src.mode), nelem(src.nelem), 
	pamem(src.pamem), pmem(src.pmem), original(0)
{
	// we do nothing since this is a copy.
}

template <class DataType>
SharedMemory<DataType>::~SharedMemory()
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
template <class DataType>
SharedMemory<DataType> &
SharedMemory<DataType>::operator=(const SharedMemory &rhs)
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
	nelem = rhs.nelem;
	original = 0;

	// all done
	return(*this);
}

// delete shared memory segment
template <class DataType>
void
SharedMemory<DataType>::removeSharedMemory(int shmid)
{
	if (shmid >= 0)
		(void) shmctl(shmid, IPC_RMID, 0);
	return;
}

