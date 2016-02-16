// headers
#include <stdlib.h>
#include <iostream.h>
#include "mystring.h"
#include "priorityQueue_Array.h"
#include "random.h"

main(int argc, char **argv)
{
	int arg;
	
	// check options
	MustBeTrue(argc >= 3);

	// cmd args
	int qsz = atoi(argv[1]);
	int nchars = atoi(argv[2]);
	unsigned long seed = atol(argv[3]);
	
	// size of queue
	PriorityQueue_Array<String> queue(qsz);

	// seed for random number generator
	setKey(seed);

	// insert data items
	for (int ichar = 1; ichar <= nchars; ichar++)
	{
		char tmpchar = myrandomchar();
		String tmp(tmpchar);
		cout << "queued item is ... " << tmp << endl;
		MustBeTrue(queue.enqueue(tmp) == OK);
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
