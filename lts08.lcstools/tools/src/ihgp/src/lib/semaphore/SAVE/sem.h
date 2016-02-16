#ifndef __SEM_H
#define __SEM_H
// a semaphore class based on POSIX semaphores

// system headers
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <iostream.h>
#include <string.h>
#include <errno.h>

// local headers
#include "returns.h"
#include "debug.h"

// class definitions
class Semaphore {
public:
	// internal enumerations
	enum States {
		Unknown, Initialized, Blocked, Owner, Error
	};

	// constructors and destructor
	SemaphoreFile(const char *);
	SemaphoreFile(const SemaphoreFile &);
	~SemaphoreFile();

	// assignment
	SemaphoreFile &operator=(const SemaphoreFile &);

	// semaphore operations
	int P(int);
	int V();

	// other operations
	void setFileName(const char *);
	const char *getFileName() const;
	States getState() const;
	void cleanup();
	void newFileName(const char *);

protected:
	// internal data
	const char *fname;
	States state;
	int fd;
};

#endif
