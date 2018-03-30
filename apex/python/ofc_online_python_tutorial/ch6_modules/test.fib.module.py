#!/usr/bin/python3

import fib_module as fibo

fibo.fib(1000)

print(fibo.fib2(100))

print(fibo.__name__)

fib = fibo.fib
fib(500)

exit()
