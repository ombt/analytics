// headers
#include <stdlib.h>
#include <iostream.h>
#include "mystring.h"
#include "stack_Array.h"

main(int argc, char **argv)
{
	int arg;
	
	// size of stack
	Stack_Array<String> stack(atoi(argv[1]));

	// insert data items
	for (arg = 2; arg < argc; arg++)
	{
		MustBeTrue(stack.push(String(argv[arg])) == OK);
	}
	cout << "stack after inserts is ... " << stack << endl;
	while (!stack.isEmpty())
	{
		String tmp;
		MustBeTrue(stack.pop(tmp) == OK);
		cout << "popped item is ... " << tmp << endl;
	}
	cout << "stack after deletes is ... " << stack << endl;

	return(0);
}
