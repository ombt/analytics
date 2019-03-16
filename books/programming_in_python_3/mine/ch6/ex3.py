#!/usr/bin/python3
#
import sys
#
#!/usr/bin/python3
#
import sys
import math
#
import Shape
#
p = Shape.AltPoint(28,45)
c = Shape.AltCircle(5,28,45)
#
print("AltPoint from origin: {0}".format(p.distance_from_origin))
print("AltCircle origin from origin: {0}".format(c.distance_from_origin))
print("AltCircle area: {0}".format(c.area))
print("AltCircle circumference : {0}".format(c.circumference))
#
# the following fails because of radius < 0
#
bad = Shape.AltCircle2(-4,2,3)
#
sys.exit(0);

