#ifndef __VSHM4_H
#define __VSHM4_H
// header for SYSTEM-V shared memory class. 

// unix headers
#include <stdlib.h>
#include <iostream.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

// local headers
#include "debug.h"
#include "returns.h"

// class for shared memory
template <class DataType> class SharedMemory {
public:
	// constructors and destructor
	SharedMemory():
		shmid(-1), key(-1), size(0), mode(0), nelem(0),
		pamem(NULL), pmem(NULL), pdmem(NULL), original(0)
	{
		// nothing to do
	}
	SharedMemory(key_t k, int ne, int m = 0666, DataType *pa = NULL):
		shmid(-1), key(k), size(ne*sizeof(DataType)), 
		mode(m), nelem(ne), pamem(pa), pmem(NULL), 
		pdmem(NULL), original(1)
	{
		// size and number of elements must be greater than 0
		MustBeTrue(nelem > 0 && size > 0);
	
		// get shared memory and create it, if necessary.
		shmid = shmget(key, size, IPC_CREAT|mode);
		MustBeTrue(shmid >= 0);

		// attach memory to process space.
		//
		// NOTE: something to note here. if a process attaches the 
		// same shared memory segment more than once, then the 
		// shared memory segment is mapped more than once on the 
		// process memory space, that is, you will have the same 
		// memory segment accessible from the same process using 
		// more than ONE address !!!
		// 
		if (pamem == (DataType *)-1)
			pmem = shmat(shmid, NULL, 0);
		else
			pmem = shmat(shmid, pamem, 0);
		MustBeTrue(pmem != (void *)NOTOK);

		// now allocate one more time to call constructor. each
		// item is allocated individually since if an array is 
		// allocated, extra bytes are added by the compiler to save
		// information specific to the array. For example, if
		// the address 0xf000 is passed to the new (placement)
		// operator, and an array is requested, them the address
		// return by new is NOT 0xf000, but instead the address
		// 0xf008 is returned. the extra bytes are for storing
		// array size, etc.
		//
		for (int i = 0; i < nelem; i++)
		{
			unsigned long p = (long)pmem+i*sizeof(DataType);
			pdmem = new ((void *)p) DataType;
			MustBeTrue(pdmem != (DataType *)NULL);
			MustBeTrue((void *)p == (void *)pdmem);
		}
		pdmem = (DataType *)pmem;
	}
	SharedMemory(const SharedMemory &src):
		shmid(src.shmid), key(src.key), size(src.size), 
		mode(src.mode), nelem(src.nelem), 
		pamem(src.pamem), pmem(src.pmem), 
		pdmem(src.pdmem), original(0)
	{
		// we do nothing since this is a copy.
	}

	~SharedMemory()
	{
		// check if this is an original. if so, then detach
		// and clean-up. if not, then do nothing
		//
		if (original && pmem != NULL)
		{
			// the destructor is called explicitly
			// since we cannot call delete for memory
			// which is not from the heap (shared memory).
			//
			for (int i = 0; i < nelem; i++)
			{
				pdmem->DataType::~DataType();
			}
			(void) shmdt((char *)pmem);
		}
		pmem = NULL;
		shmid = -1;
	}

	// assignment operator
	SharedMemory<DataType> &operator=(const SharedMemory &rhs)
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
		pdmem = rhs.pdmem;
		nelem = rhs.nelem;
		original = 0;

		// all done
		return(*this);
	}

	// access operators
	operator DataType *() const {
		return(pdmem);
	}
	DataType *operator->() const {
		MustBeTrue(pdmem != NULL);
		return(pdmem);
	}
	DataType &operator*() {
		MustBeTrue(pdmem != NULL);
		return(*pdmem);
	}
	DataType &operator*() const {
		MustBeTrue(pdmem != NULL);
		return(*pdmem);
	}
	DataType &operator[](int i) {
		MustBeTrue(pdmem != NULL);
		MustBeTrue(0 <= i && i < nelem);
		return(pdmem[i]);
	}
	DataType &operator[](int i) const {
		MustBeTrue(pdmem != NULL);
		MustBeTrue(0 <= i && i < nelem);
		return(pdmem[i]);
	}

	// return shared memory id
	int getShmId() const {
		return(shmid);
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
	int shmid;
	key_t key;
	size_t size;
	int mode;
	int nelem;
	void *pamem;
	void *pmem;
	DataType *pdmem;
	int original;
};

#endif

