#ifndef __SETSTATE_H
#define __SETSTATE_H
/* definitions for sets of states */

/* required headers */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <assert.h>
#include "returns.h"
#include "set.h"

/* define classes */
class SetState;
class SetStateGroup;
class SetStateGroupIterator;

/* constants */
const int NoState = -1;
const int DeltaStates = 16;

/* set state class */
class SetState: public Set {
	friend class SetStateGroup;

public:
	/* constructor and destructor */
	SetState();
	SetState(Set &, int, int = 0);
	SetState(const SetState &);
	~SetState();

	/* operations */
	SetState &operator=(const SetState &);
	Set &operator=(const Set &rhs) { return(Set::operator=(rhs)); }

	/* casting */
	inline operator int() { return(state); }
	inline operator char() { return((char)symbol); }

	/* other functions */
	int init();
	int init(int, int = 0);
	int init(const SetState &);
	int deleteAll();
	inline void dump() { 
		fprintf(stderr, 
			"state = %d, accepting = %d, symbol = (%c,0x%x)\n", 
			state, accepting, (char)symbol, symbol); Set::dump(); }
	inline void setAccepting(int accval) { accepting = accval; }
	inline int isAccepting() { return(accepting != 0); }

protected:
	/* internal data */
	int state;
	int symbol;
	int accepting;
};

/* set state iterator class */
class SetStateIterator: public SetIterator {
public:
	SetStateIterator(): SetIterator() { }
	SetStateIterator(const SetState &src): SetIterator(src) { }
	SetStateIterator(const SetStateIterator &src): SetIterator(src) { }
	~SetStateIterator() { }
};

/* set state group class */
class SetStateGroup {
	friend SetStateGroupIterator;

public:
	/* constructor and destructor */
	SetStateGroup();
	~SetStateGroup();

	/* insert and find group members */
	SetState *insert(SetState *);
	SetState *remove(int);
	SetState *remove(SetState &);
	SetState *find(int);
	SetState *find(SetState &);

	/* other functions */
	int init();
	int deleteAll();
	inline int getStatus() { return(status); }
	inline int isEmpty() { return(numOfStates == 0); }
	inline void dump() { 
		for (int istate = 0; istate < maxNumOfStates; istate++)
		{
			if (group[istate] != (SetState *)0) 
			{
				group[istate]->dump();
			}
		}
	}

private:
	/* don't allow these */
	SetStateGroup(const SetStateGroup &);
	SetStateGroup &operator=(const SetStateGroup &);

protected:
	/* internal data */
	int status;
	int numOfStates;
	int maxNumOfStates;
	SetState **group;
};

/* interator class */
class SetStateGroupIterator {
public:
	/* constructor and destructor */
	SetStateGroupIterator();
	SetStateGroupIterator(const SetStateGroupIterator &);
	SetStateGroupIterator(const SetStateGroup &);
	~SetStateGroupIterator();

	/* operations */
	SetStateGroupIterator &operator=(const SetStateGroup &);
	SetStateGroupIterator &operator=(const SetStateGroupIterator &);

	/* return next state */
	SetState *operator()();

	/* other functions */
	int init();
	int init(const SetStateGroupIterator &);
	int init(const SetStateGroup &);
	int deleteAll();
	inline int getStatus() { return(status); }
	inline void reset() { lastState = -1; }

protected:
	/* internal data */
	int status;
	int lastState;
	const SetStateGroup *group;
};

#endif
