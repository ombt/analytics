#!/usr/bin/python3

import sys

from utils.printf import printf as printf

format = 'usage: %s number\n'

if len(sys.argv) < 2:
    printf(format, sys.argv[0])
    exit(2)

try:
    example = int(sys.argv[1])
except ValueError as err:
    print('Handling value error:', err)
    exit(2)
except Exception as err:
    print('Handling run-time error:', err)
    exit(2)

if example == 1:
    raise NameError("Example 1 of raise!!!")
elif example == 2:
    raise ValueError
else:
    try:
        raise NameError('HiThere')
    except NameError:
        print('An exception flew by!')
        raise

exit()
