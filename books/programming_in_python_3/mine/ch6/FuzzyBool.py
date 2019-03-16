
class FuzzyBool:

    def __init__(self, value=0.0):
        self.__value = value if (0.0<= value <= 1.0) else 0.0

    def __invert__(self):
        return FuzzyBool(1.0 - self.__value)

    def __and__(self, other):
        return FuzzyBool(min(self.__value, other.__value))

    def __iand__(self, other):
        self.__value = min(self.__value, other.__value)
        return self

    def __or__(self, other):
        return FuzzyBool(max(self.__value, other.__value))

    def __ior__(self, other):
        self.__value = max(self.__value, other.__value)
        return self

    def __repr__(self):
        return ("{0}({1})".format(self.__class.__name__,
                                  self.__value))

    def __str__(self):
        return str(self.__value)

    def __bool__(self):
        return self.__value > 0.5

    def __int__(self):
        return round(self.__value)

    def __float__(self):
        return self.__value

    def __lt__(self, other):
        return self.__value < other.__value

    def __eq__(self, other):
        return self.__value == other.__value

    def __hash__(self):
        return hash(id(self))

    def __format(self, format_spec):
        return format(self.__value, format_spec)

    @staticmethod
    def conjunction(*fuzzies):
        return FuzzyBool(min([float(x) for x in fuzzies]))

    @staticmethod
    def disjunction(*fuzzies):
        return FuzzyBool(max([float(x) for x in fuzzies]))

class AltFuzzyBool(float):

    def __new__(cls, value=0.0)
        return super().__new__(cls, 
                value if (0.0 <= value <= 1.0) else 0.0

    def __init__(self, value=0.0):
        self.__value = value if (0.0<= value <= 1.0) else 0.0

    def __invert__(self):
        return FuzzyBool(1.0 - float(self))

    def __and__(self, other):
        return Fuzzybool(min(self, other))

    def __iand__(self, other):
        self.__value = min(self, other)
        return self

    def __or__(self, other):
        return Fuzzybool(max(self, other))

    def __ior__(self, other):
        self.__value = max(self, other)
        return self

    def __repr__(self):
        return ("{0}({1})".format(self.__class.__name__,
                                  super.__repr__()))

    def __str__(self):
        return str(self.__value)

    def __bool__(self):
        return self > 0.5

    def __int__(self):
        return round(self)

    def __float__(self):
        return self.__value

    def __lt__(self, other):
        return self.__value < other.__value

    def __eq__(self, other):
        return self.__value == other.__value

    def __add__(self, other):
        raise NotImplementedError()

    def __iadd__(self, other):
        raise NotImplementedError()

    def __radd__(self, other):
        raise NotImplementedError()

    @staticmethod
    def conjunction(*fuzzies):
        return FuzzyBool(min([float(x) for x in fuzzies]))

    @staticmethod
    def disjunction(*fuzzies):
        return FuzzyBool(max([float(x) for x in fuzzies]))

    for name, operator in (("__neg__", "-"),
                           ("__index__", "index()")):
        message = ("bad operand type for unary {0}: '{{self}}'"
                   .format(operator))
        exec("def {0}(self): raise TypeError(\"{1}\".format("
             "self=self.__class__.__name__))".format(name, message))

    for name, operator in (("__xor__", "^"), ("__ixor__", "^="),
                           ("__add__", "+"), ("__iadd__", "+="), ("__radd__", "+"),
                           ("__sub__", "-"), ("__isub__", "-="), ("__rsub__", "-"),
                           ("__mul__", "*"), ("__imul__", "*="), ("__rmul__", "*"),
                           ("__pow__", "**"), ("__ipow__", "**="),
                           ("__rpow__", "**"), ("__floordiv__", "//"),
                           ("__ifloordiv__", "//="), ("__rfloordiv__", "//"),
                           ("__truediv__", "/"), ("__itruediv__", "/="),
                           ("__rtruediv__", "/"), ("__divmod__", "divmod()"),
                           ("__rdivmod__", "divmod()"), ("__mod__", "%"),
                           ("__imod__", "%="), ("__rmod__", "%"),
                           ("__lshift__", "<<"), ("__ilshift__", "<<="),
                           ("__rlshift__", "<<"), ("__rshift__", ">>"),
                           ("__irshift__", ">>="), ("__rrshift__", ">>")):
                           message = ("unsupported operand type(s) for {0}: "
                                      "'{{self}}'{{join}} {{args}}".format(operator))
        exec("def {0}(self, *args):\n"
             " types = [\"'\" + arg.__class__.__name__ + \"'\" "
             "for arg in args]\n"
             " raise TypeError(\"{1}\".format("
             "self=self.__class__.__name__, "
             "join=(\" and\" if len(args) == 1 else \",\"),"
             "args=\", \".join(types)))".format(name, message))

