#!/usr/bin/python3

#
# from:
# https://stackoverflow.com/questions/19457227/how-to-print-like-printf-in-python3
#

import sys

def printf(format, *args):
    sys.stdout.write(format % args)

# Example output:

i = 7
pi = 3.14159265359

printf("hi there, i=%d, pi=%.2f\n", i, pi)
# hi there, i=7, pi=3.14

s = 'aaa'

try:
    printf("s=%d\n", s)
except Exception as e:
    print("Caught ... ", e.__class__.__name__);
    print(e)

try:
    printf("s=%y\n", s)
except Exception as e:
    print("Caught ... ", e.__class__.__name__);
    print(e)

exit()
