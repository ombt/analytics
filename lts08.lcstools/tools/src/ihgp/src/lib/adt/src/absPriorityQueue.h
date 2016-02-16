#ifndef __ABSTRACT_PRIORITY_QUEUE_H
#define __ABSTRACT_PRIORITY_QUEUE_H
// abstract priority queue class definition

// required headers
#include <stdlib.h>
#include <iostream.h>

// local headers
#include "returns.h"
#include "debug.h"

#ifdef SUNCC
// forward definitions
template <class DataType> class AbstractPriorityQueue;

template <class DataType> 
ostream &
operator<<(ostream &, const AbstractPriorityQueue<DataType> &);
#endif

// abstract priority queue class
template <class DataType> class AbstractPriorityQueue {
public:
        // destructor
        virtual ~AbstractPriorityQueue() { }

        // priority queue operations
        virtual void clear() = 0;
        virtual int enqueue(const DataType &) = 0;
        virtual int dequeue(DataType &) = 0;
        virtual int front(DataType &) const = 0;
        virtual int isEmpty() const = 0;

	// output data
	virtual ostream &dump(ostream &) const = 0;
	friend ostream &operator<<(ostream &os, 
		const AbstractPriorityQueue<DataType> &abq) {
		abq.dump(os);
		return(os);
	}
};

#endif


