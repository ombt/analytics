#!/usr/bin/python3
#
# custom functions
#
# four kind of functions:
#
# global, local, lambda and methods 
#
# global function syntax:
#
# def functionName(parameters)
#     suite
#
# calculate the area of a triangle
#
import sys
import math
import string
#
def triangle_area(a, b, c):
    s = (a+b+c)/2
    return math.sqrt(s*(s-a)*(s-b)*(s-c))
#
# using default values for paramters:
#
def letter_count(text, letters=string.ascii_letters):
    letters = frozenset(letters)
    count = 0
    for char in text:
        if char in letters:
            count += 1
    return count
#
# example ...
#
def shorten(text, length=25, indicator="..."):
    if len(text) > length:
        text = text[:length-len(indicator)] + indicator
    return text
#
print(shorten("The Silkie"))
print(shorten(length=7, text="The Silkie"))
print(shorten("The Silkie", indicator='&', length=7))
print(shorten("The Silkie", 7, '&'))
#
# default parameters are created when function definition is seen, not
# when it is called.
#
def append_if_even(x, lst=[]): # WRONG!
    if x % 2 == 0:
        lst.append(x)
    return lst
#
# this is the correct way to get a new list when the list is not
# passed in.
#
def append_if_even(x, lst=None):
    if lst is None:
        lst = []
    if x % 2 == 0:
        lst.append(x)
    return lst
#
# use the above for these types: dictionaries, list, sets, and any
# other mutable data types when using defaults:
#
# short cut version of the above
#
def append_if_even(x, lst=None):
    lst = [] if lst is None else lst
    if x % 2 == 0:
        lst.append(x)
    return lst
#
# VARARGS for python:
#
def product(*args):
    result = 1
    for arg in args:
        result *= arg
    return result
#
print("product(1,...,5)) = ", product(1,2,3,4,5))
print("product(5,...,10)) = ", product(5,6,7,8,9,10))
#
def sum_of_powers(*args, power=1):
    result = 0
    for arg in args:
        result += arg ** power
    return result
#
print("sum_of_powers(1,...,5,power=2)) = ", 
      sum_of_powers(1,2,3,4,5,power=2))
print("sum_of_powers(1,...,5,power=3)) = ", 
      sum_of_powers(1,2,3,4,5,power=3))
#
nums = [ 1, 2, 3, 4, 5 ]
print("sum_of_powers(*nums,power=3)) = ", 
      sum_of_powers(*nums,power=3))
#
# key-word arguments
#
def add_person_details(ssn, surname, **kwargs):
    print("SSN =", ssn)
    print(" surname =", surname)
    for key in sorted(kwargs):
        print(" {0} = {1}".format(key, kwargs[key]))
#
add_person_details(83272171, "Luther", forename="Lexis", age=47)
#
sys.exit(0);
