#ifndef __TRIE_H
#define __TRIE_H
// trie class definitions

// headers
#include <stdlib.h>
#include <iostream.h>

// local headers
#include "returns.h"
#include "debug.h"
#include "gstring.h"
#include "queue_List.h"

// forward declarations
template <class DataType> class TrieNode;
template <class DataType> class Trie;
template <class DataType> class TrieIterator;

// forward declarations of friend functions 
template <class DataType> 
ostream &
operator<<(ostream &, TrieNode<DataType> &);

template <class DataType> 
ostream &
operator<<(ostream &, Trie<DataType> &);

// trie node class
template <class DataType> class TrieNode {
public:
	// output
	friend ostream &operator<< <>(ostream &os, TrieNode<DataType> &);

protected:
        // friend classes 
        friend class Trie<DataType>;
	friend class TrieIterator<DataType>;

        // constructors and destructor
        TrieNode(const DataType &);
        TrieNode(const TrieNode<DataType> &);
        ~TrieNode();

	// assignment
        TrieNode<DataType> &operator=(const TrieNode<DataType> &);

        // internal data
	int isaword;
        DataType data;
        TrieNode<DataType> *sibling;
        TrieNode<DataType> *children;
};

// trie class
template <class DataType> class Trie 
{
public:
	// friend classes 
	friend class TrieIterator<DataType>;

        // constructors and destructor
        Trie();
        Trie(const GString<DataType> &);
        Trie(const Trie<DataType> &);
        ~Trie();

        // assignment
        Trie<DataType> &operator=(const Trie<DataType> &);
        Trie<DataType> &operator=(const GString<DataType> &);

        // trie operations
        int insert(const GString<DataType> &);
        int remove(const GString<DataType> &);
        int includes(const GString<DataType> &) const;
	int isEmpty() const;
        void clear();

        // miscellaneous
        ostream &dump(ostream &) const;

	// output
	friend ostream &operator<< <>(ostream &, Trie<DataType> &);

protected:
	// utility functions
        void dump(const TrieNode<DataType> *, GString<DataType>, 
			ostream &) const;
	int insert(TrieNode<DataType> *&, const GString<DataType> &, int);
	int createpath(TrieNode<DataType> *&, const GString<DataType> &, int);
	TrieNode<DataType> *copy() const;
	TrieNode<DataType> *copy(const TrieNode<DataType> *) const;
        void clear(TrieNode<DataType> *&);
        int includes(const TrieNode<DataType> *, const GString<DataType> &,
			int) const;
	int remove(TrieNode<DataType> *&, const GString<DataType> &, int);

protected:
        // internal data
        TrieNode<DataType> *root;
};

// depth-first trie iterator
template <class DataType> class TrieIterator {
public:
        // constructors and destructor
        TrieIterator(const Trie<DataType> &);
        TrieIterator(const TrieIterator<DataType> &);
        ~TrieIterator();

	// reset iterator to start
	void reset();

	// check if at end of list
	int done() const;

        // return data 
        GString<DataType> operator()();

	// advance iterator to next link
	int operator++(int);

private:
	// not allowed
        TrieIterator();
        TrieIterator &operator=(const TrieIterator<DataType> &);

	// utility functions
	void reset(Queue_List<GString<DataType> > &,
		const TrieNode<DataType> *, GString<DataType>);

protected:
        // internal data
	const Trie<DataType> &trie;
	Queue_List<GString<DataType> > queue;
};

#endif

