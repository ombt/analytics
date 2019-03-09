#!/usr/bin/python3
#
import sys
#
# python ketwords:
#
# and continue except global lambda pass while
# as def False if None raise with
# assert del finally import nonlocal return yield
# break elif for in not True
# class else from is or try
#
# list of built in attributes
#
print("list of python attrs", dir())
for attr in dir():
    print("attr ", attr, " = ", dir(attr))
#
exit(0);

