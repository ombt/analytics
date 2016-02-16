// functions for clause class

// headers
#include "clause.h"

// constructors and destructor
Clause::Clause():
	partOfConclusion(0), terms()
{
	// nothing to do
}

Clause::Clause(const Clause &src):
	partOfConclusion(src.partOfConclusion), terms(src.terms)
{
	// nothing to do
}

Clause::Clause(const List<Term> &alist, int poc):
	partOfConclusion(poc), terms(alist)
{
	// nothing to do
}

Clause::~Clause()
{
	// nothing to do
}

// assignment operator
Clause &
Clause::operator=(const Clause &rhs)
{
	if (this != &rhs)
	{
		partOfConclusion = rhs.partOfConclusion;
		terms = rhs.terms;
	}
	return(*this);
}

// comparison operators
int
Clause::operator==(const Clause &rhs) const
{
	ListIterator<Term> ti(terms);
	ListIterator<Term> rhsti(rhs.terms);
	for ( ; !ti.done() && !rhsti.done(); ti++, rhsti++)
	{
		if (ti().predicate() != rhsti().predicate())
			return(0);
	}
	if (ti.done() && rhsti.done())
		return(1);
	else
		return(0);
}

int
Clause::operator!=(const Clause &rhs) const
{
	ListIterator<Term> ti(terms);
	ListIterator<Term> rhsti(rhs.terms);
	for ( ; !ti.done() && !rhsti.done(); ti++, rhsti++)
	{
		if (ti().predicate() != rhsti().predicate())
			return(1);
	}
	if (ti.done() && rhsti.done())
		return(0);
	else
		return(1);
}

// access functions
void
Clause::insert(const Term &term)
{
	terms.insert(term);
}

void
Clause::remove(Term &term)
{
	terms.remove(term);
}

int
Clause::isInClause(const Term &term) const
{
	return(terms.includes(term));
}

void
Clause::clear()
{
	terms.clear();
}

int
Clause::isEmpty() const
{
	return(terms.isEmpty());
}

// access conclusion data
int
Clause::getPartOfConclusion() const
{
	return(partOfConclusion);
}

void
Clause::setPartOfConclusion(int poc)
{
	partOfConclusion = poc;
}

// print contents of clauses
ostream &
operator<<(ostream &os, const Clause &c)
{
	ListIterator<Term> cIter(c.terms);
	for (int first = 1; !cIter.done(); cIter++)
	{
		if (first)
		{
			first = 0;
			os << cIter();
		}
		else
			os << "|| " << cIter();
	}
	return(os);
}

// constructors and destructor for iterator class for clauses class
ClauseIterator::ClauseIterator(const Clause &clause):
	iterator(clause.terms)
{
	// do nothing
}

ClauseIterator::ClauseIterator(const ClauseIterator &clauseIter):
	iterator(clauseIter.iterator)
{
	// do nothing
}

ClauseIterator::~ClauseIterator()
{
	// do nothing
}

// reset iterator to start
void
ClauseIterator::reset()
{
	iterator.reset();
}

// is iterator done?
int
ClauseIterator::done() const
{
	return(iterator.done());
}

Term
ClauseIterator::operator()()
{
	return(iterator());
}

int
ClauseIterator::operator++(int)
{
	return(iterator++);
}

