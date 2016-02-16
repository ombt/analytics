// source for file-based semaphores

// headers
#include "fsem.h"

// constructors and destructor
SemaphoreFile::SemaphoreFile(const char *fnm):
	fname(NULL), state(Unknown), fd(-1)
{
	// allocate file name, etc.
	if (fnm != NULL && *fnm != '\0')
		newFileName(fnm);

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL) ||
		   (state != Unknown && fname != NULL));
}

SemaphoreFile::SemaphoreFile(const SemaphoreFile &src):
	fname(NULL), state(Unknown), fd(-1)
{
	// allocate filename, etc.
	if (src.fname != NULL && *src.fname != '\0')
		newFileName(src.fname);

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL) ||
		   (state != Unknown && fname != NULL));
}

SemaphoreFile::~SemaphoreFile()
{
	// release semaphore 
	if (state == Owner)
		MustBeTrue(V() == OK);

	// release file name
	if (fname != NULL) cleanup();

	// sanity checks
	MustBeTrue(state == Unknown && fname == NULL);
}

// assignment operation
SemaphoreFile &
SemaphoreFile::operator=(const SemaphoreFile &rhs)
{
	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL) ||
		   (state != Unknown && fname != NULL));

	// check for self-assignment
	if (this == &rhs)
		return(*this);

	// check if semaphore is owned, if so, release it.
	if (state == Owner)
		MustBeTrue(V() == OK);

	// release old data
	cleanup();

	// copy data
	if (rhs.fname != NULL && *rhs.fname != '\0')
		newFileName(rhs.fname);

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL) ||
		   (state != Unknown && fname != NULL));

	// all done
	return(*this);
}

// semaphore operations
int
SemaphoreFile::P(int maxtime)
{
	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL) ||
		   (state != Unknown && fname != NULL));

	// check state
	if (state == Unknown)
		return(NOTOK);

	// check maxtime value. if maxtime==0, then do not
	// wait at all. if maxtime < 0, then block (i.e., wait
	// indefinitely); and if maxtime > 0, wait for maxtime.
	//
	if (maxtime < 0)
		maxtime = INT_MAX;

	// try to get semaphore onwership
	int t;
	for (t = 0; t <= maxtime; t++)
	{
		// try to create semaphore file
		fd = creat(fname, 0);
		if (fd >= 0)
			break;
		else if (fd < 0 && errno != EACCES)
		{
			state = Error;
			return(NOTOK);
		}

		// sleep for one second
		if (t < maxtime)
			sleep(1);
	}

	// check if we timed out
	if (t > maxtime)
	{
		state = Blocked;
		return(EAGAIN);
	}

	// we own the semaphore file, just close it for now.
	state = Owner;
	close(fd);

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL) ||
		   (state != Unknown && fname != NULL));

	// just return
	return(OK);
}

int
SemaphoreFile::V()
{
	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL) ||
		   (state != Unknown && fname != NULL));

	// check state
	if (state == Unknown)
		return(NOTOK);

	// delete file
	(void)unlink(fname);
	state = Initialized;
	fd = -1;

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL) ||
		   (state != Unknown && fname != NULL));

	// just return
	return(OK);
}

// other operations
void
SemaphoreFile::setFileName(const char *newfn)
{
	// release any locks
	(void)V();

	// release old data
	cleanup();

	// copy data
	if (newfn != NULL && *newfn != '\0')
		newFileName(newfn);

	// all done
	return;
}

void
SemaphoreFile::newFileName(const char *nfn)
{
	char *tmpfn = new char [strlen(nfn)+1];
	MustBeTrue(tmpfn != NULL);
	strcpy(tmpfn, nfn);
	fname = tmpfn;
	state = Initialized;
	return;
}

const char *
SemaphoreFile::getFileName() const
{
	return(fname);
}

SemaphoreFile::States
SemaphoreFile::getState() const
{
	return(state);
}

void
SemaphoreFile::cleanup()
{
	if (fname != NULL)
		delete [] fname;
	fname = NULL;
	state = Unknown;
	fd = -1;
	return;
}

// remove lock file
void
SemaphoreFile::removeLockFile(const char *lfnm)
{
	if (lfnm != NULL && *lfnm != '\0')
		unlink(lfnm);
	return;
}
