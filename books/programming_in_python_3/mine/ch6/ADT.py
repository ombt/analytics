import copy
import inspect

def lnno():
    print("LNNO: {0}".format(inspect.currentframe().f_back.f_lineno))

class BinaryTreeNode:

    def __init__(self, value=None):
        self.value = value
        self.left = None
        self.right = None

    def copy_ctor(self, src):
        self.value = src.value
        self.left = None
        self.right = None

    def __assign__(self, rhs):
        if id(self) != id(rhs):
            self.value = rhs.value
            self.left = None
            self.right = None
        return self

    def __lt__(self, rhs):
        return self.value < rhs.value

    def __eq__(self, rhs):
        if rhs != None:
            return self.value == rhs.value
        else:
            return False

class BinaryTree:

    def __init__(self):
        self.root = None

    def copy_ctor(self, src):
        self.root = copy.deepcopy(src.root)

    def __assign__(self, rhs):
        if id(self) != id(rhs):
            self.root = copy.deepcopy(rhs.root)
        return self

    def insert(self, value):
        if self.root == None:
            self.root = BinaryTreeNode(value)
        else:
            self._insert(self.root, value)

    def remove(self, value):
        if self.root != None:
            if self.root.value == value:
                self.root = None
            else:
                self._remove(self.root, value)

    def retrieve(self, value):
        return self._retrieve(self.root, value)

    def is_empty(self):
        return self.root == None

    def clear(self):
        self.root = None

    def __str__(self):
        return str()

    def pre_order(self, work):
        self._pre_order(self.root, work)

    def in_order(self, work):
        self._in_order(self.root, work)

    def post_order(self, work):
        self._post_order(self.root, work)

    def _insert(self, node, value):
        if value < node.value:
            if node.left != None:
                self._insert(node.left, value)
            else:
                node.left = BinaryTreeNode(value)
        else:
            if node.right != None:
                self._insert(node.right, value)
            else:
                node.right = BinaryTreeNode(value)

    def _remove(self, node, value):
        if value < node.value:
            self._remove(node.left, value)
            return
        elif value > node.value:
            self._remove(node.right, value)
            return

        if (node.left != None) and (node.right == None):
            node.value = None
            node = None
        elif node.left == None:
            right = node.right
            node = None
            node = right
        elif node.right == None:
            left = node.left
            node = None
            node = left
        else:
            return self._remove_rightmost(node.left, node.value)
        return True

    def _remove_rightmost(self, node, value):
        if node.right != None:
            return self._remove_rightmost(node.right, value)
        else:
            value = node.value
            left = node.left
            node = None
            node = left
            return True

    def _retrieve(self, node, value):
        if node == None:
            return False
        elif value < node.value:
            return self._retrieve(node.left, value)
        elif value > node.value:
            return self._retrievw(node.right, value)
        else:
            value = node.value
            return True

    def _includes(self, node, value):
        if node == None:
            return False
        elif value < node.value:
            return self.includes(node.left, value)
        elif value > node.value:
            return self.includes(node.right, value)
        else:
            return True

    def _pre_order(self, node, work):
        if node != None:
            work(node.value)
            self._pre_order(node.left, work)
            self._pre_order(node.right, work)

    def _in_order(self, node, work):
        if node != None:
            self._in_order(node.left, work)
            work(node.value)
            self._in_order(node.right, work)

    def _post_order(self, node, work):
        if node != None:
            self._post_order(node.left, work)
            self._post_order(node.right, work)
            work(node.value)

    def dump(self):
        if self.root != None:
            self._dump(self.root)

    def _dump(self, node):
        if node != None:
            self._dump(node.left)
            print(node.value)
            self._dump(node.right)

class Node:
    def __init__(self, val):
        self.l = None
        self.r = None
        self.v = val

class Tree:
    def __init__(self):
        self.root = None

    def getRoot(self):
        return self.root

    def add(self, val):
        if(self.root == None):
            self.root = Node(val)
        else:
            self._add(val, self.root)

    def _add(self, val, node):
        if(val < node.v):
            if(node.l != None):
                self._add(val, node.l)
            else:
                node.l = Node(val)
        else:
            if(node.r != None):
                self._add(val, node.r)
            else:
                node.r = Node(val)

    def find(self, val):
        if(self.root != None):
            return self._find(val, self.root)
        else:
            return None

    def _find(self, val, node):
        if(val == node.v):
            return node
        elif(val < node.v and node.l != None):
            self._find(val, node.l)
        elif(val > node.v and node.r != None):
            self._find(val, node.r)

    def deleteTree(self):
        # garbage collector will do this for us. 
        self.root = None

    def printTree(self):
        if(self.root != None):
            self._printTree(self.root)

    def _printTree(self, node):
        if(node != None):
            self._printTree(node.l)
            print(node.v)
            self._printTree(node.r)

