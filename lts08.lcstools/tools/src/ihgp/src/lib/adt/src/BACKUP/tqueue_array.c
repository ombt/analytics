// headers
#include <stdlib.h>
#include <iostream.h>
#include "mystring.h"
#include "queue_Array.h"

main(int argc, char **argv)
{
	int arg;
	
	// size of queue
	Queue_Array<String> queue(atoi(argv[1]));

	// insert data items
	for (arg = 2; arg < argc; arg++)
	{
		MustBeTrue(queue.enqueue(String(argv[arg])) == OK);
	}
	cout << "queue after inserts is ... " << queue << endl;
	while (!queue.isEmpty())
	{
		String tmp;
		MustBeTrue(queue.dequeue(tmp) == OK);
		cout << "dequeued item is ... " << tmp << endl;
	}
	cout << "queue after deletes is ... " << queue << endl;

	return(0);
}
