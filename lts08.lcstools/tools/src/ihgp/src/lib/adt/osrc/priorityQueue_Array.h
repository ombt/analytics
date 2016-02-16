#ifndef __PRIORITY_QUEUE_HEAP
#define __PRIORITY_QUEUE_HEAP
// priority queue class definition

// headers
#include "absPriorityQueue.h"
#include "array.h"

// priority queue class
template <class DataType> class PriorityQueue_Array: 
	public AbstractPriorityQueue<DataType> {
public:
        // constructors and destructor
        PriorityQueue_Array(int);
        PriorityQueue_Array(const PriorityQueue_Array &);
        ~PriorityQueue_Array();

        // assignment
        PriorityQueue_Array &operator=(const PriorityQueue_Array &);

        // priority queue operations
        void clear();
        void enqueue(const DataType &);
        int dequeue(DataType &);
        int front(DataType &) const;
        int isEmpty() const;

	// output data
	ostream &dump(ostream &) const;

protected:
	// internal use only
	inline int parentOf(int node) const {
		return(node/2);
	}
	inline int leftChildOf(int node) const {
		return(2*node);
	}
	inline int rightChildOf(int node) const {
		return(2*node+1);
	}

protected:
        // data
	int size, last;
        Array<DataType> array;
};

#endif