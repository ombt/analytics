#include <signal.h>
#include <sys/types.h>

static char bin_shell[] = "/bin/sh";
static char shell[] = "sh";
static char shflg[]= "-c";

static int fired = 0;

extern int execl();
extern pid_t fork(), wait();

/* alarm handler */

int
tsystem(s, t)
char	*s;
int	t;
{
	int	status;
	pid_t pid, w;
#if uts
	void (*istat)(), (*qstat)();
#else
	register int (*istat)(), (*qstat)();
#endif

	if((pid = fork()) == 0) {
		(void) execl(bin_shell, shell, shflg, s, (char *)0);
		_exit(127);
	}
	if (pid == -1)
		return(-1);
	istat = signal(SIGINT, SIG_IGN);
	qstat = signal(SIGQUIT, SIG_IGN);
	while((w = wait(&status)) != pid && w != -1)
		;
	(void) signal(SIGINT, istat);
	(void) signal(SIGQUIT, qstat);
	return((w == -1)? (int) w: status);
}
