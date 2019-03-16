#!/usr/bin/python3
#
import sys
import math
#
import Shape
#
p = Shape.Point(28,45)
c = Shape.Circle(5,28,45)
#
print("Point from origin: {0}".format(p.distance_from_origin()))
print("Circle origin from origin: {0}".format(c.distance_from_origin()))
print("Circle area: {0}".format(c.area()))
print("Circle circumference : {0}".format(c.circumference()))
#
sys.exit(0);

