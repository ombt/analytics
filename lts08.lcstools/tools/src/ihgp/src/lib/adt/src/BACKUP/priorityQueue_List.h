#ifndef __PRIORITY_QUEUE_LIST
#define __PRIORITY_QUEUE_LIST
// priority queue class definition

// headers
#include "absPriorityQueue.h"
#include "mylist.h"

// priority queue class
template <class DataType> class PriorityQueue_List: 
	public AbstractPriorityQueue<DataType> {
public:
        // constructors and destructor
        PriorityQueue_List();
        PriorityQueue_List(const PriorityQueue_List &);
        ~PriorityQueue_List();

        // assignment
        PriorityQueue_List &operator=(const PriorityQueue_List &);

        // priority queue operations
        void clear();
        int enqueue(const DataType &);
        int dequeue(DataType &);
        int front(DataType &) const;
        int isEmpty() const;

	// output data
	ostream &dump(ostream &) const;

protected:
        // data
        List<DataType> list;
};

#endif
