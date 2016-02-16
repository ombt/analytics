#ifndef __LIST_H
#define __LIST_H
// list class definition

// headers
#include <stdlib.h>
#include <iostream.h>

// local headers
#include "returns.h"
#include "debug.h"
#include "absIterator.h"

// forward declarations
template <class DT> class MyListItem;
template <class DT> class MyList;

// list item class
template <class DT> class MyListItem {
public:
        // friend classes and functions
        friend class MyList<DT>;

        // constructors and destructor
        MyListItem(const DT &);
        MyListItem(const MyListItem &);
        ~MyListItem();

        // assignment 
        MyListItem &operator=(const MyListItem &);

        // miscellaneous
        friend ostream &operator<<(ostream &, const MyList<DT> &);

protected:
        // internal data
        DT data;
        MyListItem<DT> *next;
        MyListItem<DT> *previous;
};

// list class
template <class DT> class MyList {
public:
        // constructors and destructor
        MyList();
        MyList(const MyList &);
        ~MyList();

        // assignment
        MyList &operator=(const MyList &);

        // I/O functions
        friend ostream &operator<<(ostream &, const MyList<DT> &);

protected:
        // internal data
	int count;
        MyListItem<DT> *first;
        MyListItem<DT> *last;
};

// list item constructors and destructor
template <class DT>
MyListItem<DT>::MyListItem(const DT &src):
	data(src), next(NULL), previous(NULL)
{
	// do nothing
}

template <class DT>
MyListItem<DT>::MyListItem(const MyListItem<DT> &item):
	data(item.data), next(NULL), previous(NULL)
{
	// do nothing
}

template <class DT>
MyListItem<DT>::~MyListItem()
{
	next = NULL;
	previous = NULL;
}

// assignment 
template <class DT>
MyListItem<DT> &
MyListItem<DT>::operator=(const MyListItem<DT> &item)
{
	// this can cause a memory leak !!!
	MustBeTrue(0);
	if (this != &item)
	{
		data = item.data;
		next = NULL;
		previous = NULL;
	}
	return(*this);
}

// print list item
template <class DT>
ostream &
operator<<(ostream &os, const MyListItem<DT> &item)
{
	os << item.data;
	return(os);
}

// list contructors and destructor
template <class DT>
MyList<DT>::MyList(): 
	count(0), first(NULL), last(NULL)
{
	// do nothing
}

template <class DT>
MyList<DT>::MyList(const MyList<DT> &list):
	count(0), first(NULL), last(NULL)
{
	for (MyListItem<DT> *pos = list.first; 
		pos != NULL; pos = pos->next)
	{
		// item count is updated by insert function
		insertAtEnd(pos->data);
	}
}

template <class DT>
MyList<DT>::~MyList()
{
	for (MyListItem<DT> *pos = first; pos != NULL; )
	{
		MyListItem<DT> *save = pos->next;
		delete pos;
		pos = save;
	}
	count = 0;
	first = last = NULL;
}

// print list
template <class DT>
ostream &
operator<<(ostream &os, const MyList<DT> &l)
{
	os << "{ ";
	for (MyListItem<DT> *pos = l.first; pos != NULL; pos = pos->next)
	{
		os << pos->data << ",";
	}
	os << " }" << endl;
	return(os);
}

#endif
