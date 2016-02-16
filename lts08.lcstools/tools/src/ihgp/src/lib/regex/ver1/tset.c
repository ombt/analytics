/* test set class */
#include <sysent.h>
#include <stdlib.h>
#include "set.h"

main(int argc, char **argv)
{
	argc = argc;
	argv = argv;
	Set mySet1;
	if (mySet1.getStatus() != OK)
	{
		fprintf(stderr, "Set constructor failed.\n");
		exit(2);
	}
	int member;
	while ( 1 )
	{
		printf("enter member for set 1 : ");
		scanf("%d", &member);
		if (member < 0) break;
		mySet1 += member;
		if (mySet1.getStatus() != OK)
		{
			fprintf(stderr, "insert(%d) failed.\n", member);
			exit(2);
		}
	}
	printf("size of mySet1 is %d\n", mySet1.getSetSize());
	printf("start of dumpSet1()\n");
	mySet1.dumpSet();
	printf("end of dumpSet1()\n");
	Set mySet2;
	while ( 1 )
	{
		printf("enter member for set 2 : ");
		scanf("%d", &member);
		if (member < 0) break;
		mySet2 += member;
		if (mySet2.getStatus() != OK)
		{
			fprintf(stderr, "insert(%d) failed.\n", member);
			exit(2);
		}
	}
	printf("size of mySet2 is %d\n", mySet2.getSetSize());
	printf("start of dumpSet2()\n");
	mySet2.dumpSet();
	printf("end of dumpSet2()\n");
	Set result;
	printf("result = set1 | set2\n");
	result = mySet1 | mySet2;
	result.dumpSet();
	result.clear();
	printf("result = set1\n");
	printf("result |= set2\n");
	result = mySet1;
	result |= mySet2;
	result.dumpSet();
	result.clear();
	printf("result = set1 & set2\n");
	result = mySet1 & mySet2;
	result.dumpSet();
	result.clear();
	printf("result &= set1\n");
	result &= mySet1;
	result.dumpSet();
	result.clear();
	printf("result = set1 - set2\n");
	result = mySet1 - mySet2;
	result.dumpSet();
	result.clear();
	printf("result -= set1\n");
	result -= mySet1;
	result.dumpSet();
	result.clear();
	while ( 1 )
	{
		printf("member to remove from set 1 : ");
		scanf("%d", &member);
		if (member < 0) break;
		if (mySet1.isMember(member))
		{
			printf("member %d is part of set1.\n", member);
		}
		else
		{
			printf("member %d is NOT part of set1.\n", member);
		}
		mySet1 -= member;
		if (mySet1.getStatus() != OK)
		{
			fprintf(stderr, "insert(%d) failed.\n", member);
			exit(2);
		}
		if (mySet1.isMember(member))
		{
			printf("member %d is STILL part of set1.\n", member);
		}
		else
		{
			printf("member %d is NOT part of set1.\n", member);
		}
	}
	printf("size of mySet1 is %d\n", mySet1.getSetSize());
	printf("start of dumpSet1()\n");
	mySet1.dumpSet();
	printf("end of dumpSet1()\n");
	printf("using iterator constructor.\n");
	SetIterator setIter1(mySet1);
	while ((member = setIter1()) != LASTMEMBER)
	{
		printf("\"I'm a member\", say member %d.\n", member);
	}
	printf("using iterator copy constructor.\n");
	SetIterator setIter2(setIter1);
	while ((member = setIter2()) != LASTMEMBER)
	{
		printf("\"I'm a member\", say member %d.\n", member);
	}
	printf("using default constructor and assigment.\n");
	SetIterator setIter3;
	setIter3 = mySet1;
	while ((member = setIter3()) != LASTMEMBER)
	{
		printf("\"I'm a member\", say member %d.\n", member);
	}
	printf("using default constructor and assigment.\n");
	SetIterator setIter4;
	setIter4 = setIter2;
	while ((member = setIter4()) != LASTMEMBER)
	{
		printf("\"I'm a member\", say member %d.\n", member);
	}
	exit(0);
}
