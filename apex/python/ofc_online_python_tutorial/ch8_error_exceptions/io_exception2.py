#!/usr/bin/python3

class B(Exception):
    pass

class C(B):
    pass

class D(C):
    pass

for cls in [B, C, D]:
    try:
        raise cls()
    except D:       # try to match derived before base class
        print("D")
    except C:       # try to match derived before base class
        print("C")
    except B:       # base class, put it last, else see below.
        print("B")

for cls in [B, C, D]:
    try:
        raise cls()
    except B:       # base clase, so it matches all cases!
        print("B")
    except D:       # never gets here
        print("D")
    except C:       # never gets here
        print("C")

exit()
