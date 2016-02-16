/* member functions for link list class */

/* unix headers */
#include <stdio.h>

/* other headers */
#include "linkList.h"

/* constructor for link class */
Link::Link()
{
	next = previous = (Link *)0;
	status = OK;
}

/* destructor for link class */
Link::~Link()
{
	if (next) next->previous = previous;
	if (previous) previous->next = next;
	next = 0;
	previous = 0;
	status = OK;
}

/* constructor for list class */
List::List()
{
	first = last = (Link *)0;
	status = OK;
}

/* destructor for list class */
List::~List()
{
	Link *link, *save;
	for (link = first; link != (Link *)0; )
	{
		save = link->next;
		delete link;
		link = save;
	}
	status = OK;
}

/* add a new link at the end of list */
List &
List::append(Link *link)
{
	if (last)
	{
		last->next = link;
		link->previous = last;
	}
	else
	{
		first = link;
	}
	last = link;
	status = OK;
	return(*this);
}

/* add a new link at front of list */
List &
List::prepend(Link *link)
{
	if (first)
	{
		first->previous = link;
		link->next = first;
	}
	else
	{
		last = link;
	}
	first = link;
	status = OK;
	return(*this);
}

/* remove link from list */
List &
List::remove(Link *link)
{
	if (link == first) first = first->next;
	if (link == last) last = last->previous;
	if (link->next)
	{
		link->next->previous = link->previous;
	}
	if (link->previous)
	{
		link->previous->next = link->next;
	}
	link->next = (Link *)0;
	link->previous = (Link *)0;
	status = OK;
	return(*this);
}

/* constructor for iterator class */
Iterator::Iterator()
{
	next = (Link *)0;
	status = OK;
}

Iterator::Iterator(const Iterator &src)
{
	next = src.next;
	status = OK;
}

Iterator::Iterator(const List &list)
{
	next = list.first;
	status = OK;
}

/* destructor for iterator class */
Iterator::~Iterator()
{
	next = (Link *)0;
	status = OK;
}

/* iterator function */
Link*
Iterator::operator()()
{
	Link *save = next;
	status = OK;
	if (save)
	{
		next = next->getNext();
		status = save->getStatus();
	}
	return(save);
}

/* assignment */
Iterator &
Iterator::operator=(const Iterator &src)
{
	next = src.next;
	status = OK;
	return(*this);
}

Iterator &
Iterator::operator=(const List &list)
{
	next = list.first;
	status = OK;
	return(*this);
}
