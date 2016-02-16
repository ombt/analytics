// source for POSIX semaphores

// headers
#include "psem.h"

// constructors and destructor
Semaphore::Semaphore(const char *fnm, int m, unsigned int v):
	fname(NULL), state(Unknown), psem(NULL), mode(m), value(v)
{
	// allocate file name, etc.
	if (fnm != NULL && *fnm != '\0')
	{
		// set new file name
		newFileName(fnm);

		// open or create semaphore
		psem = sem_open(fname, O_CREAT|O_EXCL, mode, value);
		if (psem == (sem_t *)-1)
		{
			MustBeTrue(errno == EEXIST);
			psem = sem_open(fname, O_CREAT, mode, value);
			MustBeTrue(psem != (sem_t *)-1);
		}
	}

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && psem == NULL) ||
		   (state != Unknown && fname != NULL && psem != NULL));
}

Semaphore::Semaphore(const Semaphore &src):
	fname(NULL), state(Unknown), psem(NULL), 
	mode(src.mode), value(src.value)
{
	// allocate filename, etc.
	if (src.fname != NULL && *src.fname != '\0')
	{
		// set new file name
		newFileName(src.fname);

		// open or create semaphore
		psem = sem_open(fname, O_CREAT|O_EXCL, mode, value);
		if (psem == (sem_t *)-1)
		{
			MustBeTrue(errno == EEXIST);
			psem = sem_open(fname, O_CREAT, mode, value);
			MustBeTrue(psem != (sem_t *)-1);
		}
	}

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && psem == NULL) ||
		   (state != Unknown && fname != NULL && psem != NULL));
}

Semaphore::~Semaphore()
{
	// release semaphore 
	if (state == Owner)
		MustBeTrue(V() == OK);

	// release file name
	if (fname != NULL) cleanup();

	// sanity checks
	MustBeTrue(state == Unknown && fname == NULL && psem == NULL);
}

// assignment operation
Semaphore &
Semaphore::operator=(const Semaphore &rhs)
{
	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && psem == NULL) ||
		   (state != Unknown && fname != NULL && psem != NULL));

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
	{
		// set new file name and copy data
		newFileName(rhs.fname);
		mode = rhs.mode;
		value = rhs.value;

		// open or create semaphore
		psem = sem_open(fname, O_CREAT|O_EXCL, mode, value);
		if (psem == (sem_t *)-1)
		{
			MustBeTrue(errno == EEXIST);
			psem = sem_open(fname, O_CREAT, mode, value);
			MustBeTrue(psem != (sem_t *)-1);
		}
	}

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && psem == NULL) ||
		   (state != Unknown && fname != NULL && psem != NULL));

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
Semaphore::P(int maxtime)
{
	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && psem == NULL) ||
		   (state != Unknown && fname != NULL && psem != NULL));

	// check state
	if (state == Unknown)
		return(NOTOK);

	// assume we have an error
	state = Error;

	// depending on maxtime, block or don't block.
	if (maxtime < 0)
	{
		// block waiting for file lock
		if (sem_wait(psem) != OK)
			return(NOTOK);
	}
	else if (maxtime > 0)
	{
		// set an alarm for timing out
		SIG_PF oldfn;
		oldfn = signal(SIGALRM, signalhandler);
		alarm(maxtime);

		// block, but with a time out.
		if (sem_wait(psem) != OK)
		{
			if (errno == EINTR)
			{
				// time out
				state = Blocked;
				MustBeTrue((state == Unknown && 
					    fname == NULL && psem == NULL) ||
					   (state != Unknown && 
					    fname != NULL && psem != NULL));
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
		if (sem_trywait(psem) != OK)
		{
			if (errno == EAGAIN)
			{
				state = Blocked;
				MustBeTrue((state == Unknown && 
					    fname == NULL && psem == NULL) ||
					   (state != Unknown && 
					    fname != NULL && psem != NULL));
				return(EAGAIN);
			}
			else
				return(NOTOK);
		}
	}

	// we own the semaphore file, just close it for now.
	state = Owner;

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && psem == NULL) ||
		   (state != Unknown && fname != NULL && psem != NULL));

	// just return
	return(OK);
}

int
Semaphore::V()
{
	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && psem == NULL) ||
		   (state != Unknown && fname != NULL && psem != NULL));

	// check state
	if (state == Unknown)
		return(NOTOK);

	// assume we have an error
	state = Error;

	// block waiting for file lock
	if (sem_post(psem) != OK)
		return(NOTOK);

	// reset state to ready-to-be-used
	state = Initialized;

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && psem == NULL) ||
		   (state != Unknown && fname != NULL && psem != NULL));

	// just return
	return(OK);
}

// other operations
void
Semaphore::setFileName(const char *newfn)
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
Semaphore::newFileName(const char *nfn)
{
	if (fname != NULL)
		delete [] fname;
	fname = NULL;
	char *tmpfn = new char [strlen(nfn)+1];
	MustBeTrue(tmpfn != NULL);
	strcpy(tmpfn, nfn);
	fname = tmpfn;
	state = Initialized;
	return;
}

const char *
Semaphore::getFileName() const
{
	return(fname);
}

Semaphore::States
Semaphore::getState() const
{
	return(state);
}

void
Semaphore::cleanup()
{
	if (fname != NULL)
		delete [] fname;
	fname = NULL;
	state = Unknown;
	if (psem != NULL) sem_close(psem);
	psem = NULL;
	return;
}

// remove lock file
void
Semaphore::removeLockFile(const char *lfnm)
{
	if (lfnm != NULL && *lfnm != '\0')
		sem_unlink(lfnm);
	return;
}
