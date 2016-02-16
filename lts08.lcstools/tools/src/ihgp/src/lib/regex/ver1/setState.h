#ifndef __SETSTATE_H
#define __SETSTATE_H
/* definitions for link list of set class */

/* required headers */
#include "returns.h"
#include "set.h"
#include "linkList.h"

/* define classes */
class SetState;
class SetStateList;
class SetStateListIterator;

/* local definitions */
#undef NOSTATE
#define NOSTATE -1
#undef STARTSTATE
#define STARTSTATE 0
#undef NULLTOKEN
#define NULLTOKEN 0

/* link class */
class SetState: public Link {
	friend class SetStateList;

public:
	/* constructor and destructor */
	SetState();
	SetState(Set &, int);
	~SetState();

	/* get links */
	inline SetState *getNext();
	inline SetState *getPrevious();

	/* other member functions */
	inline Set &getSet();
	inline int getState();

private:
	/* don't allow these */
	SetState(const SetState &);
	SetState &operator=(const SetState &);

protected:
	/* internal data */
	int state;
	Set set;
};

/* list class */
class SetStateList: public List {
	friend SetStateListIterator;

public:
	/* constructor and destructor */
	SetStateList();
	~SetStateList();

	/* access link list elements */
	inline SetState *getLast();
	inline SetState *getFirst();

	/* create link lists */
	SetStateList &append(SetState *);
	SetStateList &prepend(SetState *);
	SetStateList &remove(SetState *);

	/* stack operations */
	inline SetStateList &push(SetState *);
	inline SetState *pop();
	inline SetState *top();

	/* find a state in list */
	SetState *findState(int);
	SetState *findState(Set &);

	/* other member functions */
	inline int isEmpty();

private:
	/* don't allow these */
	SetStateList(const SetStateList &);
	SetStateList &operator=(const SetStateList &);
};

/* interator class */
class SetStateListIterator: public Iterator {
public:
	/* constructor and destructor */
	SetStateListIterator();
	SetStateListIterator(const SetStateListIterator &);
	SetStateListIterator(const SetStateList &);
	virtual ~SetStateListIterator();
	SetStateListIterator &operator=(const SetStateList &);
	SetStateListIterator &operator=(const SetStateListIterator &);

	/* return next link */
	SetState *operator()();
};

/* inline functions */
inline SetState *
SetState::getNext()
{
	status = OK;
	return((SetState *)next);
}

inline SetState *
SetState::getPrevious()
{
	status = OK;
	return((SetState *)previous);
}

inline Set &
SetState::getSet()
{
	status = OK;
	return(set);
}

inline int
SetState::getState()
{
	status = OK;
	return(state);
}

inline SetState *
SetStateList::getFirst()
{
	status = OK;
	return((SetState *)first);
}

inline SetState *
SetStateList::getLast()
{
	status = OK;
	return((SetState *)last);
}

inline SetStateList &
SetStateList::push(SetState *newSet)
{
	List::push((Link *)newSet);
	return(*this);
}

inline SetState *
SetStateList::pop()
{
	SetState *save = (SetState *)List::pop();
	return(save);
}

inline SetState *
SetStateList::top()
{
	return((SetState *)List::pop());
}

#endif
