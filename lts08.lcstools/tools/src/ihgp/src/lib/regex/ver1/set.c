/* member functions for set class */

/* unix headers */
#include <stdio.h>
#include <memory.h>
#include <errno.h>

/* other headers */
#include "set.h"

/* constructors for set class */
Set::Set()
{
	setSize = MINIMUMSETSIZE;
	set = new unsigned long [setSize];
	if (set == (unsigned long *)0)
	{
		status = ENOMEM;
	}
	else
	{
		memset((void *)set, 0, BYTESINSET(setSize));
		status = OK;
	}
}

Set::Set(int numberOfMembersInSet)
{
	int size = numberOfMembersInSet/(ULONGSIZE*BITSINBYTE);
	if (numberOfMembersInSet % (ULONGSIZE*BITSINBYTE)) size++;
	setSize = (size >= MINIMUMSETSIZE) ? size : MINIMUMSETSIZE;
	set = new unsigned long [setSize];
	if (set == (unsigned long *)0)
	{
		status = ENOMEM;
	}
	else
	{
		memset((void *)set, 0, BYTESINSET(setSize));
		status = OK;
	}
}

Set::Set(const Set &src)
{
	setSize = src.setSize;
	set = new unsigned long [setSize];
	if (set == (unsigned long *)0)
	{
		status = ENOMEM;
	}
	else
	{
		memcpy((void *)set, (void *)src.set, BYTESINSET(setSize));
		status = OK;
	}
}

/* destructor for set class */
Set::~Set()
{
	delete [] set;
	setSize = 0;
	status = OK;
}

/* union set operations */
Set 
Set::operator|(const Set &src)
{
	int size = (setSize >= src.setSize ? setSize : src.setSize);
	Set newSet(BITSINSET(size));
	if (setSize <= src.setSize)
	{
		for (int s = 0; s < setSize; s++)
		{
			newSet.set[s] = set[s] | src.set[s];
		}
		for (s = setSize; s < src.setSize; s++)
		{
			newSet.set[s] = src.set[s];
		}
	}
	else
	{
		for (int s = 0; s < src.setSize; s++)
		{
			newSet.set[s] = set[s] | src.set[s];
		}
		for (s = src.setSize; s < setSize; s++)
		{
			newSet.set[s] = set[s];
		}
	}
	status = OK;
	return(newSet);
}

Set &
Set::operator|=(const Set &src)
{
	int size = (setSize >= src.setSize ? setSize : src.setSize);
	Set newSet(BITSINSET(size));
	if (setSize <= src.setSize)
	{
		for (int s = 0; s < setSize; s++)
		{
			newSet.set[s] = set[s] | src.set[s];
		}
		for (s = setSize; s < src.setSize; s++)
		{
			newSet.set[s] = src.set[s];
		}
	}
	else
	{
		for (int s = 0; s < src.setSize; s++)
		{
			newSet.set[s] = set[s] | src.set[s];
		}
		for (s = src.setSize; s < setSize; s++)
		{
			newSet.set[s] = set[s];
		}
	}
	delete [] set;
	setSize = newSet.setSize;
	set = new unsigned long [setSize];
	memcpy((void *)set, (void *)newSet.set, BYTESINSET(setSize));
	status = OK;
	return(*this);
}

/* intersection set operations */
Set 
Set::operator&(const Set &src)
{
	int size = (setSize >= src.setSize ? setSize : src.setSize);
	Set newSet(BITSINSET(size));
	if (setSize <= src.setSize)
	{
		for (int s = 0; s < setSize; s++)
		{
			newSet.set[s] = set[s] & src.set[s];
		}
		for (s = setSize; s < src.setSize; s++)
		{
			newSet.set[s] = 0;
		}
	}
	else
	{
		for (int s = 0; s < src.setSize; s++)
		{
			newSet.set[s] = set[s] & src.set[s];
		}
		for (s = src.setSize; s < setSize; s++)
		{
			newSet.set[s] = 0;
		}
	}
	status = OK;
	return(newSet);
}

Set &
Set::operator&=(const Set &src)
{
	int size = (setSize >= src.setSize ? setSize : src.setSize);
	Set newSet(BITSINSET(size));
	if (setSize <= src.setSize)
	{
		for (int s = 0; s < setSize; s++)
		{
			newSet.set[s] = set[s] & src.set[s];
		}
		for (s = setSize; s < src.setSize; s++)
		{
			newSet.set[s] = 0;
		}
	}
	else
	{
		for (int s = 0; s < src.setSize; s++)
		{
			newSet.set[s] = set[s] & src.set[s];
		}
		for (s = src.setSize; s < setSize; s++)
		{
			newSet.set[s] = 0;
		}
	}
	delete [] set;
	setSize = newSet.setSize;
	set = new unsigned long [setSize];
	memcpy((void *)set, (void *)newSet.set, BYTESINSET(setSize));
	status = OK;
	return(*this);
}

/* difference set operations */
Set 
Set::operator-(const Set &src)
{
	int size = (setSize >= src.setSize ? setSize : src.setSize);
	Set newSet(BITSINSET(size));
	if (setSize <= src.setSize)
	{
		for (int s = 0; s < setSize; s++)
		{
			newSet.set[s] = set[s] & ~src.set[s];
		}
		for (s = setSize; s < src.setSize; s++)
		{
			newSet.set[s] = 0;
		}
	}
	else
	{
		for (int s = 0; s < src.setSize; s++)
		{
			newSet.set[s] = set[s] & ~src.set[s];
		}
		for (s = src.setSize; s < setSize; s++)
		{
			newSet.set[s] = set[s];
		}
	}
	status = OK;
	return(newSet);
}

Set &
Set::operator-=(const Set &src)
{
	int size = (setSize >= src.setSize ? setSize : src.setSize);
	Set newSet(BITSINSET(size));
	if (setSize <= src.setSize)
	{
		for (int s = 0; s < setSize; s++)
		{
			newSet.set[s] = set[s] & ~src.set[s];
		}
		for (s = setSize; s < src.setSize; s++)
		{
			newSet.set[s] = 0;
		}
	}
	else
	{
		for (int s = 0; s < src.setSize; s++)
		{
			newSet.set[s] = set[s] & ~src.set[s];
		}
		for (s = src.setSize; s < setSize; s++)
		{
			newSet.set[s] = set[s];
		}
	}
	delete [] set;
	setSize = newSet.setSize;
	set = new unsigned long [setSize];
	memcpy((void *)set, (void *)newSet.set, BYTESINSET(setSize));
	status = OK;
	return(*this);
}

/* equality/assignment set operations */
Set &
Set::operator=(const Set &src)
{
	delete [] set;
	setSize = src.setSize;
	set = new unsigned long [setSize];
	memcpy((void *)set, (void *)src.set, BYTESINSET(setSize));
	status = OK;
	return(*this);
}

int
Set::operator==(const Set &src)
{
	status = OK;
	if (setSize <= src.setSize)
	{
		for (int s = 0; s < setSize; s++)
		{
			if (set[s] != src.set[s]) return(0);
		}
		for (s = setSize; s < src.setSize; s++)
		{
			if (src.set[s] != 0) return(0);
		}
	}
	else
	{
		for (int s = 0; s < src.setSize; s++)
		{
			if (set[s] != src.set[s]) return(0);
		}
		for (s = src.setSize; s < setSize; s++)
		{
			if (set[s] != 0) return(0);
		}
	}
	status = OK;
	return(1);
}

/* insert and delete operations */
Set &
Set::clear()
{
	delete [] set;
	setSize = MINIMUMSETSIZE;
	set = new unsigned long [setSize];
	memset((void *)set, 0, BYTESINSET(setSize));
	status = OK;
	return(*this);
}

Set &
Set::fill()
{
	memset((void *)set, ~0, BYTESINSET(setSize));
	status = OK;
	return(*this);
}

Set &
Set::insert(const int newMember)
{
	int whichLong = newMember/(ULONGSIZE*BITSINBYTE);
	int whichBit = newMember%(ULONGSIZE*BITSINBYTE);
	if (whichLong < setSize)
	{
		set[whichLong] |= ((unsigned long)1L << whichBit);
	}
	else
	{
		int newSetSize = whichLong + 1;
		unsigned long *newSet = new unsigned long [newSetSize];
		memset((void *)newSet, 0, BYTESINSET(newSetSize));
		memcpy((void *)newSet, (void *)set, BYTESINSET(setSize));
		newSet[whichLong] |= ((unsigned long)1L << whichBit);
		delete [] set;
		setSize = newSetSize;
		set = newSet;
	}
	status = OK;
	return(*this);
}

Set 
Set::operator+(const int newMember)
{
	Set newSet(*this);
	newSet.insert(newMember);
	status = OK;
	return(newSet);
}

Set &
Set::operator+=(const int newMember)
{
	return(insert(newMember));
}

Set &
Set::remove(const int exMember)
{
	int whichLong = exMember/(ULONGSIZE*BITSINBYTE);
	int whichBit = exMember%(ULONGSIZE*BITSINBYTE);
	if (whichLong < setSize)
	{
		set[whichLong] &= ~((unsigned long)1L << whichBit);
	}
	status = OK;
	return(*this);
}

Set 
Set::operator-(const int newMember)
{
	Set newSet(*this);
	newSet.remove(newMember);
	status = OK;
	return(newSet);
}

Set &
Set::operator-=(const int newMember)
{
	return(remove(newMember));
}

int
Set::isMember(const int possibleMember)
{
	long member = 0;
	int whichLong = possibleMember/(ULONGSIZE*BITSINBYTE);
	int whichBit = possibleMember%(ULONGSIZE*BITSINBYTE);
	if (whichLong < setSize)
	{
		member = set[whichLong] & ((unsigned long)1L << whichBit);
	}
	status = OK;
	return(member != 0);
}

int
Set::isEmpty()
{
	register unsigned long *ps, *psend;
	for (ps = set, psend = set + setSize; ps < psend; ps++)
	{
		if (*ps != 0) return(0);
	}
	return(1);
}

/* dump contents of set */
void
Set::dumpSet() const
{
	for (int s = 0; s < setSize; s++)
	{
		int base = s*ULONGSIZE*BITSINBYTE;
		for (int bit = 0; bit < ULONGSIZE*BITSINBYTE; bit++)
		{
			if (set[s] & ((unsigned long)1L << bit))
			{
				fprintf(stderr, "member = %d\n", base + bit);
			}
		}
	}
	return;
}

/* constructor for set iterator class */
SetIterator::SetIterator()
{
	nextLong = 0;
	nextBit = ULONGSIZE*BITSINBYTE;
	setSize = 0;
	set = (unsigned long *)0;
	status = OK;
}

SetIterator::SetIterator(const Set &src)
{
	nextLong = 0;
	nextBit = 0;
	setSize = src.setSize;
	set = src.set;
	status = OK;
}

SetIterator::SetIterator(const SetIterator &src)
{
	nextLong = 0;
	nextBit = 0;
	setSize = src.setSize;
	set = src.set;
	status = OK;
}

/* destructor for set iterator class */
SetIterator::~SetIterator()
{
	nextLong = 0;
	nextBit = ULONGSIZE*BITSINBYTE;
	setSize = 0;
	set = (unsigned long *)0;
	status = OK;
}

/* assignment operators */
SetIterator &
SetIterator::operator=(const Set &src)
{
	nextLong = 0;
	nextBit = 0;
	setSize = src.setSize;
	set = src.set;
	status = OK;
	return(*this);
}

SetIterator &
SetIterator::operator=(const SetIterator &src)
{
	nextLong = 0;
	nextBit = 0;
	setSize = src.setSize;
	set = src.set;
	status = OK;
	return(*this);
}

/* get next member in list */
int
SetIterator::operator()()
{
	status = OK;
	if (nextLong >= setSize) return(LASTMEMBER);
	if (nextBit >= ULONGSIZE*BITSINBYTE)
	{
		if (++nextLong >= setSize) return(LASTMEMBER);
		nextBit = 0;
	}
	for ( ; nextLong < setSize; nextLong++)
	{
		for ( ; nextBit < ULONGSIZE*BITSINBYTE; nextBit++)
		{
			if (set[nextLong] & ((unsigned long)1L << nextBit))
			{
				int member = 
					nextLong*ULONGSIZE*BITSINBYTE + nextBit;
				nextBit++;
				return(member);
			}
		}
		/* this has to be here since this code is re-entrant */
		nextBit = 0;
	}
	return(LASTMEMBER);
}
