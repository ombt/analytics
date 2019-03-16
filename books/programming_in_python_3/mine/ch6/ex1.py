#!/usr/bin/python3
#
import sys
import math
#
# creating classeso
#
# class ClassName:
#     suite
#
# class ClassName(base_classes):
#     suite
#
# Special Method Usage Description
# __lt__(self, other) x < y Returns True if x is less than y
# __le__(self, other) x <= y Returns True if x is less than or equal to y
# __eq__(self, other) x == y Returns True if x is equal to y
# __ne__(self, other) x != y Returns True if x is not equal to y
# __ge__(self, other) x >= y Returns True if x is greater than or equal to y
# __gt__(self, other) x > y Returns True if x is greater than y
#
import Shape
#
a = Shape.Point()
#
print(repr(a))
#
b=Shape.Point(3,4)
print(str(b))
#
print("hypotenuse: {0}".format(b.distance_from_origin()))
#
b.x = -19
print(str(b))
#
print(a==b, a!=b)
#
# copy ctor a la Python !!!
#
p = Shape.Point(3,9)
print(repr(p))
#
q = eval(p.__module__ + "." + repr(p))
print(repr(q))
#
print(p.x, p.y)
print(q.x, q.y)
#
print(p == p)
print(p == q)
#
sys.exit(0);

