#!/usr/bin/python3
#
a,b = 0,1
#
# evaluation are as follows:
#
# all expressions on the RHS of the equal sign are 
# evaluated first from left to right. then the assignments
# are made. see the second loop below for how the evaluations 
# performed.
#
while (b<10):
    print('b = ', b)
    a, b = b, a+b
#
c,d = 0,1
while (d<10):
    print('d = ', d)
    #
    # c, d = d, c+d
    #
    # evaluations
    tmp1 = d
    tmp2 = c+d
    #
    # assignments
    c = tmp1
    d = tmp2
#
a,b = 0,1
while (b<10):
    print('b=', b, end=', ')
    a, b = b, a+b
print()
#
exit(2)

