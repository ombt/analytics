// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "list.h"

main(int, char **argv)
{
	try {
	List<int> l;
	for (int i=1; i<atoi(argv[1]); i++)
	{
		cout << "data is ... " << i  << endl;
		l.insertAtFront(i);
		cout << l << endl;
	}
	cout << "dump using an iterator ... " << endl;
	ListIterator<int> li(l);
	for ( ; ! li.done(); li++)
	{
		cout << "element is ... " << li() << endl;
	}
	cout << "dump using a reverse iterator ... " << endl;
	ListIterator_Reverse<int> rli(l);
	for ( ; ! rli.done(); rli++)
	{
		cout << "element is ... " << rli() << endl;
	}
	for (i=1; i<atoi(argv[1]); i++)
	{
		int data;
		cout << l << endl;
		l.removeAtEnd(data);
		cout << "data is ... " << data  << endl;
	}
	cout << "dump using an iterator ... " << endl;
	for (li.reset() ; ! li.done(); li++)
	{
		cout << "element is ... " << li() << endl;
	}
	cout << "dump using reverse iterator ... " << endl;
	for (rli.reset() ; ! rli.done(); rli++)
	{
		cout << "element is ... " << rli() << endl;
	}
	for (i=1; i<atoi(argv[1]); i++)
	{
		cout << "data is ... " << i  << endl;
		l.insertAtFront(i);
		cout << l << endl;
	}
	int data = 4;
	cout << "data is ... " << data  << endl;
	l.removeByValue(data);
	cout << l << endl;
	data = 5;
	cout << "data is ... " << data  << endl;
	l.removeByValue(data);
	cout << l << endl;
	data = 2;
	cout << "data is ... " << data  << endl;
	l.removeByValue(data);
	cout << l << endl;
	data = 9;
	cout << "data is ... " << data  << endl;
	l.removeByValue(data);
	cout << l << endl;
	data = 1;
	cout << "data is ... " << data  << endl;
	l.removeByValue(data);
	cout << l << endl;
	l.clear();
	cout << l << endl;
	}
	catch (const char *msg) {
		cout << "EXCEPTION: " << msg << endl;
		abort();
	}
	return(0);
}
