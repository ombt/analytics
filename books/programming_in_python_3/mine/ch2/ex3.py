#!/usr/bin/python3
#
import sys
import math
#
s = "abafghkielmnbi"
print("s = ", s)
#
c = input("enter a latter: ")
#
if (c in s):
    print(c, "is in", s)
else:
    print(c, "is NOT in", s)
#
s2 = "xyz"
print("s2 = ", s2)
print("s + s2 = ", s+s2)
s += s2
print("s += s2 = ", s)
s2 *= 5
print("s2*=5 ", s2)
#
books = [ "arithmetica", "conics", "elements" ]
print("books ... ", "".join(books))
print("books ... ", " ".join(books))
print("books ... ", ";".join(books))
print("books ... ", "-<>-".join(books))
#
#
# Syntax Description
# s.capitalize() Returns a copy of str s with the first letter capitalized;
# see also the str.title() method
# s.center(width,
# char)
# Returns a copy of s centered in a string of length width
# padded with spaces or optionally with char (a string of
# length 1); see str.ljust(), str.rjust(), and str.format()
# s.count(t,
# start, end)
# Returns the number of occurrences of str t in str s (or in
# the start:end slice of s)
# s.encode(
# encoding,
# err)
# Returns a bytes object bytes
# type
# ➤293
# Character
# encodings
# ➤91
# that represents the string using
# the default encoding or using the specified encoding and
# handling errors according to the optional err argument
# s.endswith(x,
# start, end)
# Returns True if s (or the start:end slice of s) ends with str
# x or with any of the strings in tuple x; otherwise, returns
# False. See also str.startswith().
# s.expandtabs(
# size)
# Returns a copy of s with tabs replaced with spaces in
# multiples of 8 or of size if specified
# s.find(t,
# start, end)
# Returns the leftmost position of t in s (or in the start:end
# slice of s) or -1 if not found. Use str.rfind() to find the
# rightmost position. See also str.index().
# s.format(...) Returns a copy of s str.
# format()
# ➤78
# formatted according to the given
# arguments. This method and its arguments are covered
# in the next subsection.
# s.index(t,
# start, end)
# Returns the leftmost position of t in s (or in the
# start:end slice of s) or raises ValueError if not found. Use
# str.rindex() to search from the right. See str.find().
# s.isalnum() Returns True if s is nonempty and every character in s
# is alphanumeric
# s.isalpha() Returns True if s is nonempty and every character in s
# is alphabetic
# s.isdecimal() Returns True if s is nonempty and every character in s is
# a Unicode base 10 digit
# s.isdigit() Returns True if s is nonempty and every character in s is
# an ASCII digit
# Identi- s.isidentifier() Returns True if s is nonempty and is
# fiers
# and
# keywords
# 51 ➤
# a valid identifier
# s.islower() Returns True if s has at least one lowercaseable character
# and all its lowercaseable characters are lowercase;
# see also str.isupper()
# s.isnumeric() Returns True if s is nonempty and every character in s is
# a numeric Unicode character such as a digit or fraction
# s.isprintable() Returns True if s is empty or if every character in s is considered
# to be printable, including space, but not newline
# s.isspace() Returns True if s is nonempty and every character in s is
# a whitespace character
# s.istitle() Returns True if s is a nonempty title-cased string; see
# also str.title()
# s.isupper() Returns True if str s has at least one uppercaseable character
# and all its uppercaseable characters are uppercase;
# see also str.islower()
# s.join(seq) Returns the concatenation of every item in the sequence
# seq, with str s (which may be empty) between each one
# s.ljust(
# width,
# char)
# Returns a copy of s left-aligned in a string of length width
# padded with spaces or optionally with char (a string of
# length 1). Use str.rjust() to right-align and str.center()
# to center. See also str.format().
# s.lower() Returns a lowercased copy of s; see also str.upper()
# s.maketrans() Companion of str.translate(); see text for details
# s.partition(
# t)
# Returns a tuple of three strings—the part of str s before
# the leftmost str t, t, and the part of s after t; or if t isn’t in
# s returns s and two empty strings. Use str.rpartition()
# to partition on the rightmost occurrence of t.
# s.replace(t,
# u, n)
# Returns a copy of s with every (or a maximum of n if
# given) occurrences of str t replaced with str u
# s.split(t, n) Returns a list of strings splitting at most n times on str t;
# if n isn’t given, splits as many times as possible; if t isn’t
# given, splits on whitespace. Use str.rsplit() to split from
# the right—this makes a difference only if n is given and is
# less than the maximum number of splits possible.
# s.splitlines(
# f)
# Returns the list of lines produced by splitting s on line
# terminators, stripping the terminators unless f is True
# s.startswith(
# x, start,
# end)
# Returns True if s (or the start:end slice of s) starts with
# str x or with any of the strings in tuple x; otherwise,
# returns False. See also str.endswith().
#
trump = "trump*is*a*huevon"
print(trump.split("*"))
#
# string formatting
#
print("The novel '{0}' was published in {1}".format("Hard Times", 1854))
print("{{{0}}} {1} ;-}}".format("I'm in braces", "I'm not"))
print("{0}{1}".format("The amount due is $", 200))
#
# at page 80 Field Names
#
# keyword arguments
#
format1 = "{who} turned {age} this year"
for (name,age) in [ ["anne", 10], ["cow", 20] ] :
    print(format1.format(who=name, age=age))
#
format2 = "{0[0]} turned {0[1]} this year"
for data in [ ["anne", 10], ["cow", 20] ] :
    print(format2.format(data))
#
format3 = "{0[name]} turned {0[age]} this year"
for data in [ dict(name="anne", age=10), dict(name="cow", age=20) ] :
    print(format3.format(data))
#
format4 = "PI={0.pi}"
print(format4.format(math))
#
# format specifications
#
# : file align sign # 0 width , . precision type
#
# string formats
#
s = "The sword of truth"
format1 = "<{0}>"
print(format1.format(s)) # default
#
print("<{0:25}>".format(s)) # minimum width 25
print("<{0:>25}>".format(s)) # right align, minimum width 25
print("<{0:^25}>".format(s)) # center align, minimum width 25
print("<{0:-^25}>".format(s)) # - fill, center align, minimum width 25
print("<{0:.<25}>".format(s)) # . fill, left align, minimum width 25
print("<{0:.10}>".format(s)) # maximum width 10
#
maxwidth = 12
print("{0}".format(s[:maxwidth]))
print("{0:.{1}}".format(s, maxwidth))
#
# formatting for numbers
#
print("{0:0=12}".format(8749203)) # 0 fill, minimum width 12
print("{0:0=12}".format(-8749203)) # 0 fill, minimum width 12
print("{0:012}".format(8749203)) # 0-pad and minimum width 12
print("{0:012}".format(-8749203)) # 0-pad and minimum width 12
print("{0:*<15}".format(18340427)) # * fill, left align, min width 15
print("{0:*>15}".format(18340427)) # * fill, right align, min width 15
print("{0:*^15}".format(18340427)) # * fill, center align, min width 15
print("{0:*^15}".format(-18340427)) # * fill, center align, min width 15
print("[{0: }] [{1: }]".format(539802, -539802)) # space or - sign
print("[{0:+}] [{1:+}]".format(539802, -539802)) # force sign
print("[{0:-}] [{1:-}]".format(539802, -539802)) # - sign if needed
#
# base formats
#
print("{0:b} {0:o} {0:x} {0:X}".format(14613198))
print("{0:#b} {0:#o} {0:#x} {0:#X}".format(14613198))

#
# csv2html.py exercise - page 105
#
exit(0);

