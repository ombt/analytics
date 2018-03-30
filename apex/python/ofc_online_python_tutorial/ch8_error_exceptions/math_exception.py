#!/usr/bin/python3

import sys

from utils.printf import printf as printf

def divide(n):
    return 1/float(n)

format = 'usage: %s number [...]\n'

if len(sys.argv) < 2:
    printf(format, sys.argv[0])
    exit(2)

for arg in sys.argv[1:]:
    try:
        printf("1/%s = %f\n", arg, divide(arg))
    except ZeroDivisionError as err:
        print('Handling run-time error:', err)
    except ValueError as err:
        print('Handling run-time error:', err)

exit()
