
.SUFFIXES:		.o .c

LEXFLAGS = -n
YACC = yacc
YACCFLAGS = -d -v
LEX = lex
MAKE = make
LDFLAGS = -g -pta -xildoff
LD = CC
BACKUPDIR = BACKUP
SHELLBIN = $(HOME)/bin
ARFLAGS = -r -v
CCFLAGS = -g -DMUTABLE_ITERATOR -pta -xildoff
INCLDIRS = 
CC = CC
LPRFLAGS = 
AR = ar
LPR = mycpr2on1
ENDLIST = 

.c.o:
		$(CC) $(CCFLAGS) $(INCLDIRS) -c $<

all:		tlist \
		tbinary_NR \
		tbinary_mutable \
		tpqueue_list \
		tbinaryCUJ \
		tbitvector2 \
		thash_array \
		tarray \
		tsetlist \
		tqueue_array \
		tbinary2 \
		tsetlist2 \
		tbitvector \
		tbinary \
		tbinary_AVL2 \
		tbinary_array \
		tstack_list \
		tstring \
		tstack_array \
		tbinary_AVL \
		tset_hashtable \
		tqueue_list \
		tpqueue_array \
		thash_list \
		$(ENDLIST)
		touch all

tlist:		tlist.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tlist \
			tlist.o \
			list.o \
			$(ENDLIST)

tbinary_NR:		tbinary_NR.o \
		binaryTree_NR.o \
		string.o \
		queue_List.o \
		stack_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_NR \
			tbinary_NR.o \
			binaryTree_NR.o \
			string.o \
			queue_List.o \
			stack_List.o \
			list.o \
			$(ENDLIST)

tbinary_mutable:		tbinary_mutable.o \
		binaryTree2.o \
		string.o \
		queue_List.o \
		stack_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_mutable \
			tbinary_mutable.o \
			binaryTree2.o \
			string.o \
			queue_List.o \
			stack_List.o \
			list.o \
			$(ENDLIST)

tpqueue_list:		tpqueue_list.o \
		priorityQueue_List.o \
		list.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tpqueue_list \
			tpqueue_list.o \
			priorityQueue_List.o \
			list.o \
			random.o \
			$(ENDLIST)

tbinaryCUJ:		tbinaryCUJ.o \
		binaryTree2.o \
		string.o \
		queue_List.o \
		stack_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinaryCUJ \
			tbinaryCUJ.o \
			binaryTree2.o \
			string.o \
			queue_List.o \
			stack_List.o \
			list.o \
			$(ENDLIST)

tbitvector2:		tbitvector2.o \
		set_BitVector.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbitvector2 \
			tbitvector2.o \
			set_BitVector.o \
			random.o \
			$(ENDLIST)

thash_array:		thash_array.o \
		list.o \
		array.o \
		random.o \
		hashTable_Array.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o thash_array \
			thash_array.o \
			list.o \
			array.o \
			random.o \
			hashTable_Array.o \
			$(ENDLIST)

tarray:		tarray.o \
		array.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tarray \
			tarray.o \
			array.o \
			$(ENDLIST)

tsetlist:		tsetlist.o \
		set_List.o \
		list.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tsetlist \
			tsetlist.o \
			set_List.o \
			list.o \
			random.o \
			$(ENDLIST)

tqueue_array:		tqueue_array.o \
		queue_Array.o \
		array.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tqueue_array \
			tqueue_array.o \
			queue_Array.o \
			array.o \
			$(ENDLIST)

tbinary2:		tbinary2.o \
		binaryTree2.o \
		string.o \
		queue_List.o \
		stack_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary2 \
			tbinary2.o \
			binaryTree2.o \
			string.o \
			queue_List.o \
			stack_List.o \
			list.o \
			$(ENDLIST)

tsetlist2:		tsetlist2.o \
		set_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tsetlist2 \
			tsetlist2.o \
			set_List.o \
			list.o \
			$(ENDLIST)

tbitvector:		tbitvector.o \
		prime.o \
		set_BitVector.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbitvector \
			tbitvector.o \
			prime.o \
			set_BitVector.o \
			$(ENDLIST)

tbinary:		tbinary.o \
		binaryTree.o \
		string.o \
		queue_List.o \
		stack_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary \
			tbinary.o \
			binaryTree.o \
			string.o \
			queue_List.o \
			stack_List.o \
			list.o \
			$(ENDLIST)

tbinary_AVL2:		tbinary_AVL2.o \
		binaryTree_AVL.o \
		string.o \
		queue_List.o \
		stack_List.o \
		list.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_AVL2 \
			tbinary_AVL2.o \
			binaryTree_AVL.o \
			string.o \
			queue_List.o \
			stack_List.o \
			list.o \
			random.o \
			$(ENDLIST)

tbinary_array:		tbinary_array.o \
		binaryTree_Array.o \
		string.o \
		queue_List.o \
		stack_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_array \
			tbinary_array.o \
			binaryTree_Array.o \
			string.o \
			queue_List.o \
			stack_List.o \
			list.o \
			$(ENDLIST)

tstack_list:		tstack_list.o \
		stack_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tstack_list \
			tstack_list.o \
			stack_List.o \
			list.o \
			$(ENDLIST)

tstring:		tstring.o \
		string.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tstring \
			tstring.o \
			string.o \
			$(ENDLIST)

tstack_array:		tstack_array.o \
		stack_Array.o \
		array.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tstack_array \
			tstack_array.o \
			stack_Array.o \
			array.o \
			$(ENDLIST)

tbinary_AVL:		tbinary_AVL.o \
		binaryTree_AVL.o \
		string.o \
		queue_List.o \
		stack_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tbinary_AVL \
			tbinary_AVL.o \
			binaryTree_AVL.o \
			string.o \
			queue_List.o \
			stack_List.o \
			list.o \
			$(ENDLIST)

tset_hashtable:		tset_hashtable.o \
		set_HashTable.o \
		list.o \
		hashTable_List.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tset_hashtable \
			tset_hashtable.o \
			set_HashTable.o \
			list.o \
			hashTable_List.o \
			random.o \
			$(ENDLIST)

tqueue_list:		tqueue_list.o \
		queue_List.o \
		list.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tqueue_list \
			tqueue_list.o \
			queue_List.o \
			list.o \
			$(ENDLIST)

tpqueue_array:		tpqueue_array.o \
		priorityQueue_Array.o \
		array.o \
		random.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o tpqueue_array \
			tpqueue_array.o \
			priorityQueue_Array.o \
			array.o \
			random.o \
			$(ENDLIST)

thash_list:		thash_list.o \
		list.o \
		array.o \
		random.o \
		hashTable_List.o \
		$(ENDLIST)
		$(LD) $(LDFLAGS) -o thash_list \
			thash_list.o \
			list.o \
			array.o \
			random.o \
			hashTable_List.o \
			$(ENDLIST)

random.o:	random.c \
		$(ENDLIST)

binaryTree2.o:	binaryTree2.c \
		./binaryTree2.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./list.h \
		./stack_List.h \
		./absStack.h \
		$(ENDLIST)

tqueue_array.o:	tqueue_array.c \
		./queue_Array.h \
		./absQueue.h \
		./debug.h \
		./returns.h \
		./array.h \
		./absIterator.h \
		$(ENDLIST)

tpqueue_list.o:	tpqueue_list.c \
		./priorityQueue_List.h \
		./absPriorityQueue.h \
		./debug.h \
		./returns.h \
		./list.h \
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
		./list.h \
		./stack_List.h \
		./absStack.h \
		./string.h \
		$(ENDLIST)

tbinary_AVL2.o:	tbinary_AVL2.c \
		./binaryTree_AVL.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./list.h \
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
		./list.h \
		./stack_List.h \
		./absStack.h \
		./string.h \
		$(ENDLIST)

binaryTree_Array.o:	binaryTree_Array.c \
		./binaryTree_Array.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./list.h \
		./stack_List.h \
		./absStack.h \
		$(ENDLIST)

tpqueue_array.o:	tpqueue_array.c \
		./priorityQueue_Array.h \
		./absPriorityQueue.h \
		./debug.h \
		./returns.h \
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
		./list.h \
		$(ENDLIST)

tstack_array.o:	tstack_array.c \
		./stack_Array.h \
		./absStack.h \
		./debug.h \
		./returns.h \
		./array.h \
		./absIterator.h \
		$(ENDLIST)

tsetlist2.o:	tsetlist2.c \
		./set_List.h \
		./list.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

priorityQueue_List.o:	priorityQueue_List.c \
		./priorityQueue_List.h \
		./absPriorityQueue.h \
		./debug.h \
		./returns.h \
		./list.h \
		./absIterator.h \
		$(ENDLIST)

tlist.o:	tlist.c \
		./list.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

priorityQueue_Array.o:	priorityQueue_Array.c \
		./array.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./priorityQueue_Array.h \
		./absPriorityQueue.h \
		$(ENDLIST)

tbitvector2.o:	tbitvector2.c \
		./random.h \
		./set_BitVector.h \
		./debug.h \
		./returns.h \
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

tbitvector.o:	tbitvector.c \
		./prime.h \
		./debug.h \
		./returns.h \
		./set_BitVector.h \
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
		./list.h \
		./random.h \
		./tuple.h \
		$(ENDLIST)

list.o:	list.c \
		./list.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tsetlist.o:	tsetlist.c \
		./random.h \
		./set_List.h \
		./list.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
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
		./list.h \
		$(ENDLIST)

tbinary_mutable.o:	tbinary_mutable.c \
		./binaryTree2.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./list.h \
		./stack_List.h \
		./absStack.h \
		./string.h \
		$(ENDLIST)

tqueue_list.o:	tqueue_list.c \
		./queue_List.h \
		./absQueue.h \
		./debug.h \
		./returns.h \
		./list.h \
		./absIterator.h \
		$(ENDLIST)

tstack_list.o:	tstack_list.c \
		./stack_List.h \
		./absStack.h \
		./debug.h \
		./returns.h \
		./list.h \
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
		./list.h \
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
		./list.h \
		./stack_List.h \
		./absStack.h \
		$(ENDLIST)

tbinary2.o:	tbinary2.c \
		./binaryTree2.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./list.h \
		./stack_List.h \
		./absStack.h \
		./string.h \
		$(ENDLIST)

tbinary_NR.o:	tbinary_NR.c \
		./binaryTree_NR.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./list.h \
		./stack_List.h \
		./absStack.h \
		./string.h \
		$(ENDLIST)

set_HashTable.o:	set_HashTable.c \
		./set_HashTable.h \
		./hashTable_List.h \
		./absHashTable.h \
		./debug.h \
		./returns.h \
		./absIterator.h \
		./array.h \
		./list.h \
		$(ENDLIST)

prime.o:	prime.c \
		./prime.h \
		./debug.h \
		./returns.h \
		./set_BitVector.h \
		$(ENDLIST)

queue_Array.o:	queue_Array.c \
		./queue_Array.h \
		./absQueue.h \
		./debug.h \
		./returns.h \
		./array.h \
		./absIterator.h \
		$(ENDLIST)

tstring.o:	tstring.c \
		./string.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

queue_List.o:	queue_List.c \
		./queue_List.h \
		./absQueue.h \
		./debug.h \
		./returns.h \
		./list.h \
		./absIterator.h \
		$(ENDLIST)

set_List.o:	set_List.c \
		./set_List.h \
		./list.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		$(ENDLIST)

tbinary_AVL.o:	tbinary_AVL.c \
		./binaryTree_AVL.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./list.h \
		./stack_List.h \
		./absStack.h \
		./string.h \
		$(ENDLIST)

string.o:	string.c \
		./debug.h \
		./string.h \
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
		./list.h \
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
		./list.h \
		./random.h \
		./tuple.h \
		$(ENDLIST)

stack_List.o:	stack_List.c \
		./stack_List.h \
		./absStack.h \
		./debug.h \
		./returns.h \
		./list.h \
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

tbinaryCUJ.o:	tbinaryCUJ.c \
		./binaryTree2.h \
		./absIterator.h \
		./debug.h \
		./returns.h \
		./absTree.h \
		./queue_List.h \
		./absQueue.h \
		./list.h \
		./stack_List.h \
		./absStack.h \
		./string.h \
		$(ENDLIST)

clean:
		-rm -rf Templates.DB
		-rm -f tlist
		-rm -f tbinary_NR
		-rm -f tbinary_mutable
		-rm -f tpqueue_list
		-rm -f tbinaryCUJ
		-rm -f tbitvector2
		-rm -f thash_array
		-rm -f tarray
		-rm -f tsetlist
		-rm -f tqueue_array
		-rm -f tbinary2
		-rm -f tsetlist2
		-rm -f tbitvector
		-rm -f tbinary
		-rm -f tbinary_AVL2
		-rm -f tbinary_array
		-rm -f tstack_list
		-rm -f tstring
		-rm -f tstack_array
		-rm -f tbinary_AVL
		-rm -f tset_hashtable
		-rm -f tqueue_list
		-rm -f tpqueue_array
		-rm -f thash_list
		-rm -f random.o
		-rm -f binaryTree2.o
		-rm -f tqueue_array.o
		-rm -f tpqueue_list.o
		-rm -f stack_Array.o
		-rm -f tbinary_array.o
		-rm -f tbinary_AVL2.o
		-rm -f tbinary.o
		-rm -f binaryTree_Array.o
		-rm -f tpqueue_array.o
		-rm -f hashTable_List.o
		-rm -f tstack_array.o
		-rm -f tsetlist2.o
		-rm -f priorityQueue_List.o
		-rm -f tlist.o
		-rm -f priorityQueue_Array.o
		-rm -f tbitvector2.o
		-rm -f set_BitVector.o
		-rm -f tarray.o
		-rm -f tbitvector.o
		-rm -f array.o
		-rm -f thash_list.o
		-rm -f list.o
		-rm -f tsetlist.o
		-rm -f tset_hashtable.o
		-rm -f tbinary_mutable.o
		-rm -f tqueue_list.o
		-rm -f tstack_list.o
		-rm -f binaryTree_NR.o
		-rm -f binaryTree_AVL.o
		-rm -f tbinary2.o
		-rm -f tbinary_NR.o
		-rm -f set_HashTable.o
		-rm -f prime.o
		-rm -f queue_Array.o
		-rm -f tstring.o
		-rm -f queue_List.o
		-rm -f set_List.o
		-rm -f tbinary_AVL.o
		-rm -f string.o
		-rm -f binaryTree.o
		-rm -f thash_array.o
		-rm -f stack_List.o
		-rm -f hashTable_Array.o
		-rm -f tbinaryCUJ.o

backup:		random.c \
		binaryTree2.c \
		tqueue_array.c \
		tpqueue_list.c \
		stack_Array.c \
		tbinary_array.c \
		tbinary_AVL2.c \
		tbinary.c \
		binaryTree_Array.c \
		tpqueue_array.c \
		hashTable_List.c \
		tstack_array.c \
		tsetlist2.c \
		priorityQueue_List.c \
		tlist.c \
		priorityQueue_Array.c \
		tbitvector2.c \
		set_BitVector.c \
		tarray.c \
		tbitvector.c \
		array.c \
		thash_list.c \
		list.c \
		tsetlist.c \
		tset_hashtable.c \
		tbinary_mutable.c \
		tqueue_list.c \
		tstack_list.c \
		binaryTree_NR.c \
		binaryTree_AVL.c \
		tbinary2.c \
		tbinary_NR.c \
		set_HashTable.c \
		prime.c \
		queue_Array.c \
		tstring.c \
		queue_List.c \
		set_List.c \
		tbinary_AVL.c \
		string.c \
		binaryTree.c \
		thash_array.c \
		stack_List.c \
		hashTable_Array.c \
		tbinaryCUJ.c \
		./hashTable_Array.h \
		./debug.h \
		./random.h \
		./absIterator.h \
		./binaryTree2.h \
		./stack_Array.h \
		./absHashTable.h \
		./binaryTree_Array.h \
		./hashTable_List.h \
		./absQueue.h \
		./priorityQueue_List.h \
		./priorityQueue_Array.h \
		./set_BitVector.h \
		./absStack.h \
		./tuple.h \
		./array.h \
		./returns.h \
		./list.h \
		./absTree.h \
		./binaryTree_NR.h \
		./binaryTree_AVL.h \
		./prime.h \
		./queue_Array.h \
		./set_HashTable.h \
		./queue_List.h \
		./set_List.h \
		./absPriorityQueue.h \
		./binaryTree.h \
		./string.h \
		./stack_List.h \
		$(ENDLIST)
		-([ ! -d "./$(BACKUPDIR)" ] && mkdir ./$(BACKUPDIR);)
		cp random.c $(BACKUPDIR)/random.c
		cp binaryTree2.c $(BACKUPDIR)/binaryTree2.c
		cp tqueue_array.c $(BACKUPDIR)/tqueue_array.c
		cp tpqueue_list.c $(BACKUPDIR)/tpqueue_list.c
		cp stack_Array.c $(BACKUPDIR)/stack_Array.c
		cp tbinary_array.c $(BACKUPDIR)/tbinary_array.c
		cp tbinary_AVL2.c $(BACKUPDIR)/tbinary_AVL2.c
		cp tbinary.c $(BACKUPDIR)/tbinary.c
		cp binaryTree_Array.c $(BACKUPDIR)/binaryTree_Array.c
		cp tpqueue_array.c $(BACKUPDIR)/tpqueue_array.c
		cp hashTable_List.c $(BACKUPDIR)/hashTable_List.c
		cp tstack_array.c $(BACKUPDIR)/tstack_array.c
		cp tsetlist2.c $(BACKUPDIR)/tsetlist2.c
		cp priorityQueue_List.c $(BACKUPDIR)/priorityQueue_List.c
		cp tlist.c $(BACKUPDIR)/tlist.c
		cp priorityQueue_Array.c $(BACKUPDIR)/priorityQueue_Array.c
		cp tbitvector2.c $(BACKUPDIR)/tbitvector2.c
		cp set_BitVector.c $(BACKUPDIR)/set_BitVector.c
		cp tarray.c $(BACKUPDIR)/tarray.c
		cp tbitvector.c $(BACKUPDIR)/tbitvector.c
		cp array.c $(BACKUPDIR)/array.c
		cp thash_list.c $(BACKUPDIR)/thash_list.c
		cp list.c $(BACKUPDIR)/list.c
		cp tsetlist.c $(BACKUPDIR)/tsetlist.c
		cp tset_hashtable.c $(BACKUPDIR)/tset_hashtable.c
		cp tbinary_mutable.c $(BACKUPDIR)/tbinary_mutable.c
		cp tqueue_list.c $(BACKUPDIR)/tqueue_list.c
		cp tstack_list.c $(BACKUPDIR)/tstack_list.c
		cp binaryTree_NR.c $(BACKUPDIR)/binaryTree_NR.c
		cp binaryTree_AVL.c $(BACKUPDIR)/binaryTree_AVL.c
		cp tbinary2.c $(BACKUPDIR)/tbinary2.c
		cp tbinary_NR.c $(BACKUPDIR)/tbinary_NR.c
		cp set_HashTable.c $(BACKUPDIR)/set_HashTable.c
		cp prime.c $(BACKUPDIR)/prime.c
		cp queue_Array.c $(BACKUPDIR)/queue_Array.c
		cp tstring.c $(BACKUPDIR)/tstring.c
		cp queue_List.c $(BACKUPDIR)/queue_List.c
		cp set_List.c $(BACKUPDIR)/set_List.c
		cp tbinary_AVL.c $(BACKUPDIR)/tbinary_AVL.c
		cp string.c $(BACKUPDIR)/string.c
		cp binaryTree.c $(BACKUPDIR)/binaryTree.c
		cp thash_array.c $(BACKUPDIR)/thash_array.c
		cp stack_List.c $(BACKUPDIR)/stack_List.c
		cp hashTable_Array.c $(BACKUPDIR)/hashTable_Array.c
		cp tbinaryCUJ.c $(BACKUPDIR)/tbinaryCUJ.c
		cp ./hashTable_Array.h ./$(BACKUPDIR)/hashTable_Array.h
		cp ./debug.h ./$(BACKUPDIR)/debug.h
		cp ./random.h ./$(BACKUPDIR)/random.h
		cp ./absIterator.h ./$(BACKUPDIR)/absIterator.h
		cp ./binaryTree2.h ./$(BACKUPDIR)/binaryTree2.h
		cp ./stack_Array.h ./$(BACKUPDIR)/stack_Array.h
		cp ./absHashTable.h ./$(BACKUPDIR)/absHashTable.h
		cp ./binaryTree_Array.h ./$(BACKUPDIR)/binaryTree_Array.h
		cp ./hashTable_List.h ./$(BACKUPDIR)/hashTable_List.h
		cp ./absQueue.h ./$(BACKUPDIR)/absQueue.h
		cp ./priorityQueue_List.h ./$(BACKUPDIR)/priorityQueue_List.h
		cp ./priorityQueue_Array.h ./$(BACKUPDIR)/priorityQueue_Array.h
		cp ./set_BitVector.h ./$(BACKUPDIR)/set_BitVector.h
		cp ./absStack.h ./$(BACKUPDIR)/absStack.h
		cp ./tuple.h ./$(BACKUPDIR)/tuple.h
		cp ./array.h ./$(BACKUPDIR)/array.h
		cp ./returns.h ./$(BACKUPDIR)/returns.h
		cp ./list.h ./$(BACKUPDIR)/list.h
		cp ./absTree.h ./$(BACKUPDIR)/absTree.h
		cp ./binaryTree_NR.h ./$(BACKUPDIR)/binaryTree_NR.h
		cp ./binaryTree_AVL.h ./$(BACKUPDIR)/binaryTree_AVL.h
		cp ./prime.h ./$(BACKUPDIR)/prime.h
		cp ./queue_Array.h ./$(BACKUPDIR)/queue_Array.h
		cp ./set_HashTable.h ./$(BACKUPDIR)/set_HashTable.h
		cp ./queue_List.h ./$(BACKUPDIR)/queue_List.h
		cp ./set_List.h ./$(BACKUPDIR)/set_List.h
		cp ./absPriorityQueue.h ./$(BACKUPDIR)/absPriorityQueue.h
		cp ./binaryTree.h ./$(BACKUPDIR)/binaryTree.h
		cp ./string.h ./$(BACKUPDIR)/string.h
		cp ./stack_List.h ./$(BACKUPDIR)/stack_List.h
		touch backup

print:		random.c \
		binaryTree2.c \
		tqueue_array.c \
		tpqueue_list.c \
		stack_Array.c \
		tbinary_array.c \
		tbinary_AVL2.c \
		tbinary.c \
		binaryTree_Array.c \
		tpqueue_array.c \
		hashTable_List.c \
		tstack_array.c \
		tsetlist2.c \
		priorityQueue_List.c \
		tlist.c \
		priorityQueue_Array.c \
		tbitvector2.c \
		set_BitVector.c \
		tarray.c \
		tbitvector.c \
		array.c \
		thash_list.c \
		list.c \
		tsetlist.c \
		tset_hashtable.c \
		tbinary_mutable.c \
		tqueue_list.c \
		tstack_list.c \
		binaryTree_NR.c \
		binaryTree_AVL.c \
		tbinary2.c \
		tbinary_NR.c \
		set_HashTable.c \
		prime.c \
		queue_Array.c \
		tstring.c \
		queue_List.c \
		set_List.c \
		tbinary_AVL.c \
		string.c \
		binaryTree.c \
		thash_array.c \
		stack_List.c \
		hashTable_Array.c \
		tbinaryCUJ.c \
		./hashTable_Array.h \
		./debug.h \
		./random.h \
		./absIterator.h \
		./binaryTree2.h \
		./stack_Array.h \
		./absHashTable.h \
		./binaryTree_Array.h \
		./hashTable_List.h \
		./absQueue.h \
		./priorityQueue_List.h \
		./priorityQueue_Array.h \
		./set_BitVector.h \
		./absStack.h \
		./tuple.h \
		./array.h \
		./returns.h \
		./list.h \
		./absTree.h \
		./binaryTree_NR.h \
		./binaryTree_AVL.h \
		./prime.h \
		./queue_Array.h \
		./set_HashTable.h \
		./queue_List.h \
		./set_List.h \
		./absPriorityQueue.h \
		./binaryTree.h \
		./string.h \
		./stack_List.h \
		$(ENDLIST)
		$(LPR) $(LPRFLAGS) \
			random.c \
			binaryTree2.c \
			tqueue_array.c \
			tpqueue_list.c \
			stack_Array.c \
			tbinary_array.c \
			tbinary_AVL2.c \
			tbinary.c \
			binaryTree_Array.c \
			tpqueue_array.c \
			hashTable_List.c \
			tstack_array.c \
			tsetlist2.c \
			priorityQueue_List.c \
			tlist.c \
			priorityQueue_Array.c \
			tbitvector2.c \
			set_BitVector.c \
			tarray.c \
			tbitvector.c \
			array.c \
			thash_list.c \
			list.c \
			tsetlist.c \
			tset_hashtable.c \
			tbinary_mutable.c \
			tqueue_list.c \
			tstack_list.c \
			binaryTree_NR.c \
			binaryTree_AVL.c \
			tbinary2.c \
			tbinary_NR.c \
			set_HashTable.c \
			prime.c \
			queue_Array.c \
			tstring.c \
			queue_List.c \
			set_List.c \
			tbinary_AVL.c \
			string.c \
			binaryTree.c \
			thash_array.c \
			stack_List.c \
			hashTable_Array.c \
			tbinaryCUJ.c \
			./hashTable_Array.h \
			./debug.h \
			./random.h \
			./absIterator.h \
			./binaryTree2.h \
			./stack_Array.h \
			./absHashTable.h \
			./binaryTree_Array.h \
			./hashTable_List.h \
			./absQueue.h \
			./priorityQueue_List.h \
			./priorityQueue_Array.h \
			./set_BitVector.h \
			./absStack.h \
			./tuple.h \
			./array.h \
			./returns.h \
			./list.h \
			./absTree.h \
			./binaryTree_NR.h \
			./binaryTree_AVL.h \
			./prime.h \
			./queue_Array.h \
			./set_HashTable.h \
			./queue_List.h \
			./set_List.h \
			./absPriorityQueue.h \
			./binaryTree.h \
			./string.h \
			./stack_List.h \
			$(ENDLIST)
