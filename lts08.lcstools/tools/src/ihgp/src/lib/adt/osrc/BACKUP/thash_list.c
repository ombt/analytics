// headers
#include <stdlib.h>
#include <iostream.h>
#include <assert.h>
#include "random.h"
#include "hashTable_List.h"
#include "list.h"
#include "tuple.h"

int
myhf(const Tuple<int, int> &data)
{
	return(data.key);
}

main(int argc, char **argv)
{
	// get options
	assert(argc == 4);
	int seed = atoi(argv[1]);
	int howmany = atoi(argv[2]);
	int tblsz = atoi(argv[3]);

	// set random gernerator
	setKey(seed);

	// generate list of random numbers
	cerr << "inserting data ... " << endl;
	List<Tuple<int, int> > l;
	for (int i=1; i < howmany; i++)
	{
		Tuple<int, int> tuple(random(), random());
		l.insertAtEnd(tuple);
	}
	cerr << "FINAL list is ... " << l << endl;

	// create hash table
	HashTable_List<Tuple<int, int> > hta(tblsz, myhf);

	// insert into hash table
	ListIterator<Tuple<int, int> >  li(l);
	for ( ; ! li.done(); li++)
	{
		hta.insert(li());
	}
	cerr << "FINAL hash table is ... " << hta << endl;

	// check if everything is in table
	for (li.reset() ; ! li.done(); li++)
	{
		Tuple<int, int> tuple;
		tuple.key = li().key;
		tuple.data = 0;
		cerr << " retrieving for ... " << tuple.key << endl;
		if (hta.retrieve(tuple) != OK)
			cerr << "retrieve failed for ... ";
		else
			cerr << "retrieved data is ... ";
		cerr << tuple << endl;
	}

	// dump array using an iterator
	HashTable_List_Iterator<Tuple<int, int> > htai(hta);
	for ( ; ! htai.done(); htai++)
	{
		cerr << "contents are ... " << htai() << endl;
	}

	// delete everything in table
	for (li.reset() ; ! li.done(); li++)
	{
		Tuple<int, int> tuple;
		tuple.key = li().key;
		tuple.data = 0;
		cerr << "deleting for ... " << tuple.key << endl;
		if (hta.remove(tuple) != OK)
			cerr << "delete failed for ... ";
		else
			cerr << "deleted data is ... ";
		cerr << tuple << endl;
		cerr << "hash table is ... " << hta << endl;
	}

	return(0);
}
