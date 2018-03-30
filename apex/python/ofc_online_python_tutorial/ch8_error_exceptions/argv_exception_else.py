#!/usr/bin/python3

import sys

if len(sys.argv) < 2:
    print('No files given, schmuck!')
    exit(2)

for arg in sys.argv[1:]:
    try:
        f = open(arg, 'r')
    except OSError:
        print('cannot open', arg)
    else:
        print(arg, 'has', len(f.readlines()), 'lines')
        f.close()

exit()
