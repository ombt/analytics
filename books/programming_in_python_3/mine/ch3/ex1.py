#!/usr/bin/python3
#
# sequence supports 'in', len(), [], and is iterable.
#
# five types: bytearray, bytes, list, str, tuple
#
# tuples - ordered sequence of zero or more object references
# immutable, so we need to convert to a list, make the changes, then
# save as a new tuple.
#
# empty tuples -
#
t1 = tuple()
t2 = ()
#
t1 = tuple(["venus", -38, "green", 10.74, "green"])
print("t1 ... ", t1[::-1])
#
print("how many 'green' in tuple ...", t1.count("green"))
print("how many -38 in tuple ...", t1.count(-38))
#
# additional operators:
#
t2 = t1
print("t2 = t1 ... ", t2)
#
t2 *= 2
print("t2 *= 2 ... ", t2)
print("t2 + t1 ... ", t2+t1)
#
if t1<t2:
    print("t1 < t2")
elif t1<=t2:
    print("t1 <= t2")
elif t1==t2:
    print("t1 == t2")
elif t1>=t2:
    print("t1 >= t2")
elif t1>t2:
    print("t1 > t2")
else:
    print("t1 ??? t2")

#
exit(0);

