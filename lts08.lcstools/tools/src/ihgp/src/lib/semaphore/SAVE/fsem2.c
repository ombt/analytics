// source for file-based semaphores, uses fcntl.

// headers
#include "fsem2.h"

// constructors and destructor
SemaphoreFile::SemaphoreFile(const char *fnm):
	fname(NULL), state(Unknown), fd(-1), countsupdated(0)
{
	// allocate file name, etc.
	if (fnm != NULL && *fnm != '\0')
		newFileName(fnm);

	// open the file for write
	MustBeTrue((fd = open(fname, (O_WRONLY|O_CREAT), 0777)) >= 0);

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));
}

SemaphoreFile::SemaphoreFile(const SemaphoreFile &src):
	fname(NULL), state(Unknown), fd(-1), countsupdated(0)
{
	// allocate filename, etc.
	if (src.fname != NULL && *src.fname != '\0')
		newFileName(src.fname);

	// open the file for write
	MustBeTrue((fd = open(fname, (O_WRONLY|O_CREAT), 0777)) >= 0);

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));
}

SemaphoreFile::~SemaphoreFile()
{
	int counts = 0;

	// was semaphore ever used? if so, update counts
	if (countsupdated)
	{
		// get ownership for updating
		if (state != Owner)
			MustBeTrue(P(-1) == OK);

		// decrement counts
		MustBeTrue((counts = decrementCounts()) >= 0);

		// remove all files if last user
		if (counts == 0)
			unlinkFiles();
	}

	// release semaphore 
	if (state == Owner)
		MustBeTrue(V() == OK);

	// release file name
	if (fname != NULL && *fname != '\0')
		cleanup();

	// sanity checks
	MustBeTrue(state == Unknown && fname == NULL && fd == -1);
}

// assignment operation
SemaphoreFile &
SemaphoreFile::operator=(const SemaphoreFile &rhs)
{
	int counts = 0;

	// sanity checks
	MustBeTrue((state == Unknown && fname == NULL && fd == -1) ||
		   (state != Unknown && fname != NULL && fd != -1));

	// check for self-assignment
	if (this == &rhs)
		return(*this);

	// was semaphore ever used? if so, update counts
	if (countsupdated)
	{
		// get ownership for updating
		if (state != Owner)
			MustBeTrue(P(-1) == OK);

		// decrement counts
		MustBeTrue((counts = decrementCounts()) >= 0);

		// remove all files if last user
		if (counts == 0)
			unlinkFiles();
	}

	// check if semaphore is owned, if so, release it.
	if (state == Owner)
		MustBeTrue(V() == OK);

	// release file name
	if (fname != NULL && *fname != '\0')
		cleanup();

	// copy data
	if (rhs.fname != NULL && *rhs.fname != '\0')
		newFileName(rhs.fname);

	// open the file for write
	MustBeTrue((fd = open(fname, (O_WRONLY|O_CREAT), 0777)) >= 0);

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
	else if (state == Owner)
		return(OK);

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

	// at this point we own the lock file, update use counts
	// if the first time the semaphore was used.
	//
	if (!countsupdated)
	{
		// need to update counts
		MustBeTrue(incrementCounts() >= 0);

		// set flag, do this only once
		countsupdated = 1;
	}

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
	if (state != Owner)
		return(OK);

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

	// delete file
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

// unlink all file
void
SemaphoreFile::unlinkFiles() const
{

	if (fname != NULL && *fname != '\0')
	{
		char cntfnm[BUFSIZ];
		strcpy(cntfnm, fname);
		strcat(cntfnm, ".cnts");
		removeLockFile(cntfnm);
		removeLockFile(fname);
	}
	return;
}

// update use counts in count file
int
SemaphoreFile::updateCounts(int delta) const
{
TRACE();
	// this user must own files
	if ((state != Owner) || (fname == NULL) || (*fname == '\0'))
		return(NOTOK);
TRACE();

	// get count file name
	char cntfnm[BUFSIZ];
	strcpy(cntfnm, fname);
	strcat(cntfnm, ".cnts");
TRACE();

	// open file for read and write
	int cntfd = open(cntfnm, O_RDWR|O_CREAT, 0777);
	if (cntfd < 0)
		return(NOTOK);

	// read in counts
TRACE();
	char buf[BUFSIZ];
	int nr = 0;
	int usecounts = 0;
	nr = read(cntfd, buf, BUFSIZ);
TRACE();
	if (nr < 0)
	{
TRACE();
		close(cntfd);
		return(NOTOK);
	}
	else if (nr > 0)
	{
TRACE();
		if ((usecounts = atoi(buf)) < 0)
		{
TRACE();
			close(cntfd);
			return(NOTOK);
		}
TRACE();
	}
TRACE();
	if (lseek(cntfd, 0, SEEK_SET) < 0)
	{
TRACE();
		close(cntfd);
		return(NOTOK);
	}

	// update counts
TRACE();
	usecounts += delta;
	sprintf(buf,"%d", usecounts);
	int buflen = strlen(buf)+1;
	MustBeTrue(buflen < BUFSIZ);

	// write out the new counts
TRACE();
	if (write(cntfd, buf, buflen) != buflen)
	{
TRACE();
		close(cntfd);
		return(NOTOK);
	}

	// clean up and all done
TRACE();
	close(cntfd);
	return(OK);
}

int
SemaphoreFile::incrementCounts() const
{
	return(updateCounts(1));
}

int
SemaphoreFile::decrementCounts() const
{
	return(updateCounts(-1));
}
