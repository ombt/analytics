/* set state member functions are defined here */

/* unix headers */
#include <sysent.h>
#include <stdlib.h>
#include <memory.h>

/* other headers */
#include "debug.h"
#include "setState.h"

/* set state contructors */
SetState::SetState(): Set()
{
	init();
}

int
SetState::init()
{
	state = NoState;
	symbol = 0;
	accepting = 0;
	status = OK;
	return(OK);
}

SetState::SetState(Set &srcset, int srcstate, int srcsymbol): Set(srcset)
{
	init(srcstate, srcsymbol);
}

int
SetState::init(int srcstate, int srcsymbol)
{
	state = srcstate;
	symbol = srcsymbol;
	accepting = 0;
	status = OK;
	return(OK);
}

SetState::SetState(const SetState &src): Set(src)
{
	init(src);
}

int
SetState::init(const SetState &src)
{
	state = src.state;
	symbol = src.symbol;
	accepting = 0;
	status = OK;
	return(OK);
}

/* set state destructor */
SetState::~SetState()
{
	deleteAll();
}

int
SetState::deleteAll()
{
	state = NoState;
	symbol = 0;
	accepting = 0;
	status = OK;
	return(OK);
}

/* set state assignment */
SetState &
SetState::operator=(const SetState &rhs)
{
	if (this == &rhs) return(*this);
	deleteAll();
	Set::operator=(rhs);
	init(rhs);
	return(*this);
}

/* set state group constructors */
SetStateGroup::SetStateGroup()
{
	init();
}

int
SetStateGroup::init()
{
	numOfStates = 0;
	maxNumOfStates = 0;
	group = (SetState **)0;
	status = OK;
	return(OK);
}

/* set state group destructor */
SetStateGroup::~SetStateGroup()
{
	deleteAll();
}

int
SetStateGroup::deleteAll()
{
	if (group != (SetState **)0) 
	{
		for (int istate = 0; istate < maxNumOfStates; istate++)
		{
			if (group[istate] != (SetState *)0)
			{
				delete group[istate];
			}
		}
		delete group;
	}
	group = (SetState **)0;
	numOfStates = 0;
	maxNumOfStates = 0;
	status = OK;
	return(OK);
}

/* insert a new state in group */
SetState *
SetStateGroup::insert(SetState *newState)
{
	/* check parameters */
	if (newState == (SetState *)0)
	{
		status = EINVAL;
		ERROR("SetStateGroup::insert: newState is null.", status);
		return((SetState *)0);
	}

	/* check if enough space for new state */
	if (newState->state >= maxNumOfStates)
	{
		/* calculate new maximum number of states */
		int newMaxNumOfStates = newState->state/DeltaStates;
		newMaxNumOfStates = (++newMaxNumOfStates)*DeltaStates;

		/* allocate new group */
		SetState **newGroup = new SetState *[newMaxNumOfStates];
		if (newGroup == (SetState **)0)
		{
			status = ENOMEM;
			ERROR("SetStateGroup::insert: ENOMEM for newGroup.", status);
			return((SetState *)0);
		}

		/* initialize new group */
		if (group != (SetState **)0)
		{
			memcpy(newGroup, group, 
			       maxNumOfStates*sizeof(SetState *));
			memset(newGroup + maxNumOfStates, 0,
			      (newMaxNumOfStates-maxNumOfStates)*
			       sizeof(SetState *));
			delete group;
		}
		else
		{
			memset(newGroup, 0,
			       newMaxNumOfStates*sizeof(SetState *));
		}

		/* store new group */
		group = newGroup;
		maxNumOfStates = newMaxNumOfStates;
	}

	/* store new state */
	if (group[newState->state] != (SetState *)0)
	{
		status = EINVAL;
		ERRORI("SetStateGroup::insert: EINVAL, duplicate state.", 
		       newState->state, status);
		return((SetState *)0);
	}
	group[newState->state] = newState;
	numOfStates++;

	/* all done */
	status = OK;
	return(newState);
}

/* delete a state from group */
SetState *
SetStateGroup::remove(int state)
{
	status = OK;
	if (group == (SetState **)0) return((SetState *)0);
	if (state < 0 || state >= maxNumOfStates) return((SetState *)0);
	SetState *save = group[state];
	group[state] = (SetState *)0;
	numOfStates--;
	return(save);
}

SetState *
SetStateGroup::remove(SetState &set)
{
	status = OK;
	if (group == (SetState **)0) return((SetState *)0);
	for (int istate = 0; istate < maxNumOfStates; istate++)
	{
		if ((group[istate] != (SetState *)0) &&
		    (*group[istate] == set))
		{
			SetState *save = group[istate];
			group[istate] = (SetState *)0;
			return(save);
		}
	}
	return((SetState *)0);
}

/* find and return a given state */
SetState *
SetStateGroup::find(int state)
{
	status = OK;
	if (group == (SetState **)0) return((SetState *)0);
	if (state < 0 || state >= maxNumOfStates) return((SetState *)0);
	if (group[state] == (SetState *)0) return((SetState *)0);
	return(group[state]);
}

SetState *
SetStateGroup::find(SetState &set)
{
	status = OK;
	if (group == (SetState **)0) return((SetState *)0);
	for (int istate = 0; istate < maxNumOfStates; istate++)
	{
		if ((group[istate] != (SetState *)0) &&
		    (*group[istate] == set))
		{
			return(group[istate]);
		}
	}
	return((SetState *)0);
}

/* set state group iterator constructors */
SetStateGroupIterator::SetStateGroupIterator()
{
	init();
}

int
SetStateGroupIterator::init()
{
	lastState = -1;
	group = (SetStateGroup *)0;
	status = OK;
	return(OK);
}

SetStateGroupIterator::SetStateGroupIterator(const SetStateGroupIterator &src)
{
	init(src);
}

int
SetStateGroupIterator::init(const SetStateGroupIterator &src)
{
	lastState = -1;
	group = src.group;
	status = OK;
	return(OK);
}

SetStateGroupIterator::SetStateGroupIterator(const SetStateGroup &src)
{
	init(src);
}

int
SetStateGroupIterator::init(const SetStateGroup &src)
{
	lastState = -1;
	group = &src;
	status = OK;
	return(OK);
}

/* set state group iterator destructor */
SetStateGroupIterator::~SetStateGroupIterator()
{
	deleteAll();
}

int
SetStateGroupIterator::deleteAll()
{
	group = (SetStateGroup *)0;
	lastState = -1;
	status = OK;
	return(OK);
}

/* assignment operations */
SetStateGroupIterator &
SetStateGroupIterator::operator=(const SetStateGroup &rhs)
{
	deleteAll();
	init(rhs);
	return(*this);
}

SetStateGroupIterator &
SetStateGroupIterator::operator=(const SetStateGroupIterator &rhs)
{
	if (this == &rhs) return(*this);
	deleteAll();
	init(rhs);
	return(*this);
}

/* iterator function */
SetState *
SetStateGroupIterator::operator()()
{
	status = OK;
	if (lastState >= group->maxNumOfStates) return((SetState *)0);
	for (lastState++ ; lastState < group->maxNumOfStates; lastState++)
	{
		if (group->group[lastState] != (SetState *)0)
		{
			return(group->group[lastState]);
		}
	}
	return((SetState *)0);
}
