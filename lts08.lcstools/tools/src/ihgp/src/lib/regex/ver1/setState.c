/* member functions for set list class */

/* unix headers */
#include <stdio.h>
#include <errno.h>

/* other headers */
#include "setState.h"

/* debugging macros */
#ifdef DEBUG
#define ERROR(msg) fprintf(stderr, "%s'%d: ERROR %s\n", __FILE__, __LINE__, msg)
#else
#define ERROR(msg) 
#endif

/* constructor for link class */
SetState::SetState()
{
	set.clear();
	state = NOSTATE;
}

SetState::SetState(Set &src, int srcState)
{
	set = src;
	state = srcState;
}

/* destructor for link class */
SetState::~SetState()
{
	set.clear();
	state = NOSTATE;
	status = OK;
}

/* constructor for list class */
SetStateList::SetStateList()
{
	status = OK;
}

/* destructor for list class */
SetStateList::~SetStateList()
{
	status = OK;
}

/* add a new link at the end of list */
SetStateList &
SetStateList::append(SetState *newSet)
{
	List::append((Link *)newSet);
	return(*this);
}

/* add a new link at front of list */
SetStateList &
SetStateList::prepend(SetState *newSet)
{
	List::prepend((Link *)newSet);
	return(*this);
}

/* remove link from list */
SetStateList &
SetStateList::remove(SetState *oldSet)
{
	List::remove((Link *)oldSet);
	return(*this);
}

/* find a state in a list */
SetState *
SetStateList::findState(Set &set)
{
	SetState *pset;
	SetStateListIterator setIter(*this);

	/* check interator constructor */
	if ((status = setIter.getStatus()) != OK)
	{
		ERROR("findState, SetStateListIterator constructor failed");
		return((SetState *)0);
	}

	/* cycle thru all sets looking for a set */
	while ((pset = setIter()) != (SetState *)0)
	{
		/* check for a match */
		if (pset->set == set) break;
	}

	/* return what was found */
	if ((status = setIter.getStatus()) != OK)
	{
		ERROR("findState, SetStateListIterator operator () failed");
		return((SetState *)0);
	}
	return(pset);
}

SetState *
SetStateList::findState(int state)
{
	SetState *pset;
	SetStateListIterator setIter(*this);

	/* check interator constructor */
	if ((status = setIter.getStatus()) != OK)
	{
		ERROR("findState, SetStateListIterator constructor failed");
		return((SetState *)0);
	}

	/* cycle thru all sets looking for a set */
	while ((pset = setIter()) != (SetState *)0)
	{
		/* check for a match */
		if (pset->state == state) break;
	}

	/* return what was found */
	if ((status = setIter.getStatus()) != OK)
	{
		ERROR("findState, SetStateListIterator operator () failed");
		return((SetState *)0);
	}
	return(pset);
}
/* default constructor for SetStateList interator */
SetStateListIterator::SetStateListIterator(): Iterator()
{
	status = OK;
}

/* copy constructor */
SetStateListIterator::SetStateListIterator(const SetStateListIterator &src): 
	Iterator(src)
{
}

/* constructor for SetStateList iterator */
SetStateListIterator::SetStateListIterator(const SetStateList &list): 
	Iterator(list)
{
}

/* destructor for SetStateList interator */
SetStateListIterator::~SetStateListIterator()
{
	status = OK;
}

/* assignment operator */
SetStateListIterator &
SetStateListIterator::operator=(const SetStateListIterator &src)
{
	next = src.next;
	status = OK;
	return(*this);
}

SetStateListIterator &
SetStateListIterator::operator=(const SetStateList &list)
{
	next = list.first;
	status = OK;
	return(*this);
}

/* iterator for setState class */
SetState *
SetStateListIterator::operator()()
{
	return((SetState *)Iterator::operator()());
}
