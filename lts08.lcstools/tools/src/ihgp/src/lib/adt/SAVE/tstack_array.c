// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "stack_Array.h"

main(int, char **argv)
{
	int data;
	Stack_Array<int> s(atoi(argv[1]));
	for (int i=1; i<=atoi(argv[1]); i++)
	{
		cout << "pushing data ... " << i  << endl;
		s.push(i);
		cout << s << endl;
	}
	for (i=1; i<=atoi(argv[1]); i++)
	{
		cout << s << endl;
		s.pop(data);
		cout << "popping data ... " << data  << endl;
	}
	s.clear();
	for (i=1; ! s.isFull(); i++)
	{
		cout << "pushing data ... " << i  << endl;
		s.push(i);
		cout << s << endl;
	}
	while ( ! s.isEmpty())
	{
		cout << s << endl;
		s.pop(data);
		cout << "popping data ... " << data  << endl;
	}
	for (i=1; ! s.isFull(); i++)
	{
		cout << "pushing data ... " << i  << endl;
		s.push(i);
		cout << s << endl;
	}
	s.clear();
	cout << "cleared stack ... " << s << endl;
	return(0);
}
