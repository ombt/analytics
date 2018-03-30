#!/usr/bin/python3

t = 12345, 54321, 'hello!'

print(t)
print(t[0])

# Tuples may be nested:
u = t, (1, 2, 3, 4, 5)
print(u)

# Tuples are immutable:
# ... t[0] = 88888
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
# TypeError: 'tuple' object does not support item assignment
# but they can contain mutable objects:

v = ([1, 2, 3], [3, 2, 1])
print(v)

empty = ()
print(empty)

singleton = 'hello',    # <-- note trailing comma
print(len(empty))

print(len(singleton))

print(singleton)

exit()
