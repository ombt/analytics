#ifndef __PSEM_H
#define __PSEM_H
// a semaphore class based on POSIX semaphores

// system headers
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <semaphore.h>
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
	Semaphore(const char *, int = 0666, unsigned int = 1);
	Semaphore(const Semaphore &);
	~Semaphore();

	// assignment
	Semaphore &operator=(const Semaphore &);

	// semaphore operations
	int P(int);
	int V();

	// other operations
	void setFileName(const char *);
	const char *getFileName() const;
	States getState() const;
	void cleanup();
	void newFileName(const char *);

	// remove lock file after done
	static void removeLockFile(const char *);

protected:
	// internal data
	const char *fname;
	States state;
	sem_t *psem;
	int mode;
	unsigned int value;
};

#endif
