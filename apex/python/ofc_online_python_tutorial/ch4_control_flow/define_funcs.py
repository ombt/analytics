#!/usr/bin/python3

def fib(n):    # write Fibonacci series up to n
    """Print a Fibonacci series up to n."""
    a, b = 0, 1
    while a < n:
        print(a, end=' ')
        a, b = b, a+b
    print()

# Now call the function we just defined:
fib(2000)

print(fib)

f = fib

print(f)

f(100)

fib(0)

print(fib(0))

def fib2(n):  # return Fibonacci series up to n
    """Return a list containing the Fibonacci series up to n."""
    result = []
    a, b = 0, 1
    while a < n:
        result.append(a)    # see below
        a, b = b, a+b
    return result

f100 = fib2(100)    # call it
print(f100)         # write the result

def parrot(voltage, 
           state='a stiff', 
           action='voom', 
           type='Norwegian Blue'):
    print("-- This parrot wouldn't", action, end=' ')
    print("if you put", voltage, "volts through it.")
    print("-- Lovely plumage, the", type)
    print("-- It's", state, "!")

parrot(1000) # 1 positional argument

parrot(voltage=1000)     # 1 keyword argument

parrot(voltage=1000000, 
       action='VOOOOOM') # 2 keyword arguments

parrot(action='VOOOOOM', 
       voltage=1000000)  # 2 keyword arguments

parrot('a million', 
       'bereft of life', 
       'jump')          # 3 positional arguments

parrot('a thousand', 
       state='pushing up the daisies')  # 1 positional, 1 keyword

# but all the following calls would be invalid:

# parrot()                     # required argument missing
# parrot(voltage=5.0, 'dead')  # non-keyword argument after a keyword argument
# parrot(110, voltage=220)     # duplicate value for the same argument
# parrot(actor='John Cleese')  # unknown keyword argument

# >>> def function(a):
# ...     pass
# ...
# >>> function(0, a=0)
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
# TypeError: function() got multiple values for keyword argument 'a'

def cheeseshop(kind, *arguments, **keywords):
    print("-- Do you have any", kind, "?")
    print("-- I'm sorry, we're all out of", kind)
    for arg in arguments:
        print(arg)
    print("-" * 40)
    for kw in keywords:
        print(kw, ":", keywords[kw])

cheeseshop("Limburger", "It's very runny, sir.",
           "It's really very, VERY runny, sir.",
           shopkeeper="Michael Palin",
           client="John Cleese",
           sketch="Cheese Shop Sketch")

# def write_multiple_items(file, separator, *args):
#     file.write(separator.join(args))

def concat(*args, sep="/"):
    return sep.join(args)

print(concat("earth", "mars", "venus"))

print(concat("earth", "mars", "venus", sep="."))

print(list(range(3, 6))) # normal call with separate arguments

args = [3, 6]
print(args)

print(range(*args))

print(list(range(*args)))

def parrot(voltage, state='a stiff', action='voom'):
    print("-- This parrot wouldn't", action, end=' ')
    print("if you put", voltage, "volts through it.", end=' ')
    print("E's", state, "!")

d = { "voltage": "four million", 
      "state": "bleedin' demised", 
       "action": "VOOM" }

print(d)

parrot(**d)

def make_incrementor(n):
    return lambda x: x + n

f = make_incrementor(42)

print(f(0))
print(f(1))

pairs = [(1, 'one'), (2, 'two'), (3, 'three'), (4, 'four')]
print(pairs)

pairs.sort(key=lambda pair: pair[1])
print(pairs)

exit()
