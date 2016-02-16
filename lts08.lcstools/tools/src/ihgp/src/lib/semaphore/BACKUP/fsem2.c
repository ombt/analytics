// source for file-based semaphores, uses fcntl.

// headers
#include "fsem2.h"

// constructors and destructor
SemaphoreFile::SemaphoreFile(const char *fnm):
	fname(NULL), state(Unknown), fd(-1)
{
	// allocate file name, etc.
	if (fnm != NULL && *fnm != '\0')
		newFileName(fnm);

	// open the file for write. reset umask to get correct permissions
	mode_t oldumask = umask(0L);
	MustBeTrue((fd = open(fname, (O_WRONLY|O_CREAT), 0777)) >= 0);
	umask(oldumask);

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));
}

SemaphoreFile::SemaphoreFile(const SemaphoreFile &src):
	fname(NULL), state(Unknown), fd(-1)
{
	// allocate filename, etc.
	if (src.fname != NULL && *src.fname != '\0')
		newFileName(src.fname);

	// open the file for write. reset umask to get correct permissions
	mode_t oldumask = umask(0L);
	MustBeTrue((fd = open(fname, (O_WRONLY|O_CREAT), 0777)) >= 0);
	umask(oldumask);

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));
}

SemaphoreFile::~SemaphoreFile()
{
	// release semaphore 
	if (state == Owner)
		MustBeTrue(V() == OK);

	// release file name
	if (fname != NULL) cleanup();

	// sanity checks
	MustBeTrue(state == Unknown && fname == NULL && fd == -1);
}

// assignment operation
SemaphoreFile &
SemaphoreFile::operator=(const SemaphoreFile &rhs)
{
	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));

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

	// open the file for write. reset umask to get correct permissions
	mode_t oldumask = umask(0L);
	MustBeTrue((fd = open(fname, (O_WRONLY|O_CREAT), 0777)) >= 0);
	umask(oldumask);

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));

	// all done
	return(*this);
}

// do nothing signal handler
extern "C" {
static void
signalhandler(int sig)
{
	sig;
	return;
}
}

// semaphore operations
int
SemaphoreFile::P(int maxtime)
{
	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));

	// check state
	if (state == Unknown)
		return(NOTOK);

	// try to get ownership of file
	flock lock;
	lock.l_type = F_WRLCK;
	lock.l_start = 0;
	lock.l_whence = SEEK_SET;
	lock.l_len = 0;

	// assume we have an error
	state = Error;

	// depending on maxtime, block or don't block.
	if (maxtime < 0)
	{
		// block waiting for file lock
		if (fcntl(fd, F_SETLKW, &lock) < 0)
			return(NOTOK);
	}
	else if (maxtime > 0)
	{
		// set an alarm for timing out
#if 0
		void (*oldfn)(int);
#else
		SIG_PF oldfn;
#endif
		oldfn = signal(SIGALRM, signalhandler);
		alarm(maxtime);

		// block, but with a time out.
		if (fcntl(fd, F_SETLKW, &lock) < 0)
		{
			if (errno == EINTR)
			{
				// time out
				state = Blocked;
				MustBeTrue((state == Unknown && 
					    fname == NULL && fd == -1) ||
					   (state != Unknown && 
					    fname != NULL && fd != -1));
				return(EAGAIN);
			}
			else 
				return(NOTOK);
		}

		// clear alarm and reset alarm handler
		alarm(0);
		signal(SIGALRM, oldfn);
	}
	else
	{
		// no block waiting for file lock
		if (fcntl(fd, F_SETLK, &lock) < 0)
		{
			if (errno == EACCES || errno == EAGAIN)
			{
				state = Blocked;
				MustBeTrue((state == Unknown && 
					    fname == NULL && fd == -1) ||
					   (state != Unknown && 
					    fname != NULL && fd != -1));
				return(EAGAIN);
			}
			else
				return(NOTOK);
		}
	}

	// we own the semaphore file, just close it for now.
	state = Owner;

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));

	// just return
	return(OK);
}

int
SemaphoreFile::V()
{
	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));

	// check state
	if (state == Unknown)
		return(NOTOK);

	// release the lock
	flock lock;
	lock.l_type = F_UNLCK;
	lock.l_start = 0;
	lock.l_whence = SEEK_SET;
	lock.l_len = 0;

	// assume we have an error
	state = Error;

	// block waiting for file lock
	if (fcntl(fd, F_SETLK, &lock) < 0)
		return(NOTOK);

	// reset state to ready-to-be-used
	state = Initialized;

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));

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
	if (fd >= 0) close(fd);
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
