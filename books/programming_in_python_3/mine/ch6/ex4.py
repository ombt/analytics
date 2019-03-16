#!/usr/bin/python3
#
import sys
#
#
# Table 6.3 Numeric and Bitwise Special Methods
# Special Method Usage Special Method Usage
# __abs__(self) abs(x) __complex__(self) complex(x)
# __float__(self) float(x) __int__(self) int(x)
# __index__(self) bin(x) oct(x)
# hex(x)
# __round__(self,
# digits)
# round(x,
# digits)
# __pos__(self) +x __neg__(self) -x
# __add__(self, other) x + y __sub__(self, other) x - y
# __iadd__(self, other) x += y __isub__(self, other) x -= y
# __radd__(self, other) y + x __rsub__(self, other) y - x
# __mul__(self, other) x * y __mod__(self, other) x % y
# __imul__(self, other) x *= y __imod__(self, other) x %= y
# __rmul__(self, other) y * x __rmod__(self, other) y % x
# __floordiv__(self,
# other)
# x // y __truediv__(self,
# other)
# x / y
# __ifloordiv__(self,
# other)
# x //= y __itruediv__(self,
# other)
# x /= y
# __rfloordiv__(self,
# other)
# y // x __rtruediv__(self,
# other)
# y / x
# __divmod__(self,
# other)
# divmod(x, y) __rdivmod__(self,
# other)
# divmod(y, x)
# __pow__(self, other) x ** y __and__(self, other) x & y
# __ipow__(self, other) x **= y __iand__(self, other) x &= y
# __rpow__(self, other) y ** x __rand__(self, other) y & x
# __xor__(self, other) x ^ y __or__(self, other) x | y
# __ixor__(self, other) x ^= y __ior__(self, other) x |= y
# __rxor__(self, other) y ^ x __ror__(self, other) y | x
# __lshift__(self,
# other)
# x << y __rshift__(self,
# other)
# x >> y
# __ilshift__(self,
# other)
# x <<= y __irshift__(self,
# other)
# x >>= y
# __rlshift__(self,
# other)
# y << x __rrshift__(self,
# other)
# y >> x
# __invert__(self)
# -x
#
# By default, instances of custom classes support operator == (which always returns
# False), and are hashable (so can be dictionary keys and can be added
# to sets). But if we reimplement the __eq__() special method to provide proper
# equality testing, instances are no longer hashable. This can be fixed by providing
# a __hash__() special method as we have done here.
#


#
sys.exit(0);

