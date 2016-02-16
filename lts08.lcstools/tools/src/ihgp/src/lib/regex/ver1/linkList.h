#ifndef __LINKLIST_H
#define __LINKLIST_H
/* definitions for link list base class */

/* required headers */
#include "returns.h"

/* define classes */
class Link;
class List;
class Iterator;

/* link class */
class Link {
	friend class List;

public:
	/* constructor and destructor */
	Link();
	virtual ~Link();

	/* get links */
	inline Link *getNext();
	inline Link *getPrevious();

	/* other member functions */
	inline int getStatus();

private:
	/* don't allow these */
	Link(const Link &);
	Link &operator=(const Link &);

protected:
	/* internal data */
	int status;
	Link *next;
	Link *previous;
};

/* list class */
class List {
	friend Iterator;

public:
	/* constructor and destructor */
	List();
	virtual ~List();

	/* access link list elements */
	Link *getLast();
	Link *getFirst();

	/* create link lists */
	List &append(Link *);
	List &prepend(Link *);
	List &remove(Link *);

	/* stack operations */
	inline List &push(Link *);
	inline Link *pop();
	inline Link *top();

	/* other member functions */
	inline int getStatus();
	inline int isEmpty();

private:
	/* don't allow these */
	List(const List &);
	List &operator=(const List &);

protected:
	/* internal data */
	int status;
	Link *first;
	Link *last;
};

/* interator class */
class Iterator {
public:
	/* constructor and destructor */
	Iterator();
	Iterator(const Iterator &);
	Iterator(const List &);
	virtual ~Iterator();
	Iterator &operator=(const List &);
	Iterator &operator=(const Iterator &);

	/* return next link */
	Link *operator()();

	/* other member functions */
	inline int getStatus();

protected:
	/* internal data */
	int status;
	Link *next;
};

/* inline functions */
inline Link *
Link::getNext()
{
	status = OK;
	return(next);
}

inline Link *
Link::getPrevious()
{
	status = OK;
	return(previous);
}

inline Link *
List::getFirst()
{
	status = OK;
	return(first);
}

inline Link *
List::getLast()
{
	status = OK;
	return(last);
}

inline int 
Link::getStatus()
{
	return(status);
}

inline int 
List::getStatus()
{
	return(status);
}

inline int 
List::isEmpty()
{
	return(first == (Link *)0);
}

inline int 
Iterator::getStatus()
{
	return(status);
}

inline List &
List::push(Link *newLink)
{
	return(prepend(newLink));
}

inline Link *
List::pop()
{
	Link *save = first;
	remove(first);
	return(save);
}

inline Link *
List::top()
{
	status = OK;
	return(first);
}


#endif
