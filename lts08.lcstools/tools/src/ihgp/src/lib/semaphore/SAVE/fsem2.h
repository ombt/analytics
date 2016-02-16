#ifndef __FSEM2_H
#define __FSEM2_H
// a semaphore class based on file-locking, uses fcntl.

// system headers
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/uio.h>
#include <fcntl.h>
#include <signal.h>
#include <iostream.h>
#include <string.h>
#include <errno.h>

// local headers
#include "returns.h"
#include "debug.h"

// class definitions
class SemaphoreFile {
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

	// remove lock file after done
	static void removeLockFile(const char *);

protected:
	// utility functions
	int decrementCounts() const;
	int incrementCounts() const;
	int updateCounts(int) const;
	void unlinkFiles() const;

protected:
	// internal data
	const char *fname;
	States state;
	int fd;
	int countsupdated;
};

#endif
