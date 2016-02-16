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
	Set operator|(const Set &);
	Set &operator|=(const Set &);

	/* intersection set operations */
	Set operator&(const Set &);
	Set &operator&=(const Set &);

	/* difference set operations */
	Set operator-(const Set &);
	Set &operator-=(const Set &);

	/* equality/assignment set operations */
	Set &operator=(const Set &);
	int operator==(const Set &);
	int isMember(const int);
	int isEmpty();

	/* insert/delete operations */
	Set &fill();
	Set &insert(const int);
	Set operator+(const int);
	Set &operator+=(const int);

	/* delete operations */
	Set &clear();
	Set &remove(const int);
	Set operator-(const int);
	Set &operator-=(const int);

	/* other member functions */
	inline int getStatus();
	inline int getSetSize();
	void dumpSet() const;

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
	inline int getStatus();

protected:
	int status;
	int setSize;
	unsigned long *set;
	int nextLong;
	int nextBit;
};

/* inline functions */
inline int 
Set::getStatus()
{
	return(status);
}

inline int 
Set::getSetSize()
{
	return(setSize);
}

inline int 
SetIterator::getStatus()
{
	return(status);
}

#endif
