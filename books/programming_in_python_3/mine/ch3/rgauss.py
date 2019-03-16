#!/usr/bin/python3
#
import sys as os
import math as m
import random as r
#
#
def usage():
    print("usage: {0} [-?] [-S seed] "
          "[-s sigma] [-m mu] [-I] number".format(os.argv[0]))
#
def my_int(svalue):
    try:
        return int(svalue)
    except ValueError as err:
        print(err);
        os.exit(-1)
#
def my_float(svalue):
    try:
        return float(svalue)
    except ValueError as err:
        print(err);
        os.exit(-1)
#
use_last = False
y2 = 0.0
#
def gen_gauss(mu, sigma):
    #
    # use box-fuller method
    #
    global use_last, y2
    #
    y1 = 0.0
    #
    if use_last:
        use_last = False
        y1 = y2
    else:
        while True:
            x1 = 2.0*r.random() - 1.0
            x2 = 2.0*r.random() - 1.0
            w = x1*x1 + x2*x2
            if w<1.0:
                break
        #
        w = m.sqrt((-2.0*m.log(w))/w)
        y1 = x1*w
        y2 = x2*w
        #
        use_last = True
    #
    return mu+y1*sigma
#
def main():
    #
    # do we have the correct number of arguments
    #
    if len(os.argv) < 2:
        usage();
        os.exit(2)
    #
    mu = 0
    sigma = 1
    iseed = None
    use_int = False
    #
    iarg = 1
    iargmax = len(os.argv)
    while iarg<iargmax:
        if os.argv[iarg] == "-?":
            usage()
            os.exit(2)
        elif os.argv[iarg] == "-s":
            iarg += 1
            sigma = my_float(os.argv[iarg])
            iarg += 1
        elif os.argv[iarg] == "-m":
            iarg += 1
            mu = my_float(os.argv[iarg])
            iarg += 1
        elif os.argv[iarg] == "-S":
            iarg += 1
            iseed = my_int(os.argv[iarg])
            iarg += 1
        elif os.argv[iarg] == "-I":
            use_int = True
            iarg += 1
        else:
            break;
    #
    r.seed(iseed)
    #
    if iarg>=iargmax:
        usage()
        os.exit(-1)
    #
    n = my_int(os.argv[iarg])
    #
    print("\nMU: {0}\nSIGMA: {1}\nN: {2}\n".format(mu, sigma, n))
    #
    if use_int:
        for inum in range(n):
            print(int(gen_gauss(mu, sigma)))
    else:
        for inum in range(n):
            print(gen_gauss(mu, sigma))
#
# start programs
#
main()
#
os.exit(0)
