// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "stack_List.h"

main(int, char **argv)
{
	int data;
	Stack_List<int> s;
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
	for (i=1; i<=atoi(argv[1]); i++)
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
	for (i=1; i<=atoi(argv[1]); i++)
	{
		cout << "pushing data ... " << i  << endl;
		s.push(i);
		cout << s << endl;
	}
	s.clear();
	cout << "cleared stack ... " << s << endl;
	return(0);
}
