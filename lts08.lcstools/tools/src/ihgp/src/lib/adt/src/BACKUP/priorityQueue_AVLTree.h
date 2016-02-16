#ifndef __PRIORITY_QUEUE_LIST
#define __PRIORITY_QUEUE_LIST
// priority queue class definition

// headers
#include "absPriorityQueue.h"
#include "binaryTree_AVL.h"

// priority queue class
template <class DataType> class PriorityQueue_AVLTree: 
	public AbstractPriorityQueue<DataType> {
public:
        // constructors and destructor
        PriorityQueue_AVLTree();
        PriorityQueue_AVLTree(const PriorityQueue_AVLTree &);
        ~PriorityQueue_AVLTree();

        // assignment
        PriorityQueue_AVLTree &operator=(const PriorityQueue_AVLTree &);

        // priority queue operations
        void clear();
        int enqueue(const DataType &);
        int dequeue(DataType &);
        int front(DataType &) const;
        int isEmpty() const;

	// additional operations
	int includes(const DataType &) const;

	// output data
	ostream &dump(ostream &) const;

protected:
        // data
        BinaryTree_AVL<DataType> tree;
};

#endif