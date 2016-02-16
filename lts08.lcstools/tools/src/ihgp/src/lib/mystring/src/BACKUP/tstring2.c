#include "mystring.h"

int
main(int argc, char **argv)
{
	MustBeTrue(argc == 3);

	String string1(argv[1]);
	String string2(argv[2]);

	cout << "string to scan is ... <" << string1 << ">" << endl;
	cout << "delimiters are ... <" << string2 << ">" << endl;

	cout << "string tokenizer ..." << endl;
	StringTokens tokenizer(string1, string2);

	for ( ; ! tokenizer.done(); tokenizer++)
	{
		cout << "match is at ... " << tokenizer.location() << endl;
		cout << "token is ... <" << tokenizer() << ">" << endl;
	}
	return(0);
}
