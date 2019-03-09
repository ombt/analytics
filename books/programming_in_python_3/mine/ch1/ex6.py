#!/usr/bin/python3
#
# template for console programs and modules.
#
# function syntax:
#
# def functionName(arguments):
#     suite
#
# unless a return statement is used, then the default return value
# from a functions is None.
#
# one or more than one value can be returned (tuple of values for more
# than one value)
#
# get an integer from a user
#
import sys
#
print("sum these numbers: ", sys.argv)
#
total = 0
count = 0
#
for number in sys.argv:
    try:
        total += int(number)
        count += 1
    except ValueError:
        continue
#
if count:
    print("count = ", count, ", total = ", total, ", mean = ", total/count)
#
exit(0);

