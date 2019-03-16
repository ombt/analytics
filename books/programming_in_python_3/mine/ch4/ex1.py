#!/usr/bin/python3
#
# if-statement syntax:
#
# if boolean_expression1:
#     suite1
# elif boolean_expression2:
#     suite2
# ...
# elif boolean_expressionN:
#     suiteN
# else:
#     else_suite
#
# another form:
#
# expression1 if boolean_expression else expression2
#
# example using while-else:
#
# def list_find(lst, target):
#     index = 0
#     while index < len(lst):
#         if lst[index] == target:
#             break
#         index += 1
#     else:
#         index = -1
# return index
#
# syntax for a for-loop:
#
# for expression in iterable:
#     for_suite
# else:
#     else_suite
#
#
# def list_find(lst, target):
#     for index, x in enumerate(lst):
#         if x == target:
#             break
#         else:
#             index = -1
# return index
#
# As this code snippet implies, the variables created in the for…in 
# loop’s expression continue to exist after the loop has terminated. 
# Like all local variables, they cease to exist at the end of their 
# enclosing scope
#
exit(0);

