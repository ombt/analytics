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
class SharedMemory {
public:
	// constructors and destructor
	SharedMemory();
	SharedMemory(key_t, size_t, int = 0666, void * = NULL);
	SharedMemory(const SharedMemory &);
	~SharedMemory();

	// assignment operator
	SharedMemory &operator=(const SharedMemory &);

	// access operator
	operator void *() const;
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
	void *pamem;
	void *pmem;
	int original;
};

#endif
