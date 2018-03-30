#!/usr/bin/python3

# Measure some strings:
words = ['cat', 'window', 'defenestrate']
print(words)

for w in words:
    print(w, len(w))

for w in words[:]:  # Loop over a slice copy of the entire list.
    if len(w) > 6:
        words.insert(0, w)
print(words)

for i in range(5):
    print(i)

print(range(5, 10))

print(range(0, 10, 3))

print(range(-10, -100, -30))

a = ['Mary', 'had', 'a', 'little', 'lamb']
print(a)

for i in range(len(a)):
    print(i, a[i])

print(range(10))

print(list(range(5)))

for n in range(2, 10):
    for x in range(2, n):
        if n % x == 0:
            print(n, 'equals', x, '*', n//x)
            break
    else:
        # loop fell through without finding a factor
        print(n, 'is a prime number')


for num in range(2, 10):
    if num % 2 == 0:
        print("Found an even number", num)
        continue
    print("Found a number", num)

# >>> while True:
# ...     pass  # Busy-wait for keyboard interrupt (Ctrl+C)

# The pass statement does nothing. It can be used when a statement is required syntactically but the program requires no action. For example:
# 
# >>>
# >>> while True:
# ...     pass  # Busy-wait for keyboard interrupt (Ctrl+C)
# ...
# This is commonly used for creating minimal classes:
# 
# >>>
# >>> class MyEmptyClass:
# ...     pass
# ...
# Another place pass can be used is as a place-holder for a function or conditional body when you are working on new code, allowing you to keep thinking at a more abstract level. The pass is silently ignored:
# 
# >>>
# >>> def initlog(*args):
# ...     pass   # Remember to implement this!
# ...

exit()
