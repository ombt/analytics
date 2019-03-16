#!/usr/bin/python3
#
# mapping types -
#
# A mapping type is one that supports the membership operator (in) and the 3.x
# size function (len()), and is iterable. Mappings are collections of key–value
# items and provide methods for accessing items and their keys and values.
# When iterated, unordered mapping types provide their items in an arbitrary
# order. Python 3.0 provides two unordered mapping types, the built-in dict
# type and the standard library’s collections.defaultdict type. A new, ordered
# mapping type, collections.OrderedDict,was introduced with Python 3.1; this is
# a dictionary that has the same methods and properties (i.e., the same API) as
# the built-in dict, but stores its items in insertion order.★ We will use the term
# dictionary to refer to any of these types when the difference doesn’t matter.
# Hash- Only hashable objectsmay be used as dictionary keys, so immutable
# able
# objects
# 121 ➤
# data types
# such as float, frozenset, int, str, and tuple can be used as dictionary keys, but
# mutable types such as dict, list, and set cannot. On the other hand, each key’s
# associated value can be an object reference referring to an object of any type,
# including numbers, strings, lists, sets, dictionaries, functions, and so on.
# Dictionary types can be compared using the standard equality comparison operators
# (== and !=), with the comparisons being applied item by item (and recursively
# for nested items such as tuples or dictionaries inside dictionaries).Comparisons
# using the other comparison operators (<, <=, >=, >) are not supported
# since they don’t make sense for unordered collections such as dictionaries
#
# dicts -
#
d1 = dict({"id": 1948, "name": "Washer", "size": 3})
print("d1 = ", d1)
d2 = dict(id=1948, name="Washer", size=3)
print("d2 = ", d2)
d3 = dict([("id", 1948), ("name", "Washer"), ("size", 3)])
print("d3 = ", d3)
d4 = dict(zip(("id", "name", "size"), (1948, "Washer", 3)))
print("d4 = ", d4)
d5 = {"id": 1948, "name": "Washer", "size": 3}
print("d5 = ", d5)
#
#
d = {"root": 18, "blue": [75, "R", 2], 21: "venus", -14: None,
"mars": "rover", (4, 11): 18, 0: 45}
print('d is ... ', d)
#
# iterate over dict
#
for item in d.items():
    print(item[0], item[1])
#
for key, value in d.items():
    print(key, value)
#
# Iterating over a dictionary’s values is very similar:
#
for value in d.values():
    print(value)
#
# To iterate over a dictionary’s keys we can use dict.keys(), or we can simply
# treat the dictionary as an iterable that iterates over its keys, as these two
# equivalent code snippets illustrate:
#
for key in d:
    print(key)
#
for key in d.keys():
    print(key)
#
# Syntax Description
# d.clear() Removes all items from dict d
# d.copy() Returns a shallow copy of dict d Shallow
# and
# deep
# copying
# ➤146
# d.fromkeys(
# s, v)
# Returns a dict whose keys are the items in sequence s and
# whose values are None or v if v is given
# d.get(k) Returns key k’s associated value, or None if k isn’t in dict d
# d.get(k, v) Returns key k’s associated value, or v if k isn’t in dict d
# d.items() Returns a view★ of all the (key, value) pairs in dict d
# d.keys() Returns a view★ of all the keys in dict d
# d.pop(k) Returns key k’s associated value and removes the item
# whose key is k, or raises a KeyError exception if k isn’t in d
# d.pop(k, v) Returns key k’s associated value and removes the item
# whose key is k, or returns v if k isn’t in dict d
# d.popitem() Returns and removes an arbitrary (key, value) pair from
# dict d, or raises a KeyError exception if d is empty
# d.setdefault(
# k, v)
# The same as the dict.get() method, except that if the key is
# not in dict d, a new item is inserted with the key k, and with
# a value of None or of v if v is given
# d.update(a) Adds every (key, value) pair from a that isn’t in dict d to d,
# and for every key that is in both d and a, replaces the corresponding
# value in d with the one in a—a can be a dictionary,
# an iterable of (key, value) pairs, or keyword arguments
# d.values() Returns a view★ of all the values in dict d
#
# set operations
#
s1 = { 1,2,3,4,5,6 }
print("s1 = ...", s1)
#
s2 = { 2,3,6 }
print("s2 = ...", s2)
#
print("s1 & s2 = ", s1&s2)
print("s1 | s2 = ", s1|s2)
print("s1 - s2 = ", s1-s2)
print("s1 ^ s2 = ", s1^s2)
#
d = {}.fromkeys("ABCD", 3) # d == {'A': 3, 'B': 3, 'C': 3, 'D': 3}
print("d is ... ", d);
#
s = set("ACX") # s == {'A', 'C', 'X'}
print("s is ... ", s);
#
matches = d.keys() & s # matches == {'A', 'C'}
print("matches is ... ", matches);

#
exit(0);

