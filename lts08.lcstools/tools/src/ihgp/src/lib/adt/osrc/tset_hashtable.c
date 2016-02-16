#include "random.h"
#include "set_HashTable.h"

int
hash(const int &data)
{
	return(data);
}

int
main(int argc, char **argv)
{
	// check arguments
	if (argc != 4)
	{
		cerr << "usage: " << argv[0];
		cerr << " seed tablesz number_of_members" << endl;
		return(2);
	}

	// get arguments
	unsigned long key = atol(argv[1]);
	int hashsz = atoi(argv[2]);
	int mmax = atoi(argv[3]);

	// set key for random number generator
	setKey(key);

	// create sets
	Set_HashTable<int> set1(hashsz, hash);
	Set_HashTable<int> set2(set1);

	// add members to sets
	for (int im = 1; im <= mmax; im++)
	{
		unsigned long newm = random();
		set1 += newm;
	}
	cerr << "set1 is  ... " << set1 << endl;
	for (im = 1; im <= mmax; im++)
	{
		unsigned long newm = random();
		set2 += newm;
	}
	cerr << "set2 is  ... " << set2 << endl;

	// union of sets
	Set_HashTable<int> set3(set1|set2);
	cerr << "set3 = set1|set2 = " << set3 << endl;
	
	// intersection of sets
	Set_HashTable<int> set4(set3&set2);
	cerr << "set4 = set3&set2 = " << set4 << endl;
	
	// difference of sets
	Set_HashTable<int> set5(set4-set2);
	cerr << "set5 = set4-set2 = " << set5 << endl;
	
	return(0);
}
