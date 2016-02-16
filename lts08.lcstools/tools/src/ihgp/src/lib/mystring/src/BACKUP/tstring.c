#include "mystring.h"

int
main(int argc, char **argv)
{
	MustBeTrue(argc == 3);

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
	for (matcher_rk.reset(); ! matcher_rk.done(); matcher_rk++)
	{
		cout << "Match is at ... " << matcher_rk.location() << endl;
		cout << "Suffix is ... " << matcher_rk() << endl;
	}

	cout << "string tokenizer ..." << endl;
	string1 = argv[1];
	string2 = argv[2];
	StringTokens tokenizer(string1, string2);
	for (int i = 0; ! tokenizer.done() && i < 20; i++, tokenizer++)
	{
		cout << "Match is at ... " << tokenizer.location() << endl;
		cout << "Token is ... <" << tokenizer() << ">" << endl;
	}
	return(0);
}
