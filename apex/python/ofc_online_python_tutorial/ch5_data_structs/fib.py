#!/usr/bin/python3

def fib(n):
    result = []
    a,b = 0,1

    while a<n:
        result.append(a)
        a,b = b,a+b
    return result

fib100 = fib(100)

print(*fib100)
print()

exit()
