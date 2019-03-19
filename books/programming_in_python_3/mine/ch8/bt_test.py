#!/usr/bin/python3 
#
import sys
#
import ADT
#
def work(x):
    print(x)
#
bt = ADT.BinaryTree()
#
bt.insert(2)
bt.insert(1)
bt.insert(3)
#
print("includes ... {0}".format(bt.includes(2)))
#
bt.in_order(work)
bt.pre_order(work)
bt.post_order(work)
#
sys.exit(0);

