#ifndef __DEQUE_LIST_H
#define __DEQUE_LIST_H
// stack class definition

// headers
#include "absDeque.h"
#include "mylist.h"

// abstract stack class
template <class DataType> class Deque_List:
	public AbstractDeque<DataType> {
public:
        // destructor
        Deque_List();
        Deque_List(const Deque_List &);
        ~Deque_List();

	// assignment 
	Deque_List &operator=(const Deque_List &);

        // stack operations
        int push(const DataType &);
        int pop(DataType &);
        int top(DataType &) const;

        // queue operations
        int enqueue(const DataType &);
        int dequeue(DataType &);
        int front(DataType &) const;

	// shared operations
        void clear();
        int isEmpty() const;

	// output data
	ostream &dump(ostream &) const;

protected:
	// data
	List<DataType> list;
};

#endif

