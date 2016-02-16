#ifndef __QUEUE_ARRAY_H
#define __QUEUE_ARRAY_H
// queue class definition

// headers
#include "absQueue.h"
#include "array.h"

// abstract stack class
template <class DataType> class Queue_Array:
	public AbstractQueue<DataType> {
public:
        // destructor
        Queue_Array(int);
        Queue_Array(const Queue_Array &);
        ~Queue_Array();

	// assignment 
	Queue_Array &operator=(const Queue_Array &);

        // queue operations
        void clear();
        void enqueue(const DataType &);
        int dequeue(DataType &);
        int front(DataType &) const;
        int isEmpty() const;
        int isFull() const;

	// output data
	ostream &dump(ostream &) const;

protected:
	// data
	int start, end, full;
	Array<DataType> array;
};

#endif