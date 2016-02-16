/* file contains functions for fsm class */

/* unix headers */
#include <sysent.h>
#include <stdlib.h>
#include <memory.h>

/* other headers */
#include "fsm.h"
#include "returns.h"
#include "debug.h"

/* constructors */
Fsm::Fsm()
{
	init();
}

int
Fsm::init()
{
	maxState = FsmDeltaStates;
	if ((fsm = new FsmData [maxState]) == (FsmData *)0)
	{
		status = ENOMEM;
		ERROR("ENOMEM for new fsm.", status);
		return(NOTOK);
	}
	memset((void *)fsm, 0, maxState*sizeof(FsmData));
	status = OK;
	return(OK);
}

/* destructor */
Fsm::~Fsm()
{
	deleteAll();
}

int
Fsm::deleteAll()
{
	if (fsm != (FsmData *)0)
	{
		for (int state = 0; state < maxState; state++)
		{
			if (fsm[state].toState != (short *)0)
			{
				delete [] fsm[state].toState;
				fsm[state].toState = (short *)0;
			}
		}
		delete fsm;
	}
	fsm = (FsmData *)0;
	maxState = 0;
	status = OK;
	return(OK);
}

/* insert a state into fsm */
int
Fsm::insertState(int state, int accepting)
{
	/* check if state is out of range */
	if (state < 0)
	{
		status = EINVAL;
		ERROR("EINVAL for state.", status);
		return(NOTOK);
	}
	if (fsm == (FsmData *)0)
	{
		status = EFAULT;
		ERROR("fsm not allocated.", status);
		return(NOTOK);
	}

	/* check if fsm is large enough to hold the state */
	if (state >= maxState)
	{
		/* reallocate fsm */
		int newmax = (state/FsmDeltaStates)*FsmDeltaStates +
			      FsmDeltaStates;
		FsmData *newfsm = new FsmData [newmax];
		if (newfsm == (FsmData *)0)
		{
			status = ENOMEM;
			ERROR("ENOMEM for new fsm.", status);
			return(NOTOK);
		}
		memcpy((void *)newfsm, (void *)fsm, maxState*sizeof(FsmData));
		memset((void *)(newfsm + maxState), 0,
		       (newmax - maxState)*sizeof(FsmData));
		delete fsm;
		fsm = newfsm;
		maxState = newmax;
	}

	/* check if state exists */
	if (fsm[state].toState == (short *)0)
	{
		fsm[state].toState = new short[FsmNumberOfChars];
		if (fsm[state].toState == (short *)0)
		{
			status = ENOMEM;
			ERROR("ENOMEM for new fsm state.", status);
			return(NOTOK);
		}
		memset((void *)fsm[state].toState, 
			FsmNoState, FsmNumberOfChars*sizeof(short));
	}

	/* store data */
	fsm[state].accepting = (accepting != 0);

	/* all done */
	status = OK;
	return(NOTOK);
}

/* insert a transition into fsm */
int
Fsm::insertTransition(int fromState, int input, int toState)
{
	/* check if state and input are within range */
	if (fromState < 0 || toState < 0)
	{
		status = EINVAL;
		ERROR("EINVAL for fromState or toState.", status);
		return(NOTOK);
	}
	if (input < 0 || input >= FsmNumberOfChars)
	{
		status = EINVAL;
		ERROR("EINVAL for input.", status);
		return(NOTOK);
	}
	if (fsm == (FsmData *)0)
	{
		status = EFAULT;
		ERROR("fsm not allocated.", status);
		return(NOTOK);
	}

	/* check if fsm is large enough to hold the state */
	if (fromState >= maxState)
	{
		/* reallocate fsm */
		int newmax = (fromState/FsmDeltaStates)*FsmDeltaStates +
			     FsmDeltaStates;
		FsmData *newfsm = new FsmData [newmax];
		if (newfsm == (FsmData *)0)
		{
			status = ENOMEM;
			ERROR("ENOMEM for new fsm.", status);
			return(NOTOK);
		}
		memcpy((void *)newfsm, (void *)fsm, maxState*sizeof(FsmData));
		memset((void *)(newfsm + maxState), 0,
		       (newmax - maxState)*sizeof(FsmData));
		delete fsm;
		fsm = newfsm;
		maxState = newmax;
	}

	/* check if state exists */
	if (fsm[fromState].toState == (short *)0)
	{
		fsm[fromState].toState = new short[FsmNumberOfChars];
		if (fsm[fromState].toState == (short *)0)
		{
			status = ENOMEM;
			ERROR("ENOMEM for new fsm state.", status);
			return(NOTOK);
		}
		memset((void *)fsm[fromState].toState, 
			FsmNoState, FsmNumberOfChars*sizeof(short));
	}

	/* store transition */
	fsm[fromState].toState[input] = toState;

	/* all done */
	status = OK;
	return(NOTOK);
}

/* remove a transition */
int
Fsm::removeTransition(int fromState, int input)
{
	/* check parameters */
	if (fromState < 0 || fromState >= maxState)
	{
		status = EINVAL;
		ERROR("EINVAL for fromState.", status);
		return(NOTOK);
	}
	if (input < 0 || input >= FsmNumberOfChars)
	{
		status = EINVAL;
		ERROR("EINVAL for input.", status);
		return(NOTOK);
	}
	if (fsm == (FsmData *)0)
	{
		status = EFAULT;
		ERROR("fsm not allocated.", status);
		return(NOTOK);
	}

	/* check if transition exists */
	if (fsm[fromState].toState == (short *)0)
	{
		status = EFAULT;
		ERROR("fsm state not allocated.", status);
		return(NOTOK);
	}
	if (fsm[fromState].toState[input] == FsmNoState)
	{
		status = NOMATCH;
		return(OK);
	}

	/* remove transition */
	fsm[fromState].toState[input] = FsmNoState;

	/* all done */
	status = OK;
	return(NOTOK);
}

/* dump fsm */
void
Fsm::dump()
{
	if (fsm == (FsmData *)0) return;
	for (int state = 0; state < maxState; state++)
	{
		if (fsm[state].toState == (short *)0) continue;
		for (int input = 0; input < FsmNumberOfChars; input++)
		{
			if (fsm[state].toState[input] == FsmNoState) continue;
			fprintf(stderr, 
			"<from, input, to(accepting)> = <%d, (%c,%d), %d(%d)>\n",
			state, input, input, fsm[state].toState[input],
			fsm[fsm[state].toState[input]].accepting);
		}
	}
	return;
}

/* return a transition for an input and state */
int
Fsm::move(int state, int input)
{
        /* check if state and input are within range */
        if (state < 0 || state >= maxState)
        {
                status = EINVAL;
                ERROR("EINVAL for state.", status);
                return(FsmNoState);
        }
        if (input < 0 || input >= FsmNumberOfChars)
        {
                status = EINVAL;
                ERROR("EINVAL for input.", status);
                return(FsmNoState);
        }
	if (fsm == (FsmData *)0)
	{
		status = EFAULT;
		ERROR("fsm not allocated.", status);
		return(FsmNoState);
	}
 
        /* check if state exists */
        if (fsm[state].toState == (short *)0)
        {
                /* no state exists */
	        status = OK;
                return(FsmNoState);
        }
 
        /* return transition */
        status = OK;
        return(fsm[state].toState[input]);
}
