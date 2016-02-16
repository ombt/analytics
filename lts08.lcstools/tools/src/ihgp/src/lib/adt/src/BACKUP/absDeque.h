#ifndef __ABSTRACT_DEQUE_H
#define __ABSTRACT_DEQUE_H
// abstract stack class definition

// required headers
#include <stdlib.h>
#include <iostream.h>

// local headers
#include "returns.h"
#include "debug.h"

// forward definitions
template <class DataType> class AbstractDeque;

template <class DataType> 
ostream &
operator<<(ostream &, const AbstractDeque<DataType> &);

// abstract stack class
template <class DataType> class AbstractDeque {
public:
        // destructor
        virtual ~AbstractDeque() { }

        // stack operations
        virtual int push(const DataType &) = 0;
        virtual int pop(DataType &) = 0;
        virtual int top(DataType &) const = 0;

        // queue operations
        virtual int enqueue(const DataType &) = 0;
        virtual int dequeue(DataType &) = 0;
        virtual int front(DataType &) const = 0;

	// shared operations
        virtual void clear() = 0;
        virtual int isEmpty() const = 0;

	// output data
	virtual ostream &dump(ostream &) const = 0;
	friend ostream &operator<<(ostream &, 
		const AbstractDeque<DataType> &);
};

// output function
template <class DataType> 
ostream &
operator<<(ostream &os, const AbstractDeque<DataType> &s)
{
	s.dump(os);
	return(os);
}

#endif

