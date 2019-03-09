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
def get_int(msg):
    while True:
        try:
            i = int(input(msg))
            return i
        except ValueError as err:
            print(err)
#
print("type integers, each followed by <enter>, or ^D or ^Z to finish")
#
total = 0
count = 0
#
while True:
    try:
        number = get_int("enter an integer: ")
        total += number
        count += 1
    except EOFError:
        break
#
if count:
    print("count = ", count, ", total = ", total, ", mean = ", total/count)
#
exit(0);

