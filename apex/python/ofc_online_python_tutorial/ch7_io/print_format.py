#!/usr/bin/python3

print('We are the {} who say "{}!"'.format('knights', 'Ni'))

print('{0} and {1}'.format('spam', 'eggs'))
print('{1} and {0}'.format('spam', 'eggs'))

print('This {food} is {adjective}.'.format(
       food='spam', adjective='absolutely horrible'))

print('The story of {0}, {1}, and {other}.'.format('Bill', 'Manfred', other='Georg'))

# '!a' (apply ascii()), '!s' (apply str()) and '!r' (apply repr()) can be used to convert the value before it is formatted:

contents = 'eels'
print('My hovercraft is full of {}.'.format(contents))
print('My hovercraft is full of {!r}.'.format(contents))

import math
print('The value of PI is approximately {0:.3f}.'.format(math.pi))

table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 7678}
for name, phone in table.items():
    print('{0:10} ==> {1:10d}'.format(name, phone))

table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 8637678}
print('Jack: {Jack:d}; Sjoerd: {Sjoerd:d}; Dcab: {Dcab:d}'.format(**table))

print('The value of PI is approximately %5.3f.' % math.pi)

exit()
