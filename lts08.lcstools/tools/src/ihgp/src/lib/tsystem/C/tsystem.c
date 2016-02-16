/* required headers */
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

/* static data */
static char bin_shell[] = "/bin/sh";
static char shell[] = "sh";
static char shflg[]= "-c";
static int timedout = 0;

/* alarm handler */
static void
timeout(sig)
int sig;
{
	sig;
	timedout = 1;
	fprintf(stderr, "tsystem timed out !!!\n");
	return;
}

int
tsystem(s, t)
char	*s;
int	t;
{
	int status, status2;
	pid_t savepid, pid, w;
	void (*istat)(), (*qstat)(), (*astat)();

	/* set time-out flag to false */
	timedout = 0;

	/* set alarm, also save old handler */
	if (t > 0)
	{
		astat = signal(SIGALRM, timeout);
		alarm(t);
	}

	/* execute the actual command */
	if ((pid = fork()) == 0)
	{
#if KILLPGRP
		/* set process group to pid. this releases controlling
		 * terminal.
		 */
		setpgrp();
#endif
		(void) execl(bin_shell, shell, shflg, s, (char *)0);
		_exit(127);
	}
	if (pid == -1)
		return(-1);

	/* turn-off interupt and quit signals */
	istat = signal(SIGINT, SIG_IGN);
	qstat = signal(SIGQUIT, SIG_IGN);

	/* wait for forked process to die */
	savepid = pid;
	while((w = wait(&status)) != pid && w != -1)
	{
		/* do nothing */
	}

	/* check if a time-out occurred */
	if (timedout)
	{
		/* time-out occurred */
#if KILLPGRP
		/* kill all processes in the process group */
		kill(-savepid, SIGKILL);
#else
		/* just kill the process */
		kill(savepid, SIGKILL);
#endif

		/* wait for the child to die */
		if (wait(&status2) == pid)
		{
			fprintf(stderr, "cmd was killed and pid caught.\n");
		}
		else
		{
			fprintf(stderr, "cmd was killed, but pid was NOT caught.\n");
		}
		w = -2;
	}
	else
	{
		/* no time-out, clean up */
		alarm(0);
	}

	/* reset old interupt and quit handlers */
	if (t > 0)
	{
		(void) signal(SIGALRM, astat);
	}
	(void) signal(SIGINT, istat);
	(void) signal(SIGQUIT, qstat);

	/* all done */
	return((w < 0)? (int) w: status);
}
