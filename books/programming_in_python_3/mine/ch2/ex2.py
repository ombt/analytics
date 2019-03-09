#!/usr/bin/python3
#
import sys
#
# python ketwords:
#
# and continue except global lambda pass while
# as def False if None raise with
# assert del finally import nonlocal return yield
# break elif for in not True
# class else from is or try
#
# integral types are bool and int.
#
# 0 and false are false
# any non-zero number and true are true.
#
# integers have infinite precision
#
# Syntax Description
#
# x + y Adds number x and number y
#
# x - y Subtracts y from x
#
# x * y Multiplies x by y
#
# x / y Divides x by y; always produces a float (or a complex if x or y
# is complex)
#
# x // y Divides x by y; truncates any fractional part so always produces
# an int result; see also the round() function
#
# x % y Produces the modulus (remainder) of dividing x by y
#
# x ** y Raises x to the power of y; see also the pow() functions
#
# -x Negates x; changes x’s sign if nonzero, does nothing if zero
#
# +x Does nothing; is sometimes used to clarify code
#
# abs(x) Returns the absolute value of x
#
# Tuples divmod(x, y) Returns the quotient and remainder of dividing
# 18 ➤
# Tuples
# ➤108
#
# x by y as a
# tuple of two ints
#
# pow(x, y) Raises x to the power of y; the same as the ** operator
#
# pow(x, y, z) A faster alternative to (x ** y) % z
#
# round(x, n) Returns x rounded to n integral digits if n is a negative int
# or returns x rounded to n decimal places if n is a positive int;
# the returned value has the same type as x; see the text
# 
# integer conversion functions
# 
# bin(i) Returns the binary representation of int i as a string, e.g.,
# bin(1980) == '0b11110111100'
#
# hex(i) Returns the hexadecimal representation of i as a string, e.g.,
# hex(1980) == '0x7bc'
#
# int(x) Converts object x to an integer; raises ValueError on
# failure—or TypeError if x’s data type does not support integer
# conversion. If x is a floating-point number it is truncated.
# int(s, base) Converts str s to an integer; raises ValueError on failure. If
# the optional base argument is given it should be an integer
# between 2 and 36 inclusive.
#
# oct(i) Returns the octal representation of i as a string, e.g.,
# oct(1980) == '0o3674'
#
# +, -, /, //, %, ** have these +=, -=, /= //= %= **=
#
#
# The first use case is when a data type is called with no arguments. 
# In this case an object with a default value is created—for example, 
# x = int() creates an integer of value 0. All the built-in types can 
# be called with no arguments
# 
# bit-wise binary operations;
#
# Syntax Description
# i | j Bitwise OR of int i and int j; negative numbers are assumed to be
# represented using 2’s complement
#
# i ^ j Bitwise XOR (exclusive or) of i and j
#
# i & j Bitwise AND of i and j
#
# i << j Shifts i left by j bits; like i * (2 ** j) without overflow checking
#
# i >> j Shifts i right by j bits; like i // (2 ** j) without overflow checking
#
# ~i Inverts i’s bits
#
# these also exit: |= ^= &= <<= >>=
#
# booleana are True and False
#
# floating-point types:
#
# float, complex and decimal.Decimal
#
#
# math module's functions and constants:
#
#
# Syntax Description
# 
# math.acos(x) Returns the arc cosine of x in radians
# math.acosh(x) Returns the arc hyperbolic cosine of x in radians
# math.asin(x) Returns the arc sine of x in radians
# math.asinh(x) Returns the arc hyperbolic sine of x in radians
# math.atan(x) Returns the arc tangent of x in radians
# math.atan2(y, x) Returns the arc tangent of y / x in radians
# math.atanh(x) Returns the arc hyperbolic tangent of x in radians
# math.ceil(x) Returns ⎡x⎤ , i.e., the smallest integer greater than or
# equal to x as an int; e.g., math.ceil(5.4) == 6
# math.copysign(x,y) Returns x with y’s sign
# math.cos(x) Returns the cosine of x in radians
# math.cosh(x) Returns the hyperbolic cosine of x in radians
# math.degrees(r) Converts float r from radians to degrees
# math.e The constant e; approximately 2.7182818284590451
# math.exp(x) Returns ex, i.e., math.e ** x
# math.fabs(x) Returns | x |, i.e., the absolute value of x as a float
# math.factorial(x) Returns x!
# math.floor(x) Returns ⎣x⎦ , i.e., the largest integer less than or equal
# to x as an int; e.g., math.floor(5.4) == 5
# math.fmod(x, y) Produces the modulus (remainder) of dividing x by y;
# this produces better results than % for floats
# Tuples math.frexp(x) Returns a 2-tuple with the mantissa (as a
# 18 ➤
# Tuples
# ➤108
# float) and
# the exponent (as an int) so, x = e m × 2 ; see math.ldexp()
# math.fsum(i) Returns the sum of the values in iterable i as a float
# math.hypot(x, y) Returns √x2 + y2
# math.isinf(x) Returns True if float x is ± inf (± ∞)
# math.isnan(x) Returns True if float x is nan (“not a number”)
# math.ldexp(m, e) Returns e m × 2 ; effectively the inverse of math.frexp()
# math.log(x, b) Returns logbx; b is optional and defaults to math.e
# math.log10(x) Returns log10x
# math.log1p(x) Returns loge(1+ x); accurate even when x is close to 0
# math.modf(x) Returns x’s fractional and whole parts as two floats
#
# complex numbers
#
z = 1.444+2.4j
print("z = ", z)
print("z* = ", z.conjugate())
#
# to get complex version of math module:
#
import cmath
#
print("sin(1-1j) = ", cmath.sin(11-1j))
#
# decimal module:
#
import decimal
3
a = decimal.Decimal(9876)
print("decimal a ... ", a)
b = decimal.Decimal("54321.1234567890987654321")
print("decimal b ... ", b)
print("a+ b ... ", a+b)
# 
# strings -
#
# string escape characters -
#
# Escape Meaning
# \newline Escape (i.e., ignore) the newline
# \\ Backslash (\)
# \' Single quote (’)
# \" Double quote (")
# \a ASCII bell (BEL)
# \b ASCII backspace (BS)
# \f ASCII formfeed (FF)
# \n ASCII linefeed (LF)
# \N{name} Unicode character with the given name
# \ooo Character with the given octal value
# \r ASCII carriage return (CR)
# \t ASCII tab (TAB)
# \uhhhh Unicode character with the given 16-bit hexadecimal value
# \Uhhhhhhhh Unicode character with the given 32-bit hexadecimal value
# \v ASCII vertical tab (VT)
# \xhh Character with the given 8-bit hexadecimal value
#
#
#

exit(0);

