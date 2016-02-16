// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "queue_Array.h"

main(int, char **argv)
{
	int data;
	Queue_Array<int> q(atoi(argv[1]));
	for (int i=1; i<=atoi(argv[1]); i++)
	{
		cout << "queueing data ... " << i  << endl;
		q.enqueue(i);
		cout << q << endl;
	}
	for (i=1; i<=atoi(argv[1]); i++)
	{
		cout << q << endl;
		q.dequeue(data);
		cout << "dequeueing data ... " << data  << endl;
	}
	q.clear();
	for (i=1; ! q.isFull(); i++)
	{
		cout << "queueing data ... " << i  << endl;
		q.enqueue(i);
		cout << q << endl;
	}
	while ( ! q.isEmpty())
	{
		cout << q << endl;
		q.dequeue(data);
		cout << "dequeueing data ... " << data  << endl;
	}
	for (i=1; ! q.isFull(); i++)
	{
		cout << "queueing data ... " << i  << endl;
		q.enqueue(i);
		cout << q << endl;
	}
	q.clear();
	cout << "cleared queue ... " << q << endl;
	return(0);
}
