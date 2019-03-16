#!/usr/bin/python3
#
# examples of iterators ...
#
import sys
#
product = 1
for i in [1, 2, 4, 8]:
    product *= i
print("(1) product is ... ", product)
#
product = 1
i = iter([1, 2, 4, 8])
#
while True:
    try:
     product *= next(i)
    except StopIteration:
     break
print("(2) product is ... ", product)
#
x = [-2, 9, 7, -4, 3]
print(all(x), any(x), len(x), min(x), max(x), sum(x))
#
x.append(0)
print(all(x), any(x), len(x), min(x), max(x), sum(x))
#
# Syntax Description
# s + t Returns a sequence that is the concatenation of sequences s
# and t
# s * n Returns a sequence that is int n concatenations of sequence s
# x in i Returns True if item x is in iterable i; use not in to reverse
# the test
# all(i) Returns True if every item in iterable i evaluates to True
# any(i) Returns True if any item in iterable i evaluates to True
# enumerate(i,
# start)
# Normally used in for …in loops to provide a sequence of (index,
# item) tuples with indexes starting at 0 or start; see text
# len(x) Returns the “length” of x. If x is a collection it is the number
# of items; if x is a string it is the number of characters.
# max(i, key) Returns the biggest item in iterable i or the item with the
# biggest key(item) value if a key function is given
# min(i, key) Returns the smallest item in iterable i or the item with the
# smallest key(item) value if a key function is given
# range(
# start,
# stop,
# step)
# Returns an integer iterator. With one argument (stop), the iterator
# goes from 0 to stop - 1; with two arguments (start, stop)
# the iterator goes from start to stop - 1; with three arguments
# it goes from start to stop - 1 in steps of step.
# reversed(i) Returns an iterator that returns the items from iterator i in
# reverse order
# sorted(i,
# key,
# reverse)
# Returns a list of the items from iterator i in sorted order; key
# is used to provide DSU (Decorate, Sort, Undecorate) sorting.
# If reverse is True the sorting is done in reverse order.
# sum(i,
# start)
# Returns the sum of the items in iterable i plus start (which
# defaults to 0); i may not contain strings
# zip(i1,
# ..., iN)
# Returns an iterator of tuples using the iterators i1 to iN;
# see text
#
# for loops and range() function
#
x = [ -1, -2, -3, -4 ]
#
for i in range(len(x)):
    x[i] = abs(x[i])
print("(1) x is ... ", x)
#
i = 0
while i < len(x):
    x[i] = abs(x[i])
    i += 1
print("(2) x is ... ", x)
#
# sorted and reverse functions
#
print("range(6) ... ", list(range(6)))
print("reversed(range(6)) ... ", list(reversed(range(6))))
print("sorted(reversed(range(6))) ... ", list(sorted(reversed(range(6)))))
#
x = ["Sloop", "Yawl", "Cutter", "schooner", "ketch"]
print("x ... ", x)
#
temp = []
for item in x:
    temp.append((item.lower(), item))
x = []
for key, value in sorted(temp):
    x.append(value)
print("(1) sorted x ... ", x)
#
x = sorted(x, key=str.lower)
print("(2) sorted x ... ", x)
#
# python copies are shallow copies.
#
# to get deep-copies, use the copy module
#
import copy
x = [ 53, 68, [ "a", "b", "c" ]]
#
y = copy.deepcopy(x)
#
y[1] = 40
x[2][0] = 'Q'
#
print((x,y))
#
sys.exit(0);
