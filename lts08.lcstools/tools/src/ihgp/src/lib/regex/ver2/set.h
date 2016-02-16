#ifndef __SET_H
#define __SET_H
/* definitions for set class */

/* required headers */
#include "returns.h"

/* set definitions */
#define MINIMUMSETSIZE 8
#define BITSINBYTE 8
#define ULONGSIZE sizeof(unsigned long)
#define BYTESINSET(nl) ((nl)*ULONGSIZE)
#define BITSINSET(nl) (BYTESINSET(nl)*BITSINBYTE)
#define LASTMEMBER -1

/* define classes */
class Set;
class SetIterator;

/* set class */
class Set {
	friend SetIterator;

public:
	/* constructor and destructor */
	Set();
	Set(int);
	Set(const Set &);
	virtual ~Set();

	/* union set operations */
	virtual Set operator|(const Set &);
	virtual Set &operator|=(const Set &);

	/* intersection set operations */
	virtual Set operator&(const Set &);
	virtual Set &operator&=(const Set &);

	/* difference set operations */
	virtual Set operator-(const Set &);
	virtual Set &operator-=(const Set &);

	/* equality/assignment set operations */
	virtual Set &operator=(const Set &);
	virtual int operator==(const Set &);
	virtual int isMember(const int);
	virtual int isEmpty();

	/* insert/delete operations */
	virtual Set &fill();
	virtual Set &insert(const int);
	virtual Set operator+(const int);
	virtual Set &operator+=(const int);

	/* delete operations */
	virtual Set &clear();
	virtual Set &remove(const int);
	virtual Set operator-(const int);
	virtual Set &operator-=(const int);

	/* other member functions */
	inline int getStatus() { return(status); }
	inline int getSetSize() { return(setSize); }
	void dump() const;

protected:
	/* internal data */
	int status;
	int setSize;
	unsigned long *set;
};

/* iterator class for sets */
class SetIterator {
public:
	/* constructor and destructor */
	SetIterator();
	SetIterator(const Set &);
	SetIterator(const SetIterator &);
	virtual ~SetIterator();
	SetIterator &operator=(const SetIterator &);
	SetIterator &operator=(const Set &);

	/* return next member in set */
	int operator()();

	/* other functions */
	inline int getStatus() { return(status); }

protected:
	int status;
	int setSize;
	unsigned long *set;
	int nextLong;
	int nextBit;
};

#endif
