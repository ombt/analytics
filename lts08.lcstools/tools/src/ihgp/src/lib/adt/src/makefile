
.SUFFIXES:		.o .C .CPP .c .cpp

LEXFLAGS = -n
YACC = /usr/ccs/bin/yacc
YACCFLAGS = -d -v
LEX = /usr/ccs/bin/lex
MAKE = make
LDFLAGS = -g -xildoff
LD = CC
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -DDEBUG -g -xildoff
INCLDIRS = 
CC = CC
LPRFLAGS = 
AR = /usr/ccs/bin/ar
LPR = mycpr2on1
ENDLIST = 

.c.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<
.C.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<
.cpp.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<
.CPP.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<

all:		tlist2 \
		tlist \
		tbinary_NR \
		tbinary_mutable \
		tpqueue_list \
		tbinaryCUJ \
		thash_array \
		tarray \
		tqueue_array \
		tbinary2 \
		toset2 \
		tmap \
		tarray2 \
		tprime \
		tbinary \
		tbinary_AVL2 \
		tbinary_array \
		tstack_list \
		talphabet \
		tdeque_list \
		tstack_array \
		tbinary_AVL \
		tset_bitvector \
		tset_hashtable \
		tqueue_list \
		tpqueue_array \
		tmap2 \
		tpqueue_avltree \
		thash_list \
		toset \
		tset_list \
		$(ENDLIST)
		touch all

tlist2:		tlist2.o \
		mylist.o \
		mystring.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tlist2 \
			tlist2.o \
			mylist.o \
			mystring.o \
			$(ENDLIST)

tlist:		tlist.o \
		mystring.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tlist \
			tlist.o \
			mystring.o \
			mylist.o \
			$(ENDLIST)

tbinary_NR:		tbinary_NR.o \
		binaryTree_NR.o \
		mystring.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_NR \
			tbinary_NR.o \
			binaryTree_NR.o \
			mystring.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			$(ENDLIST)

tbinary_mutable:		tbinary_mutable.o \
		binaryTree2.o \
		mystring.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_mutable \
			tbinary_mutable.o \
			binaryTree2.o \
			mystring.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			$(ENDLIST)

tpqueue_list:		tpqueue_list.o \
		priorityQueue_List.o \
		mylist.o \
		mystring.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tpqueue_list \
			tpqueue_list.o \
			priorityQueue_List.o \
			mylist.o \
			mystring.o \
			random.o \
			$(ENDLIST)

tbinaryCUJ:		tbinaryCUJ.o \
		binaryTree2.o \
		mystring.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinaryCUJ \
			tbinaryCUJ.o \
			binaryTree2.o \
			mystring.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			$(ENDLIST)

thash_array:		thash_array.o \
		hashTable_Array.o \
		array.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o thash_array \
			thash_array.o \
			hashTable_Array.o \
			array.o \
			random.o \
			$(ENDLIST)

tarray:		tarray.o \
		array.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tarray \
			tarray.o \
			array.o \
			$(ENDLIST)

tqueue_array:		tqueue_array.o \
		queue_Array.o \
		array.o \
		mystring.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tqueue_array \
			tqueue_array.o \
			queue_Array.o \
			array.o \
			mystring.o \
			$(ENDLIST)

tbinary2:		tbinary2.o \
		binaryTree2.o \
		mystring.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary2 \
			tbinary2.o \
			binaryTree2.o \
			mystring.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			$(ENDLIST)

toset2:		toset2.o \
		orderedset.o \
		binaryTree.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o toset2 \
			toset2.o \
			orderedset.o \
			binaryTree.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			$(ENDLIST)

tmap:		tmap.o \
		map.o \
		binaryTree.o \
		stack_List.o \
		queue_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tmap \
			tmap.o \
			map.o \
			binaryTree.o \
			stack_List.o \
			queue_List.o \
			mylist.o \
			$(ENDLIST)

tarray2:		tarray2.o \
		array.o \
		mystring.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tarray2 \
			tarray2.o \
			array.o \
			mystring.o \
			$(ENDLIST)

tprime:		tprime.o \
		prime.o \
		set_BitVector.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tprime \
			tprime.o \
			prime.o \
			set_BitVector.o \
			$(ENDLIST)

tbinary:		tbinary.o \
		binaryTree.o \
		mystring.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary \
			tbinary.o \
			binaryTree.o \
			mystring.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			$(ENDLIST)

tbinary_AVL2:		tbinary_AVL2.o \
		binaryTree_AVL.o \
		mystring.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_AVL2 \
			tbinary_AVL2.o \
			binaryTree_AVL.o \
			mystring.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			random.o \
			$(ENDLIST)

tbinary_array:		tbinary_array.o \
		binaryTree_Array.o \
		mystring.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_array \
			tbinary_array.o \
			binaryTree_Array.o \
			mystring.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			$(ENDLIST)

tstack_list:		tstack_list.o \
		stack_List.o \
		mylist.o \
		mystring.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tstack_list \
			tstack_list.o \
			stack_List.o \
			mylist.o \
			mystring.o \
			$(ENDLIST)

talphabet:		talphabet.o \
		alphabet.o \
		binaryTree_AVL.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		array.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o talphabet \
			talphabet.o \
			alphabet.o \
			binaryTree_AVL.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			array.o \
			random.o \
			$(ENDLIST)

tdeque_list:		tdeque_list.o \
		deque_List.o \
		mylist.o \
		mystring.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tdeque_list \
			tdeque_list.o \
			deque_List.o \
			mylist.o \
			mystring.o \
			$(ENDLIST)

tstack_array:		tstack_array.o \
		stack_Array.o \
		array.o \
		mystring.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tstack_array \
			tstack_array.o \
			stack_Array.o \
			array.o \
			mystring.o \
			$(ENDLIST)

tbinary_AVL:		tbinary_AVL.o \
		binaryTree_AVL.o \
		mystring.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_AVL \
			tbinary_AVL.o \
			binaryTree_AVL.o \
			mystring.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			$(ENDLIST)

tset_bitvector:		tset_bitvector.o \
		set_BitVector.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tset_bitvector \
			tset_bitvector.o \
			set_BitVector.o \
			random.o \
			$(ENDLIST)

tset_hashtable:		tset_hashtable.o \
		hashTable_List.o \
		mylist.o \
		array.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tset_hashtable \
			tset_hashtable.o \
			hashTable_List.o \
			mylist.o \
			array.o \
			random.o \
			$(ENDLIST)

tqueue_list:		tqueue_list.o \
		queue_List.o \
		mylist.o \
		mystring.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tqueue_list \
			tqueue_list.o \
			queue_List.o \
			mylist.o \
			mystring.o \
			$(ENDLIST)

tpqueue_array:		tpqueue_array.o \
		priorityQueue_Array.o \
		array.o \
		mylist.o \
		mystring.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tpqueue_array \
			tpqueue_array.o \
			priorityQueue_Array.o \
			array.o \
			mylist.o \
			mystring.o \
			random.o \
			$(ENDLIST)

tmap2:		tmap2.o \
		map.o \
		binaryTree.o \
		stack_List.o \
		queue_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tmap2 \
			tmap2.o \
			map.o \
			binaryTree.o \
			stack_List.o \
			queue_List.o \
			mylist.o \
			$(ENDLIST)

tpqueue_avltree:		tpqueue_avltree.o \
		priorityQueue_AVLTree.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		mystring.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tpqueue_avltree \
			tpqueue_avltree.o \
			priorityQueue_AVLTree.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			mystring.o \
			random.o \
			$(ENDLIST)

thash_list:		thash_list.o \
		hashTable_List.o \
		array.o \
		mylist.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o thash_list \
			thash_list.o \
			hashTable_List.o \
			array.o \
			mylist.o \
			random.o \
			$(ENDLIST)

toset:		toset.o \
		orderedset.o \
		binaryTree.o \
		queue_List.o \
		stack_List.o \
		mylist.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o toset \
			toset.o \
			orderedset.o \
			binaryTree.o \
			queue_List.o \
			stack_List.o \
			mylist.o \
			$(ENDLIST)

tset_list:		tset_list.o \
		set_List.o \
		mylist.o \
		array.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tset_list \
			tset_list.o \
			set_List.o \
			mylist.o \
			array.o \
			random.o \
			$(ENDLIST)

random.o:	random.c \
		$(ENDLIST)

mystring.o:	mystring.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

deque_List.o:	deque_List.c \
		./deque_List.h \
		./absDeque.h \
		./debug.h \
		./returns.h \
		./mylist.h \
		./absIterator.h \
		$(ENDLIST)

orderedset.o:	orderedset.c \
		./orderedset.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./binaryTree.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./tuple.h \
		$(ENDLIST)

binaryTree2.o:	binaryTree2.c \
		./binaryTree2.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		$(ENDLIST)

tqueue_array.o:	tqueue_array.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		./queue_Array.h \
		./absQueue.h \
		./array.h \
		./absIterator.h \
		$(ENDLIST)

tpqueue_list.o:	tpqueue_list.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		./priorityQueue_List.h \
		./absPriorityQueue.h \
		./mylist.h \
		./absIterator.h \
		./random.h \
		$(ENDLIST)

stack_Array.o:	stack_Array.c \
		./stack_Array.h \
		./absStack.h \
		./debug.h \
		./returns.h \
		./array.h \
		./absIterator.h \
		$(ENDLIST)

tbinary_array.o:	tbinary_array.c \
		./binaryTree_Array.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./mystring.h \
		$(ENDLIST)

tmap2.o:	tmap2.c \
		./map.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./binaryTree.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./tuple.h \
		$(ENDLIST)

tbinary_AVL2.o:	tbinary_AVL2.c \
		./binaryTree_AVL.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./random.h \
		$(ENDLIST)

tbinary.o:	tbinary.c \
		./binaryTree.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./mystring.h \
		$(ENDLIST)

toset.o:	toset.c \
		./orderedset.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./binaryTree.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./tuple.h \
		$(ENDLIST)

binaryTree_Array.o:	binaryTree_Array.c \
		./binaryTree_Array.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		$(ENDLIST)

tpqueue_array.o:	tpqueue_array.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		./priorityQueue_Array.h \
		./absPriorityQueue.h \
		./array.h \
		./absIterator.h \
		./random.h \
		$(ENDLIST)

hashTable_List.o:	hashTable_List.c \
		./hashTable_List.h \
		./absHashTable.h \
		./debug.h \
		./returns.h \
		./absIterator.h \
		./array.h \
		./mylist.h \
		$(ENDLIST)

tarray2.o:	tarray2.c \
		./array.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./mystring.h \
		$(ENDLIST)

tstack_array.o:	tstack_array.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		./stack_Array.h \
		./absStack.h \
		./array.h \
		./absIterator.h \
		$(ENDLIST)

tset_bitvector.o:	tset_bitvector.c \
		./random.h \
		./set_BitVector.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

alphabet.o:	alphabet.c \
		./alphabet.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./binaryTree_AVL.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./tuple.h \
		$(ENDLIST)

mylist.o:	mylist.c \
		./mylist.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

priorityQueue_List.o:	priorityQueue_List.c \
		./priorityQueue_List.h \
		./absPriorityQueue.h \
		./debug.h \
		./returns.h \
		./mylist.h \
		./absIterator.h \
		$(ENDLIST)

tlist.o:	tlist.c \
		./mylist.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./mystring.h \
		$(ENDLIST)

tpqueue_avltree.o:	tpqueue_avltree.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		./priorityQueue_AVLTree.h \
		./absPriorityQueue.h \
		./binaryTree_AVL.h \
		./absIterator.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./random.h \
		$(ENDLIST)

priorityQueue_Array.o:	priorityQueue_Array.c \
		./array.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./priorityQueue_Array.h \
		./absPriorityQueue.h \
		$(ENDLIST)

map.o:	map.c \
		./map.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./binaryTree.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./tuple.h \
		$(ENDLIST)

set_BitVector.o:	set_BitVector.c \
		./set_BitVector.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tarray.o:	tarray.c \
		./array.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

array.o:	array.c \
		./array.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

thash_list.o:	thash_list.c \
		./hashTable_List.h \
		./absHashTable.h \
		./debug.h \
		./returns.h \
		./absIterator.h \
		./array.h \
		./mylist.h \
		./random.h \
		./tuple.h \
		$(ENDLIST)

tset_hashtable.o:	tset_hashtable.c \
		./random.h \
		./set_HashTable.h \
		./hashTable_List.h \
		./absHashTable.h \
		./debug.h \
		./returns.h \
		./absIterator.h \
		./array.h \
		./mylist.h \
		$(ENDLIST)

tbinary_mutable.o:	tbinary_mutable.c \
		./binaryTree2.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./mystring.h \
		$(ENDLIST)

tqueue_list.o:	tqueue_list.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./absIterator.h \
		$(ENDLIST)

tstack_list.o:	tstack_list.c \
		./mystring.h \
		./debug.h \
		./returns.h \
		./stack_List.h \
		./absStack.h \
		./mylist.h \
		./absIterator.h \
		$(ENDLIST)

binaryTree_NR.o:	binaryTree_NR.c \
		./binaryTree_NR.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		$(ENDLIST)

binaryTree_AVL.o:	binaryTree_AVL.c \
		./binaryTree_AVL.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		$(ENDLIST)

talphabet.o:	talphabet.c \
		./alphabet.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./binaryTree_AVL.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./tuple.h \
		./array.h \
		./random.h \
		$(ENDLIST)

tbinary2.o:	tbinary2.c \
		./binaryTree2.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./mystring.h \
		$(ENDLIST)

tprime.o:	tprime.c \
		./prime.h \
		./debug.h \
		./returns.h \
		./set_BitVector.h \
		$(ENDLIST)

tset_list.o:	tset_list.c \
		./random.h \
		./set_List.h \
		./mylist.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tbinary_NR.o:	tbinary_NR.c \
		./binaryTree_NR.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./mystring.h \
		$(ENDLIST)

prime.o:	prime.c \
		./prime.h \
		./debug.h \
		./returns.h \
		./set_BitVector.h \
		$(ENDLIST)

tdeque_list.o:	tdeque_list.c \
		./deque_List.h \
		./absDeque.h \
		./debug.h \
		./returns.h \
		./mylist.h \
		./absIterator.h \
		./mystring.h \
		$(ENDLIST)

queue_Array.o:	queue_Array.c \
		./queue_Array.h \
		./absQueue.h \
		./debug.h \
		./returns.h \
		./array.h \
		./absIterator.h \
		$(ENDLIST)

queue_List.o:	queue_List.c \
		./queue_List.h \
		./absQueue.h \
		./debug.h \
		./returns.h \
		./mylist.h \
		./absIterator.h \
		$(ENDLIST)

tmap.o:	tmap.c \
		./map.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./binaryTree.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./tuple.h \
		$(ENDLIST)

tlist2.o:	tlist2.c \
		./mylist.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./mystring.h \
		$(ENDLIST)

tbinary_AVL.o:	tbinary_AVL.c \
		./binaryTree_AVL.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./mystring.h \
		$(ENDLIST)

set_List.o:	set_List.c \
		./set_List.h \
		./mylist.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

binaryTree.o:	binaryTree.c \
		./binaryTree.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		$(ENDLIST)

thash_array.o:	thash_array.c \
		./hashTable_Array.h \
		./absHashTable.h \
		./debug.h \
		./returns.h \
		./absIterator.h \
		./array.h \
		./mylist.h \
		./random.h \
		./tuple.h \
		$(ENDLIST)

stack_List.o:	stack_List.c \
		./stack_List.h \
		./absStack.h \
		./debug.h \
		./returns.h \
		./mylist.h \
		./absIterator.h \
		$(ENDLIST)

hashTable_Array.o:	hashTable_Array.c \
		./hashTable_Array.h \
		./absHashTable.h \
		./debug.h \
		./returns.h \
		./absIterator.h \
		./array.h \
		$(ENDLIST)

toset2.o:	toset2.c \
		./orderedset.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./binaryTree.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./tuple.h \
		$(ENDLIST)

priorityQueue_AVLTree.o:	priorityQueue_AVLTree.c \
		./priorityQueue_AVLTree.h \
		./absPriorityQueue.h \
		./debug.h \
		./returns.h \
		./binaryTree_AVL.h \
		./absIterator.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		$(ENDLIST)

tbinaryCUJ.o:	tbinaryCUJ.c \
		./binaryTree2.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./mylist.h \
		./stack_List.h \
		./absStack.h \
		./mystring.h \
		$(ENDLIST)

clean:
		-([ -d "Templates.DB" ] && rm -rf Templates.DB;)
		-([ -d "SunWS_cache" ] && rm -rf SunWS_cache;)
		-([ -f "ir.out" ] && rm -rf ir.out;)
		-rm -f tlist2
		-rm -f tlist
		-rm -f tbinary_NR
		-rm -f tbinary_mutable
		-rm -f tpqueue_list
		-rm -f tbinaryCUJ
		-rm -f thash_array
		-rm -f tarray
		-rm -f tqueue_array
		-rm -f tbinary2
		-rm -f toset2
		-rm -f tmap
		-rm -f tarray2
		-rm -f tprime
		-rm -f tbinary
		-rm -f tbinary_AVL2
		-rm -f tbinary_array
		-rm -f tstack_list
		-rm -f talphabet
		-rm -f tdeque_list
		-rm -f tstack_array
		-rm -f tbinary_AVL
		-rm -f tset_bitvector
		-rm -f tset_hashtable
		-rm -f tqueue_list
		-rm -f tpqueue_array
		-rm -f tmap2
		-rm -f tpqueue_avltree
		-rm -f thash_list
		-rm -f toset
		-rm -f tset_list
		-rm -f random.o
		-rm -f mystring.o
		-rm -f deque_List.o
		-rm -f orderedset.o
		-rm -f binaryTree2.o
		-rm -f tqueue_array.o
		-rm -f tpqueue_list.o
		-rm -f stack_Array.o
		-rm -f tbinary_array.o
		-rm -f tmap2.o
		-rm -f tbinary_AVL2.o
		-rm -f tbinary.o
		-rm -f toset.o
		-rm -f binaryTree_Array.o
		-rm -f tpqueue_array.o
		-rm -f hashTable_List.o
		-rm -f tarray2.o
		-rm -f tstack_array.o
		-rm -f tset_bitvector.o
		-rm -f alphabet.o
		-rm -f mylist.o
		-rm -f priorityQueue_List.o
		-rm -f tlist.o
		-rm -f tpqueue_avltree.o
		-rm -f priorityQueue_Array.o
		-rm -f map.o
		-rm -f set_BitVector.o
		-rm -f tarray.o
		-rm -f array.o
		-rm -f thash_list.o
		-rm -f tset_hashtable.o
		-rm -f tbinary_mutable.o
		-rm -f tqueue_list.o
		-rm -f tstack_list.o
		-rm -f binaryTree_NR.o
		-rm -f binaryTree_AVL.o
		-rm -f talphabet.o
		-rm -f tbinary2.o
		-rm -f tprime.o
		-rm -f tset_list.o
		-rm -f tbinary_NR.o
		-rm -f prime.o
		-rm -f tdeque_list.o
		-rm -f queue_Array.o
		-rm -f queue_List.o
		-rm -f tmap.o
		-rm -f tlist2.o
		-rm -f tbinary_AVL.o
		-rm -f set_List.o
		-rm -f binaryTree.o
		-rm -f thash_array.o
		-rm -f stack_List.o
		-rm -f hashTable_Array.o
		-rm -f toset2.o
		-rm -f priorityQueue_AVLTree.o
		-rm -f tbinaryCUJ.o

backup:		random.c \
		mystring.c \
		deque_List.c \
		orderedset.c \
		binaryTree2.c \
		tqueue_array.c \
		tpqueue_list.c \
		stack_Array.c \
		tbinary_array.c \
		tmap2.c \
		tbinary_AVL2.c \
		tbinary.c \
		toset.c \
		binaryTree_Array.c \
		tpqueue_array.c \
		hashTable_List.c \
		tarray2.c \
		tstack_array.c \
		tset_bitvector.c \
		alphabet.c \
		mylist.c \
		priorityQueue_List.c \
		tlist.c \
		tpqueue_avltree.c \
		priorityQueue_Array.c \
		map.c \
		set_BitVector.c \
		tarray.c \
		array.c \
		thash_list.c \
		tset_hashtable.c \
		tbinary_mutable.c \
		tqueue_list.c \
		tstack_list.c \
		binaryTree_NR.c \
		binaryTree_AVL.c \
		talphabet.c \
		tbinary2.c \
		tprime.c \
		tset_list.c \
		tbinary_NR.c \
		prime.c \
		tdeque_list.c \
		queue_Array.c \
		queue_List.c \
		tmap.c \
		tlist2.c \
		tbinary_AVL.c \
		set_List.c \
		binaryTree.c \
		thash_array.c \
		stack_List.c \
		hashTable_Array.c \
		toset2.c \
		priorityQueue_AVLTree.c \
		tbinaryCUJ.c \
		./hashTable_Array.h \
		./debug.h \
		./priorityQueue_AVLTree.h \
		./deque_List.h \
		./mystring.h \
		./random.h \
		./absIterator.h \
		./binaryTree2.h \
		./orderedset.h \
		./stack_Array.h \
		./absHashTable.h \
		./binaryTree_Array.h \
		./hashTable_List.h \
		./absQueue.h \
		./alphabet.h \
		./mylist.h \
		./priorityQueue_List.h \
		./priorityQueue_Array.h \
		./map.h \
		./set_BitVector.h \
		./absStack.h \
		./tuple.h \
		./array.h \
		./returns.h \
		./absTree.h \
		./binaryTree_NR.h \
		./binaryTree_AVL.h \
		./prime.h \
		./queue_Array.h \
		./set_HashTable.h \
		./queue_List.h \
		./set_List.h \
		./absDeque.h \
		./absPriorityQueue.h \
		./binaryTree.h \
		./stack_List.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp random.c $(BACKUPDIR)/random.c
		cp mystring.c $(BACKUPDIR)/mystring.c
		cp deque_List.c $(BACKUPDIR)/deque_List.c
		cp orderedset.c $(BACKUPDIR)/orderedset.c
		cp binaryTree2.c $(BACKUPDIR)/binaryTree2.c
		cp tqueue_array.c $(BACKUPDIR)/tqueue_array.c
		cp tpqueue_list.c $(BACKUPDIR)/tpqueue_list.c
		cp stack_Array.c $(BACKUPDIR)/stack_Array.c
		cp tbinary_array.c $(BACKUPDIR)/tbinary_array.c
		cp tmap2.c $(BACKUPDIR)/tmap2.c
		cp tbinary_AVL2.c $(BACKUPDIR)/tbinary_AVL2.c
		cp tbinary.c $(BACKUPDIR)/tbinary.c
		cp toset.c $(BACKUPDIR)/toset.c
		cp binaryTree_Array.c $(BACKUPDIR)/binaryTree_Array.c
		cp tpqueue_array.c $(BACKUPDIR)/tpqueue_array.c
		cp hashTable_List.c $(BACKUPDIR)/hashTable_List.c
		cp tarray2.c $(BACKUPDIR)/tarray2.c
		cp tstack_array.c $(BACKUPDIR)/tstack_array.c
		cp tset_bitvector.c $(BACKUPDIR)/tset_bitvector.c
		cp alphabet.c $(BACKUPDIR)/alphabet.c
		cp mylist.c $(BACKUPDIR)/mylist.c
		cp priorityQueue_List.c $(BACKUPDIR)/priorityQueue_List.c
		cp tlist.c $(BACKUPDIR)/tlist.c
		cp tpqueue_avltree.c $(BACKUPDIR)/tpqueue_avltree.c
		cp priorityQueue_Array.c $(BACKUPDIR)/priorityQueue_Array.c
		cp map.c $(BACKUPDIR)/map.c
		cp set_BitVector.c $(BACKUPDIR)/set_BitVector.c
		cp tarray.c $(BACKUPDIR)/tarray.c
		cp array.c $(BACKUPDIR)/array.c
		cp thash_list.c $(BACKUPDIR)/thash_list.c
		cp tset_hashtable.c $(BACKUPDIR)/tset_hashtable.c
		cp tbinary_mutable.c $(BACKUPDIR)/tbinary_mutable.c
		cp tqueue_list.c $(BACKUPDIR)/tqueue_list.c
		cp tstack_list.c $(BACKUPDIR)/tstack_list.c
		cp binaryTree_NR.c $(BACKUPDIR)/binaryTree_NR.c
		cp binaryTree_AVL.c $(BACKUPDIR)/binaryTree_AVL.c
		cp talphabet.c $(BACKUPDIR)/talphabet.c
		cp tbinary2.c $(BACKUPDIR)/tbinary2.c
		cp tprime.c $(BACKUPDIR)/tprime.c
		cp tset_list.c $(BACKUPDIR)/tset_list.c
		cp tbinary_NR.c $(BACKUPDIR)/tbinary_NR.c
		cp prime.c $(BACKUPDIR)/prime.c
		cp tdeque_list.c $(BACKUPDIR)/tdeque_list.c
		cp queue_Array.c $(BACKUPDIR)/queue_Array.c
		cp queue_List.c $(BACKUPDIR)/queue_List.c
		cp tmap.c $(BACKUPDIR)/tmap.c
		cp tlist2.c $(BACKUPDIR)/tlist2.c
		cp tbinary_AVL.c $(BACKUPDIR)/tbinary_AVL.c
		cp set_List.c $(BACKUPDIR)/set_List.c
		cp binaryTree.c $(BACKUPDIR)/binaryTree.c
		cp thash_array.c $(BACKUPDIR)/thash_array.c
		cp stack_List.c $(BACKUPDIR)/stack_List.c
		cp hashTable_Array.c $(BACKUPDIR)/hashTable_Array.c
		cp toset2.c $(BACKUPDIR)/toset2.c
		cp priorityQueue_AVLTree.c $(BACKUPDIR)/priorityQueue_AVLTree.c
		cp tbinaryCUJ.c $(BACKUPDIR)/tbinaryCUJ.c
		cp ./hashTable_Array.h ./$(BACKUPDIR)/hashTable_Array.h
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./priorityQueue_AVLTree.h ./$(BACKUPDIR)/priorityQueue_AVLTree.h
		cp ./deque_List.h ./$(BACKUPDIR)/deque_List.h
		cp ./mystring.h ./$(BACKUPDIR)/mystring.h
		cp ./random.h ./$(BACKUPDIR)/random.h
		cp ./absIterator.h ./$(BACKUPDIR)/absIterator.h
		cp ./binaryTree2.h ./$(BACKUPDIR)/binaryTree2.h
		cp ./orderedset.h ./$(BACKUPDIR)/orderedset.h
		cp ./stack_Array.h ./$(BACKUPDIR)/stack_Array.h
		cp ./absHashTable.h ./$(BACKUPDIR)/absHashTable.h
		cp ./binaryTree_Array.h ./$(BACKUPDIR)/binaryTree_Array.h
		cp ./hashTable_List.h ./$(BACKUPDIR)/hashTable_List.h
		cp ./absQueue.h ./$(BACKUPDIR)/absQueue.h
		cp ./alphabet.h ./$(BACKUPDIR)/alphabet.h
		cp ./mylist.h ./$(BACKUPDIR)/mylist.h
		cp ./priorityQueue_List.h ./$(BACKUPDIR)/priorityQueue_List.h
		cp ./priorityQueue_Array.h ./$(BACKUPDIR)/priorityQueue_Array.h
		cp ./map.h ./$(BACKUPDIR)/map.h
		cp ./set_BitVector.h ./$(BACKUPDIR)/set_BitVector.h
		cp ./absStack.h ./$(BACKUPDIR)/absStack.h
		cp ./tuple.h ./$(BACKUPDIR)/tuple.h
		cp ./array.h ./$(BACKUPDIR)/array.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		cp ./absTree.h ./$(BACKUPDIR)/absTree.h
		cp ./binaryTree_NR.h ./$(BACKUPDIR)/binaryTree_NR.h
		cp ./binaryTree_AVL.h ./$(BACKUPDIR)/binaryTree_AVL.h
		cp ./prime.h ./$(BACKUPDIR)/prime.h
		cp ./queue_Array.h ./$(BACKUPDIR)/queue_Array.h
		cp ./set_HashTable.h ./$(BACKUPDIR)/set_HashTable.h
		cp ./queue_List.h ./$(BACKUPDIR)/queue_List.h
		cp ./set_List.h ./$(BACKUPDIR)/set_List.h
		cp ./absDeque.h ./$(BACKUPDIR)/absDeque.h
		cp ./absPriorityQueue.h ./$(BACKUPDIR)/absPriorityQueue.h
		cp ./binaryTree.h ./$(BACKUPDIR)/binaryTree.h
		cp ./stack_List.h ./$(BACKUPDIR)/stack_List.h
		touch backup

print:		random.c \
		mystring.c \
		deque_List.c \
		orderedset.c \
		binaryTree2.c \
		tqueue_array.c \
		tpqueue_list.c \
		stack_Array.c \
		tbinary_array.c \
		tmap2.c \
		tbinary_AVL2.c \
		tbinary.c \
		toset.c \
		binaryTree_Array.c \
		tpqueue_array.c \
		hashTable_List.c \
		tarray2.c \
		tstack_array.c \
		tset_bitvector.c \
		alphabet.c \
		mylist.c \
		priorityQueue_List.c \
		tlist.c \
		tpqueue_avltree.c \
		priorityQueue_Array.c \
		map.c \
		set_BitVector.c \
		tarray.c \
		array.c \
		thash_list.c \
		tset_hashtable.c \
		tbinary_mutable.c \
		tqueue_list.c \
		tstack_list.c \
		binaryTree_NR.c \
		binaryTree_AVL.c \
		talphabet.c \
		tbinary2.c \
		tprime.c \
		tset_list.c \
		tbinary_NR.c \
		prime.c \
		tdeque_list.c \
		queue_Array.c \
		queue_List.c \
		tmap.c \
		tlist2.c \
		tbinary_AVL.c \
		set_List.c \
		binaryTree.c \
		thash_array.c \
		stack_List.c \
		hashTable_Array.c \
		toset2.c \
		priorityQueue_AVLTree.c \
		tbinaryCUJ.c \
		./hashTable_Array.h \
		./debug.h \
		./priorityQueue_AVLTree.h \
		./deque_List.h \
		./mystring.h \
		./random.h \
		./absIterator.h \
		./binaryTree2.h \
		./orderedset.h \
		./stack_Array.h \
		./absHashTable.h \
		./binaryTree_Array.h \
		./hashTable_List.h \
		./absQueue.h \
		./alphabet.h \
		./mylist.h \
		./priorityQueue_List.h \
		./priorityQueue_Array.h \
		./map.h \
		./set_BitVector.h \
		./absStack.h \
		./tuple.h \
		./array.h \
		./returns.h \
		./absTree.h \
		./binaryTree_NR.h \
		./binaryTree_AVL.h \
		./prime.h \
		./queue_Array.h \
		./set_HashTable.h \
		./queue_List.h \
		./set_List.h \
		./absDeque.h \
		./absPriorityQueue.h \
		./binaryTree.h \
		./stack_List.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			random.c \
			mystring.c \
			deque_List.c \
			orderedset.c \
			binaryTree2.c \
			tqueue_array.c \
			tpqueue_list.c \
			stack_Array.c \
			tbinary_array.c \
			tmap2.c \
			tbinary_AVL2.c \
			tbinary.c \
			toset.c \
			binaryTree_Array.c \
			tpqueue_array.c \
			hashTable_List.c \
			tarray2.c \
			tstack_array.c \
			tset_bitvector.c \
			alphabet.c \
			mylist.c \
			priorityQueue_List.c \
			tlist.c \
			tpqueue_avltree.c \
			priorityQueue_Array.c \
			map.c \
			set_BitVector.c \
			tarray.c \
			array.c \
			thash_list.c \
			tset_hashtable.c \
			tbinary_mutable.c \
			tqueue_list.c \
			tstack_list.c \
			binaryTree_NR.c \
			binaryTree_AVL.c \
			talphabet.c \
			tbinary2.c \
			tprime.c \
			tset_list.c \
			tbinary_NR.c \
			prime.c \
			tdeque_list.c \
			queue_Array.c \
			queue_List.c \
			tmap.c \
			tlist2.c \
			tbinary_AVL.c \
			set_List.c \
			binaryTree.c \
			thash_array.c \
			stack_List.c \
			hashTable_Array.c \
			toset2.c \
			priorityQueue_AVLTree.c \
			tbinaryCUJ.c \
			./hashTable_Array.h \
			./debug.h \
			./priorityQueue_AVLTree.h \
			./deque_List.h \
			./mystring.h \
			./random.h \
			./absIterator.h \
			./binaryTree2.h \
			./orderedset.h \
			./stack_Array.h \
			./absHashTable.h \
			./binaryTree_Array.h \
			./hashTable_List.h \
			./absQueue.h \
			./alphabet.h \
			./mylist.h \
			./priorityQueue_List.h \
			./priorityQueue_Array.h \
			./map.h \
			./set_BitVector.h \
			./absStack.h \
			./tuple.h \
			./array.h \
			./returns.h \
			./absTree.h \
			./binaryTree_NR.h \
			./binaryTree_AVL.h \
			./prime.h \
			./queue_Array.h \
			./set_HashTable.h \
			./queue_List.h \
			./set_List.h \
			./absDeque.h \
			./absPriorityQueue.h \
			./binaryTree.h \
			./stack_List.h \
			$(ENDLIST)
