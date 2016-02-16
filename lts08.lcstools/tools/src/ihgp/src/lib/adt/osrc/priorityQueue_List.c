// member functions for priority queue class

// headers
#include "priorityQueue_List.h"

// constructors and destructor
template <class DataType>
PriorityQueue_List<DataType>::PriorityQueue_List(): 
	list()
{
        // do nothing
}

template <class DataType>
PriorityQueue_List<DataType>::PriorityQueue_List(
	const PriorityQueue_List<DataType> &pq): 
		list(pq.list)
{
        // do nothing
}

template <class DataType>
PriorityQueue_List<DataType>::~PriorityQueue_List()
{
        // do nothing
}

// assignment
template <class DataType>
PriorityQueue_List<DataType> &
PriorityQueue_List<DataType>::operator=(const PriorityQueue_List<DataType> &pq)
{
        if (this != &pq)
                list = pq.list;
        return(*this);
}

// queue operations
template <class DataType>
void 
PriorityQueue_List<DataType>::clear()
{
        list.clear();
        return;
}

template <class DataType>
void 
PriorityQueue_List<DataType>::enqueue(const DataType &data)
{
        list.insertByValue(data);
        return;
}

template <class DataType>
int 
PriorityQueue_List<DataType>::dequeue(DataType &data)
{
        return(list.removeAtFront(data));
}

template <class DataType>
int 
PriorityQueue_List<DataType>::front(DataType &data) const
{
        return(list.retrieveAtFront(data));
}

template <class DataType>
int 
PriorityQueue_List<DataType>::isEmpty() const
{
        return(list.isEmpty());
}

// print data
template <class DataType>
ostream &
PriorityQueue_List<DataType>::dump(ostream &os) const
{
	os << list;
        return(os);
}

