#include "string.h"

int
main(int argc, char **argv)
{
	assert(argc == 3);
	cout << "naive string matcher ..." << endl;
	String string1(argv[1]);
	String string2(argv[2]);
	StringMatcher matcher(string1, string2);
	for ( ; ! matcher.done(); matcher++)
	{
		cout << "Match is at ... " << matcher.location() << endl;
		cout << "Suffix is ... " << matcher() << endl;
	}
	cout << "rabin-karp string matcher ..." << endl;
	string1 = argv[1];
	string2 = argv[2];
	StringMatcher_RabinKarp matcher_rk(string1, string2);
	for ( ; ! matcher_rk.done(); matcher_rk++)
	{
		cout << "Match is at ... " << matcher_rk.location() << endl;
		cout << "Suffix is ... " << matcher_rk() << endl;
	}
	cout << "reset rabin-karp string matcher ..." << endl;
	matcher_rk.reset();
	for ( ; ! matcher_rk.done(); matcher_rk++)
	{
		cout << "Match is at ... " << matcher_rk.location() << endl;
		cout << "Suffix is ... " << matcher_rk() << endl;
	}
	return(0);
}
