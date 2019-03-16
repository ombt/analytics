#!/usr/bin/python3
#
# lambda parameters: expression
#
import collections as cols
#
elements = [(2, 12, "Mg"), (1, 11, "Na"), (1, 3, "Li"), (2, 4, "Be")]
#
print(elements.sort(key=lambda e: (e[1], e[2])))
print(elements.sort(key=lambda e: e[1:3]))
#
minus_one_dict = cols.defaultdict(lambda: -1)
point_zero_dict = cols.defaultdict(lambda: (0,0))
message_dict = cols.defaultdict(lambda: "No message available")
#
# assertions:
#
# assert boolean_expression, optional_expression
#
# two versions to check if zero was passed in
#
def product_1(*args): # pessimistic
    assert all(args), "0 argument"
    result = 1
    for arg in args:
        result *= arg
    return result
#
def product_2(*args): # optimistic
    result = 1
    for arg in args:
        result *= arg
    assert result, "0 argument"
    return result
#
exit(0)
