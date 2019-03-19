#
# this version of ADT uses nested functions. the nested function
# does NOT have self as an argument and cannot be called directly
# outside of the function which encloses it.
#
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
        def _insert(node, value):
            if value < node.value:
                if node.left != None:
                    _insert(node.left, value)
                else:
                    node.left = BinaryTreeNode(value)
            else:
                if node.right != None:
                    _insert(node.right, value)
                else:
                    node.right = BinaryTreeNode(value)
            return
        if self.root == None:
            self.root = BinaryTreeNode(value)
        else:
            _insert(self.root, value)

    def retrieve(self, value):
        def _retrieve(node, value):
            if node == None:
                return False
            elif value < node.value:
                return _retrieve(node.left, value)
            elif value > node.value:
                return _retrievw(node.right, value)
            else:
                value = node.value
                return True
        return _retrieve(self.root, value)

    def is_empty(self):
        return self.root == None

    def clear(self):
        self.root = None

    def __str__(self):
        return str()

    def pre_order(self, work):
        def _pre_order(node, work):
            if node != None:
                work(node.value)
                _pre_order(node.left, work)
                _pre_order(node.right, work)
            return
        _pre_order(self.root, work)

    def in_order(self, work):
        def _in_order(node, work):
            if node != None:
                _in_order(node.left, work)
                work(node.value)
                _in_order(node.right, work)
            return
        _in_order(self.root, work)

    def post_order(self, work):
        def _post_order(node, work):
            if node != None:
                _post_order(node.left, work)
                _post_order(node.right, work)
                work(node.value)
            return
        _post_order(self.root, work)

    def includes(self, value):
        def _includes(node, value):
            if node == None:
                return False
            elif value < node.value:
                return _includes(node.left, value)
            elif value > node.value:
                return _includes(node.right, value)
            else:
                return True
        return _includes(self.root, value)

    def dump(self):
        def _dump(node):
            if node != None:
                _dump(node.left)
                print(node.value)
                _dump(node.right)
            return
        if self.root != None:
            _dump(self.root)

