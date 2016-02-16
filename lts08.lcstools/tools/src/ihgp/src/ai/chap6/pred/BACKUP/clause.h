#ifndef __CLAUSE_H
#define __CLAUSE_H
// class definition for clauses 

// headers
#include <stdlib.h>
#include <iostream.h>

// local headers
#include "returns.h"
#include "debug.h"
#include "list.h"
#include "mystring.h"
#include "term.h"

// forward declarations
class ClauseIterator;

// clause class definitions
class Clause {
public:
	// friend classes
	friend class ClauseIterator;

	// constructors and destructor
	Clause();
	Clause(const Clause &);
	Clause(const List<Term> &, int = 0);
	~Clause();

	// assignment 
	Clause &operator=(const Clause &);

	// comparisons
	int operator==(const Clause &) const;
	int operator!=(const Clause &) const;

	// add or remove term from clause
	void insert(const Term &);
	void remove(Term &);
	void clear();

	// tests to run on a clause
	int isInClause(const Term &) const;
	int isEmpty() const;

	// access conclusion bit
	int getPartOfConclusion() const;
	void setPartOfConclusion(int);

	// dump data
	friend ostream &operator<<(ostream &, const Clause &);

protected:
	// internal data
	int partOfConclusion;
	List<Term> terms;
};

// clause iterator definition
class ClauseIterator {
public:
	// constructors and destructor
	ClauseIterator(const Clause &);
	ClauseIterator(const ClauseIterator &);
	~ClauseIterator();

	// reset iterator to start
	void reset();

	// check if at end of set
	int done() const;

	// return current member in set
	Term operator()();

	// advance to next set member
	int operator++(int);

private:
	// not allowed
	ClauseIterator &operator=(const ClauseIterator &);

protected:
	// internal data
	ListIterator<Term> iterator;
};

#endif


