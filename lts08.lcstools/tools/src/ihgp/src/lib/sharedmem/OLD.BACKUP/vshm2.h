#ifndef __VSHM_H
#define __VSHM_H
// header for SYSTEM-V shared memory class

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
	SharedMemory();
	SharedMemory(key_t, int, int = 0666, DataType * = NULL);
	SharedMemory(const SharedMemory &);
	~SharedMemory();

	// assignment operator
	SharedMemory &operator=(const SharedMemory &);

	// access operators
	operator DataType *() const {
		return(pmem);
	}
	DataType &operator*() {
		MustBeTrue(pmem != NULL);
		return(*pmem);
	}
	DataType &operator*() const {
		MustBeTrue(pmem != NULL);
		return(*pmem);
	}
	DataType &operator[](int i) {
		MustBeTrue(pmem != NULL);
		MustBeTrue(0 <= i && i < nelem);
		return(pmem[i]);
	}
	DataType &operator[](int i) const {
		MustBeTrue(pmem != NULL);
		MustBeTrue(0 <= i && i < nelem);
		return(pmem[i]);
	}

	// return shared memory id
	int getShmId() const {
		return(shmid);
	}

	// delete shared memory segment
	static void removeSharedMemory(int);

protected:
	// internal data
	int shmid;
	key_t key;
	size_t size;
	int mode;
	int nelem;
	DataType *pamem;
	DataType *pmem;
	int original;
};

#endif
