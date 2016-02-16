// headers
#include <stdlib.h>
#include <iostream.h>
#include "mystring.h"
#include "deque_List.h"

main(int argc, char **argv)
{
	int arg;
	
	// queue
	Deque_List<String> deque;

	// insert data items
	for (arg = 2; arg < argc; arg++)
	{
		MustBeTrue(deque.enqueue(String(argv[arg])) == OK);
	}
	cout << "deque after inserts is ... " << deque << endl;
	while (!deque.isEmpty())
	{
		String tmp;
		MustBeTrue(deque.dequeue(tmp) == OK);
		cout << "dequeued item is ... " << tmp << endl;
	}
	cout << "queue after deletes is ... " << deque << endl;

	// insert data items
	for (arg = 2; arg < argc; arg++)
	{
		MustBeTrue(deque.push(String(argv[arg])) == OK);
	}
	cout << "stack after inserts is ... " << deque << endl;
	while (!deque.isEmpty())
	{
		String tmp;
		MustBeTrue(deque.pop(tmp) == OK);
		cout << "popped item is ... " << tmp << endl;
	}
	cout << "stack after deletes is ... " << deque << endl;

	return(0);
}