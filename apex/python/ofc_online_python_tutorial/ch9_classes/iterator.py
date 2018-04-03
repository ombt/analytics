#!/usr/bin/python3

for element in [1, 2, 3]:
    print(element)

for element in (1, 2, 3):
    print(element)

for key in {'one':1, 'two':2}:
    print(key)

for char in "123":
    print(char)

# for line in open("myfile.txt"):
#     print(line, end='')

s = 'abc'

it = iter(s)
print(it)

try:
    print(next(it))
    print(next(it))
    print(next(it))
    print(next(it))
except Exception as err:
    print(str(err))

exit()
