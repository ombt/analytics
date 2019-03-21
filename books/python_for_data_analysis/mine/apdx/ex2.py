#!/usr/bin/python
#
import sys
#
import numpy
import scipy
#
empty_dict = { }
print(empty_dict)
#
d1 = { 'a' : 'some value', 'b' : [ 1,2,3,4 ] }
print(d1)
#
d1[7] = 'an integer'
print(d1)
#
print(d1['b'])
#
d1[5] = 'some value'
d1['dummy'] = 'another value'
print(d1)
#
del d1[5]
print(d1)
#
ret = d1.pop('dummy')
print(ret)
print(d1)
#
print(d1.keys())
print(d1.values())
#
d2 = d1
d2.update({ 'b' : 'foo', 'c' : 'bar'})
print(d2)
#
# creating a dict from two sequences
#
# bad way
#
key_list = range(5)
data_list = reversed(range(5))
#
mapping = {}
for key, value in zip(key_list, data_list):
    mapping[key] = value
print("slow way ... {0}".format(mapping))
#
mapping = {}
print(data_list)
# print(key_list, [*data_list])
# mapping = dict(zip(key_list, list(data_list)))
print("fast way ... {0}".format(mapping))
#
# default values
#
# if key in some_dict:
# value = some_dict[key]
# else:
# value = default_value
# Thus, the dict methods get and pop can take a default value to be returned, so that the
# above if-else block can be written simply as:
# value = some_dict.get(key, default_value)
# get by default will return None if the key is not present, while pop will raise an exception.#
#
# sets
#
print(set([2,2,2,1,3,3,4,5]))
print({2,2,2,1,3,3,4,5})
#
a = { 1,2,3,4,5 }
b = { 3,4,5,6,7,8 }
#
print("{0} union {1} = {2}".format(a,b,a|b))
print("{0} intersection {1} = {2}".format(a,b,a&b))
print("{0} difference {1} = {2}".format(a,b,a-b))
print("{0} xor {1} = {2}".format(a,b,a^b))
#
c = { 1,2,3,4,5 }
d = { 1,2,3 }
#
print("{0} subset {1} = {2}".format(d,c,d.issubset(c)))
print("{0} superset {1} = {2}".format(c,d,c.issuperset(d)))
#
# a.add(x) N/A Add element x to the set a
# a.remove(x) N/A Remove element x from the set a
# a.union(b) a | b All of the unique elements in a and b .
# a.intersection(b) a & b All of the elements in both a and b .
# a.difference(b) a - b The elements in a that are not in b .
# a.symmetric_difference(b) a ^ b All of the elements in a or b but not both.
# a.issubset(b) N/A True if the elements of a are all contained in b .
# a.issuperset(b) N/A True if the elements of b are all contained in a .
# a.isdisjoint(b) N/A True if a and b have no elements in common.
#
#
sys.exit(0)

