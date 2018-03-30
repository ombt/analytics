#!/usr/bin/python3
#
b=1
while (b!=0):
    b = int(input("enter an integer: "))
    if (b<0):
        print(b, "is less than 0.")
    elif (b>0):
        print(b, "is greater than 0.")
    else:
        print(b, "is 0. Exiting.")
#
exit(2)

