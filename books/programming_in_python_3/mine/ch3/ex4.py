#!/usr/bin/python3
#
# sets
#
# A set type is a collection data type that supports the membership operator (in),
# the size function (len()), and is iterable. In addition, set types at least provide
# a set.isdisjoint() method, and support for comparisons, as well as support
# for the bitwise operators (which in the context of sets are used for union,
# intersection, etc.). Python provides two built-in set types: the mutable set type
# and the immutable frozenset. When iterated, set types provide their items in
# an arbitrary order.
#
# Only hashable objects may be added to a set. Hashable objects are objects
# which have a __hash__() special method whose return value is always the same
# throughout the object’s lifetime, and which can be compared for equality using
# the __eq__() special method. (Special methods—methods whose name begins
# and ends with two underscores—are covered in Chapter 6.)
# All the built-in immutable data types, such as float, frozenset, int, str, and
# tuple, are hashable and can be added to sets. The built-in mutable data types,
# such as dict, list, and set, are not hashable since their hash value changes
# depending on the items they contain, so they cannot be added to sets.
# Set types can be compared using the standard comparison operators (<, <=, ==,
# !=, >=, >). Note that although == and != have their usual meanings, with the
# comparisons being applied item by item (and recursively for nested items such
# as tuples or frozen sets inside sets), the other comparison operators perform
# subset and superset comparisons, as we will see shortly.
#
#
# Syntax Description
# s.add(x) Adds item x to set s if it is not already in s
# s.clear() Removes all the items from set s
# s.copy() Returns a shallow copy of set ❄ s Shallow
# and
# deep
# copying
# ➤146
# s.difference(t)
# s - t
# Returns a new set that has every item that is in
# set s that is not in set t❄
# s.difference_update(t)
# s -= t
# Removes every item that is in set t from set s
# s.discard(x) Removes item x from set s if it is in s; see also
# set.remove()
# s.intersection(t)
# s & t
# Returns a new set that has each item that is in
# both set s and set ❄ t
# s.intersection_update(t)
# s &= t
# Makes set s contain the intersection of itself
# and set t
# s.isdisjoint(t) Returns True if sets s and t have no items in
# ❄ common
# s.issubset(t)
# s <= t
# Returns True if set s is equal to or a subset of set
# t; use s < t to test whether s is a proper subset
# of ❄ t
# s.issuperset(t)
# s >= t
# Returns True if set s is equal to or a superset
# of set t; use s > t to test whether s is a proper
# superset of ❄ t
# s.pop() Returns and removes a random item from set s,
# or raises a KeyError exception if s is empty
# s.remove(x) Removes item x from set s, or raises a KeyError
# exception if x is not in s; see also set.discard()
# s.symmetric_
# difference(t)
# s ^ t
# Returns a new set that has every item that is in
# set s and every item that is in set t, but excluding
# items that are in both ❄ sets
# s.symmetric_
# difference_update(t)
# s ^= t
# Makes set s contain the symmetric difference of
# itself and set t
# s.union(t)
# s | t
# Returns a new set that has all the items in set s
# and all the items in set t that are not in set ❄ s
# s.update(t)
# s |= t
# Adds every item in set t that is not in set s, to
# set s
#
# set comprehension -
#
# 
# {expression for item in iterable}
# {expression for item in iterable if condition}
#
# We can use these to achieve a filtering effect (providing the order doesn’t
# matter). Here is an example:
# html = {x for x in files if x.lower().endswith((".htm", ".html"))}
#
#
# frozen sets -
#
A frozen set is a set that, once created, cannot be changed. We can of course
# rebind the variable that refers to a frozen set to refer to something else, though.
# Frozen sets can only be created using the Shallow
# and
# deep
# copying
# ➤146
# frozenset data type called as a
# function. With no arguments, frozenset() returns an empty frozen set, with a
# frozenset argument it returns a shallow copy of the argument, and with any
# other argument it attempts to convert the given object to a frozenset. It does
# not accept more than one argument.
# Since frozen sets are immutable, they support only those methods and operators
# that produce a result without affecting the frozen set or sets to which
# they are applied. Table 3.2 (123 ➤) lists all the set methods—frozen sets support
# frozenset.copy(), frozenset.difference() (-), frozenset.intersection() (&),
# frozenset.isdisjoint(), frozenset.issubset() (<=; also < for proper subsets),
# frozenset.issuperset() (>=; also > for proper supersets), frozenset.union() (|),
# and frozenset.symmetric_difference() (^), all of which are indicated by a ❄ in
# the table.
# If a binary operator is used with a set and a frozen set, the data type of the
# result is the same as the left-hand operand’s data type. So if f is a frozen set
# and s is a set, f & s will produce a frozen set and s & f will produce a set. In the
# case of the == and != operators, the order of the operands does not matter, and
# f == s will produce True if both sets contain the same items.


#
exit(0);

