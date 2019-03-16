#!/usr/bin/python3
#
# all operations from a sequence can be applied to a list.
#
# sequence unpacking
#
data = [ 0, 2, -4, 8, 7 ]
print("data ... ", data)
#
first, *rest = data
print("first ... ", first)
print("rest ... ", rest)
#
path = "/home/mrumore/f/sandbox/analytics/books/programming_in_python_3/mine/ch3"
*directories, executable = path.split("/")
#
print(directories, executable)
#
def product(a,b,c):
    return a*b*c
#
print(product(2,3,5))
#
L = [ 2, 3, 5 ];
print(product(*L))
#
print(product(2, *L[1:]))
#
# list methods:
#
# Syntax Description
# L.append(x) Appends item x to the end of list L
# L.count(x) Returns the number of times item x occurs in list L
# L.extend(m)
# L += m
# Appends all of iterable m’s items to the end of list L; the
# operator += does the same thing
# L.index(x,
# start,
# end)
# Returns the index position of the leftmost occurrence of
# item x in list L (or in the start:end slice of L); otherwise,
# raises a ValueError exception
# L.insert(i, x) Inserts item x into list L at index position int i
# L.pop() Returns and removes the rightmost item of list L
# L.pop(i) Returns and removes the item at index position int i in L
# L.remove(x) Removes the leftmost occurrence of item x from list L, or
# raises a ValueError exception if x is not found
# L.reverse() Reverses list L in-place
# L.sort(...) Sorts list L in-place; this method accepts sorted()
# the same key and reverse optional arguments as the built-in sorted()
#
# changing contets of a list
#
# L = a list
# for i in range(len(L)):
#     L[i] = process(L[i])
#
numbers = [ 2, 3, 4, 5, 6, 7 ]
print("before numbers are ... ", numbers)
for i in range(len(numbers)):
    numbers[i] += 1
print("after numbers are ... ", numbers)
#
numbers = numbers[:3] + [ numbers ] + numbers[3:]
print("numbers are ... ", numbers)
#
# list comprehension
#
# [ item for item in iterable ]
# [ expression for item in iterable ]
# [ expression for item in iterable if condition ]
#
leaps = [y for y in range(1900, 1940)]
print("1) leaps ... ", leaps)
leaps = [y for y in range(1900, 1940) if y % 4 == 0]
print("2) leaps ... ", leaps)
leaps = [y for y in range(1900, 1940) if (y % 4 == 0 and y % 100 != 0) or (y % 400 == 0)]
print("3) leaps ... ", leaps)
#
codes = []
for sex in "MF": # Male, Female
    for size in "SMLX": # Small, Medium, Large, eXtra large
        if sex == "F" and size == "X":
            continue
        for color in "BGW": # Black, Gray, White
            codes.append(sex + size + color)
print("first code ... ", codes)
#
codes = [s + z + c for s in "MF" for z in "SMLX" for c in "BGW" if not (s == "F" and z == "X")]
print("second code ... ", codes)
#
exit(0);

