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
bt.in_order(work)
bt.pre_order(work)
bt.post_order(work)
#
# bt.remove(1)
# bt.in_order(work)
# bt.remove(2)
# bt.in_order(work)
# bt.remove(3)
# bt.in_order(work)
#
t = ADT.Tree()
#
t.add(2)
t.add(1)
t.add(3)
#
t.printTree()
#
sys.exit(0);

