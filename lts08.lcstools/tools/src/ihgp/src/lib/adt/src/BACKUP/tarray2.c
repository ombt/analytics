// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "array.h"
#include "mystring.h"

main(int argc, char **argv)
{
	// check input
	MustBeTrue(argc > 1);

	Array<String> strings(argc);
	for (int arg=0; arg < argc; arg++)
	{
		strings[arg] = argv[arg];
	}

	ArrayIterator<String> iter(strings);
	for ( ; ! iter.done(); iter++)
	{
		cout << iter() << endl;
	}

	ArrayIterator_Reverse<String> riter(strings);
	for ( ; ! riter.done(); riter++)
	{
		cout << riter() << endl;
	}

	return(0);
}
