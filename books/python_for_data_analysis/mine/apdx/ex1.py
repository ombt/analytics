#!/usr/bin/python
#
import sys
#
import numpy
import scipy
#
a_list = [2, 3, 7, None ]
print(a_list)
#
tup = ('foo', 'bar', 'baz')
print(tup)
#
b_list = list(tup)
print(b_list)
#
b_list[1] = 'peekaboo'
print(b_list)
#
b_list.append('dwarf')
print(b_list)
#
b_list.insert(1, "red")
print(b_list)
#
print(b_list.pop(2))
print(b_list)
#
print(b_list)
b_list.append('foo')
print(b_list)
b_list.remove('foo')
print(b_list)
print('foo' in b_list)
#
# use extend when adding new members to a list
#
everything = []
#
for chunk in [ [ 4 , 5 ], [ [1, 2], [8, 9] ] ]:
    print(chunk)
    everything.extend(chunk)
    print(everything)
#
b = [ 'saw', 'small', 'large', 'he', 'foxes', 'six' ]
print('b is ... {0}'.format(b))
#
b.sort(key=lambda(x) : len(x))
print('sorted b is ... {0}'.format(b))
#
print("slicing b[1:3] ...{0}".format(b[1:3]))
#
# enumerate -
#
# i = 0
# for value in collection:
#   do something with value
#   i += 1
#
# Since this is so common, Python has a built-in function enumerate which returns a sequence of (i, value) tuples:
#
#   for i, value in enumerate(collection):
#       do something with value
# When indexing data, a useful pattern that uses enumerate is computing a dict mapping
# the values of a sequence (which are assumed to be unique) to their locations in the sequence:
#
some_list = ['foo', 'bar', 'baz']
print(some_list)
#
mapping = dict((v, i) for i, v in enumerate(some_list))
print(mapping)
#
# sorted -
#
print(sorted([7, 1, 2, 6, 0, 3, 2]))
print(sorted('horse race'))

# A common pattern for getting a sorted list of the unique elements in a sequence is to combine sorted with set :
#
print("sorted set example - {0}".format(sorted(set('this is just some string'))))
#
# zip - combine two sequences
#
seq1 = ['foo', 'bar', 'baz']
print(seq1)
seq2 = ['one', 'two', 'three']
print(seq2)
print("zip(seq1, seq2) ... {0}".format(zip(seq1, seq2)))
seq3 = [ False, True ]
print(seq2)
print("zip(seq1, seq2, seq3) ... {0}".format(zip(seq1, seq2, seq3)))
#
# unzipping ...
#
pitchers = [('Nolan', 'Ryan'), ('Roger', 'Clemens'), ('Schilling', 'Curt')]
print(pitchers)
first_names, last_names = zip(*pitchers)
print(first_names)
print(last_names)
#
# reversed
#
print(reversed(range(10)))
print(list(reversed(range(10))))
#
sys.exit(0)

