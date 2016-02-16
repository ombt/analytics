// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "priorityQueue_List.h"
#include "random.h"

main(int, char **argv)
{
	int size = atoi(argv[1]);
	long key = atol(argv[2]);

	PriorityQueue_List<int> pq;

	setKey(key);

	cout << "pq is .. " << pq << endl;
	for (int i=1; i <= size; i++)
	{
		int data = random();
		cout << "data is ... " << data << endl;
		pq.enqueue(data);
		cout << "pq is .. " << pq << endl;
	}
	cout << "pq is .. " << pq << endl;
	while ( ! pq.isEmpty())
	{
		int data;
		cout << "pq is .. " << pq << endl;
		pq.dequeue(data);
		cout << "data is ... " << data  << endl;
	}
	return(0);
}
