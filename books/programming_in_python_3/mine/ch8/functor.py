#!/usr/bin/python3

import sys
import strip

def main():
    strip_me = strip.Strip("[]")

    for arg in sys.argv[1:]:
        print("{0} <<==>> {1}".format(arg, strip_me(arg)))

main()

sys.exit(0)

