#!/usr/bin/python3
#
# template for console programs and modules.
#
# what is false in an if-statement
#
# A Boolean expression is anything that can be evaluated to produce 
# a Boolean value (True or False). In Python, such an expression evaluates 
# to False if it is the predefined constant False, the special object 
# None, an empty sequence or collection (e.g., an empty string, list, 
# or tuple), or a numeric data item of value 0; anything else is considered 
# to be True. When we create our own custom data types (e.g., in 
# Chapter 6), we can decide for ourselves what they should return 
# in a Boolean context
#
# if bool expr1:
#     suite1
# elif bool expr2:
#     suite2
# ...
# elif bool exprN:
#     suiteN
# else:
#     else-suite
#
lines = 1100
if lines < 1000:
    print("small")
elif lines < 10000:
    print("medium")
else:
    print("large")
#
# while loop syntax:
#
# while bool_expr:
#     suite
#
# while-loops also support "continue" and "break"
#
x = 1;
while x<10:
    print("x is ...", x)
    x = x + 1
#
x = 1;
while x<10:
    print("top: x is ...", x)
    if x<8:
        x = x + 1
    elif x==8:
        print("x==8, using continue ...")
        x = x + 1
        continue;
    else:
        print("break!")
        break
    print("bottom: x is ...", x)
print("after while-loop")
#
# for ... in loops syntax
#
# for variable in iterable:
#     suite
#
countries = [ "denmark", "finland", "norway", "sweden" ]
for country in countries:
    print("country is ...", country)
#
letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
for letter in letters:
    if letter in "AEIOU":
        print(letter,"is a vowel")
    else:
        print(letter,"is a consonant")
#
# simplified exception syntax:
#
# try:
#     try suite
# except exception1 as variable1:
#     exception_suite1
# ...
# except exceptionN as variable1:
#     exception_suiteN
#
s = input("enter an integer" )
try:
    i = int(s)
    print("valid integer entered: ", i)
except ValueError as err:
    print(err)
#
a = 1
b = 2
#
print("a+b", a + b)
print("a-b", a - b)
a -= b
print("a-=b", a)
#
a = [ "a", "b", "c" ]
print("a is ...", a)
a += [ "dddd" ]
print('a += [ "dddd" ]', a)
#
exit(0);

