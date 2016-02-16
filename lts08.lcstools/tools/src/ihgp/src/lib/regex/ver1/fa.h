#ifndef __FA_H
#define __FA_H
/* definitions for finite automata class */

/* required headers */
#include "returns.h"
#include "linkList.h"
#include "set.h"
#include "setState.h"

/* define classes */
class FAstate;
class FAstateList;
class FAstateIterator;
class FAinput;
class FAinputList;
class FAinputIterator;
class FA;

/* definitions for FA classes */
#undef NOSTATE
#define NOSTATE -1
#undef STARTSTATE
#define STARTSTATE 0
#undef NULLTOKEN
#define NULLTOKEN 0

/* finite automata state class */
class FAstate: public Link {
	friend FAstateList;

public:
	/* constructor and destructor */
	FAstate();
	FAstate(int);
	~FAstate();

	/* get links */
	inline FAstate *getNext();
	inline FAstate *getPrevious();

	/* get input list or state */
	inline int getState();
	inline void setState(int);
	inline FAinputList *getInput();

private:
	/* don't allow these */
	FAstate(const FAstate &);
	FAstate &operator=(const FAstate &);

protected:
	int state;
	FAinputList *input;
};

/* finite automata state list class */
class FAstateList: public List {
	friend FAstateIterator;

public:
	/* constructor and destructor */
	FAstateList();
	FAstateList(const FAstateList &);
	~FAstateList();
	FAstateList &operator=(const FAstateList &);

	/* access links */
	inline FAstate *getFirst();
	inline FAstate *getLast();
	void dumpList();

	/* create link lists */
	FAstateList &append(FAstate *);
	FAstateList &prepend(FAstate *);
	FAstateList &remove(FAstate *);
	void copyFAstateList(const FAstateList &);

	/* stack operations */
	inline FAstateList &push(FAstate *);
	inline FAstate *pop();
	inline FAstate *top();

	/* find a state in list */
	FAstate *findState(int);

	/* merge two states */
	int mergeStates(int, int);
	int compressStates();

protected:
	/* internal data */
	Set *stateSet;
};

/* finite automata state iterator class */
class FAstateIterator: public Iterator {
public:
	/* constructor and destructor */
	FAstateIterator();
	FAstateIterator(const FAstateIterator &);
	FAstateIterator(const FAstateList &);
	~FAstateIterator();
	FAstateIterator &operator=(const FAstateIterator &);
	FAstateIterator &operator=(const FAstateList &);

	/* return next link */
	FAstate *operator()();
};

/* finite automata input class */
class FAinput: public Link {
	friend FAinputList;
public:
	/* constructor and destructor */
	FAinput();
	FAinput(int, FAstate *);
	~FAinput();

	/* get links */
	inline FAinput *getNext();
	inline FAinput *getPrevious();

	/* get data */
	inline int getInput();
	inline FAstate *getState();

private:
	/* don't allow these */
	FAinput(const FAinput &);
	FAinput &operator=(const FAinput &);

protected:
	int input;
	FAstate *state;
};

/* finite automata input list class */
class FAinputList: public List {
	friend FAinputIterator;

public:
	/* constructor and destructor */
	FAinputList();
	~FAinputList();

	/* access link list elements */
	inline FAinput *getLast();
	inline FAinput *getFirst();
	void dumpList(int);

	/* create link lists */
	FAinputList &append(FAinput *);
	FAinputList &prepend(FAinput *);
	FAinputList &remove(FAinput *);

private:
	/* don't allow these */
	FAinputList(const FAinputList &);
	FAinputList &operator=(const FAinputList &);
};

/* finite automata input iterator class */
class FAinputIterator: public Iterator {
public:
	/* constructor and destructor */
	FAinputIterator();
	FAinputIterator(const FAinputIterator &);
	FAinputIterator(const FAinputList &);
	~FAinputIterator();
	FAinputIterator &operator=(const FAinputIterator &);
	FAinputIterator &operator=(const FAinputList &);

	/* return next link */
	FAinput *operator()();
};

/* finite automata class */
class FA {
public:
	/* constructor and destructor */
	FA();
	~FA();

	/* maintain FA */
	int insertTransition(int, int, int, FAstateList * = 0);
	int mergeStates(int, int);
	int compressStates();

	/* get transitions for a given input */
	Set move(int, int, int &);
	Set move(Set &, int, int &);
	Set epsilonClosure(int, int &);
	Set epsilonClosure(Set &, int &);

	/* construct DFA from NFA */
	int NFAtoDFA();

	/* others */
	inline int getStatus();
	inline Set getInputSet();
	inline FAstateList *getFA();
	void dumpFA();

private:
	/* for now */
	FA(const FA &);
	FA &operator=(const FA &);

protected:
	int status;
	Set inputSet;
	FAstateList *fa;
};

/* inline functions */
inline int
FA::getStatus()
{
	return(status);
}

inline Set
FA::getInputSet()
{
	return(inputSet);
}

inline FAstateList *
FA::getFA()
{
	return(fa);
}

inline FAinputList *
FAstate::getInput()
{
        status = OK;
        return(input);
}
 
inline int
FAstate::getState()
{
        status = OK;
        return(state);
}

inline void
FAstate::setState(int newStateValue)
{
        state = newStateValue;
}

inline FAstate *
FAstate::getNext()
{
        status = OK;
        return((FAstate *) next);
}
 
inline FAstate *
FAstate::getPrevious()
{
        status = OK;
        return((FAstate *) previous);
}

inline int
FAinput::getInput()
{
	status = OK;
	return(input);
}

inline FAstate *
FAinput::getState()
{
	status = OK;
	return(state);
}

inline FAstate *
FAstateList::getLast()
{
        status = OK;
        return((FAstate *)last);
}
 
inline FAstate *
FAstateList::getFirst()
{
        status = OK;
        return((FAstate *)first);
}

inline FAinput *
FAinput::getNext()
{
        status = OK;
        return((FAinput *) next);
}
 
inline FAinput *
FAinput::getPrevious()
{
        status = OK;
        return((FAinput *) previous);
}

inline FAinput *
FAinputList::getLast()
{
        status = OK;
        return((FAinput *)last);
}
 
inline FAinput *
FAinputList::getFirst()
{
        status = OK;
        return((FAinput *)first);
}

inline FAstateList &
FAstateList::push(FAstate *newState)
{
	List::push((Link *)newState);
	if (status == OK) *stateSet += newState->state;
	return(*this);
}

inline FAstate *
FAstateList::pop()
{
	FAstate *save = (FAstate *)List::pop();
	if (save != (FAstate *)0) *stateSet -= save->state;
	return(save);
}

inline FAstate *
FAstateList::top()
{
	return((FAstate *)List::top());
}

#endif
