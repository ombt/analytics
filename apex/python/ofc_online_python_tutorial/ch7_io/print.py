#!/usr/bin/python3

s = 'Hello, world.'
print(str(s))

print(repr(s))

print(str(1/7))

x = 10 * 3.25
y = 200 * 200
s = 'The value of x is ' + repr(x) + ', and y is ' + repr(y) + '...'
print(s)

# The repr() of a string adds string quotes and backslashes:
hello = 'hello, world\n'
hellos = repr(hello)
print(hellos)

# The argument to repr() may be any Python object:
print(repr((x, y, ('spam', 'eggs'))))

for x in range(1, 11):
    print(repr(x).rjust(2), repr(x*x).rjust(3), end=' ')
    # Note use of 'end' on previous line
    print(repr(x*x*x).rjust(4))

for x in range(1, 11):
    print('{0:2d} {1:3d} {2:4d}'.format(x, x*x, x*x*x))

print('12'.zfill(5))
print('-3.14'.zfill(7))
print('3.14159265359'.zfill(5))

exit()
