// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "mystring.h"
#include "mylist.h"

main(int argc, char **argv)
{
	int irec;
	String cmd, string;
	List<String> list;

	while (cmd != String("q"))
	{
		cout << "enter command [r/u/d/i/q=quit]: ";
		cin >> cmd;

		if (cmd(0,1) == String("r"))
		{
			cout << "RETRIEVE OPERATION ..." << endl;
			cout << "enter N: ";
			cin >> irec;
			if (list.retrieveNth(irec, string) != OK)
			{
				cout << "retrieve failed" << endl;
			}
			else
			{
				cout << "string is ... " << string << endl;
			}
		}
		else if (cmd(0,1) == String("u"))
		{
			cout << "UPDATE OPERATION ..." << endl;
			cout << "enter N: ";
			cin >> irec;
			cout << "enter string: ";
			cin >> string;
			if (list.updateNth(irec, string) != OK)
			{
				cout << "update failed" << endl;
			}
		}
		else if (cmd(0,1) == String("d"))
		{
			cout << "REMOVE OPERATION ..." << endl;
			cout << "enter N: ";
			cin >> irec;
			if (list.removeNth(irec, string) != OK)
			{
				cout << "remove failed" << endl;
			}
			else
			{
				cout << "string is ... " << string << endl;
			}
		}
		else if (cmd(0,1) == String("i"))
		{
			cout << "INSERT OPERATION ..." << endl;
			cout << "enter N: ";
			cin >> irec;
			cout << "enter string: ";
			cin >> string;
			if (list.insertNth(irec, string) != OK)
			{
				cout << "insert failed" << endl;
			}
		}
		cout << "LIST IS ... " << list << endl;
	}
	return(0);
}
