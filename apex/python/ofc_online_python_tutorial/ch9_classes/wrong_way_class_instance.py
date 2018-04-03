#!/usr/bin/python3

class Dog:

    tricks = []             # mistaken use of a class variable

    def __init__(self, name):
        self.name = name

    def add_trick(self, trick):
        self.tricks.append(trick)

d = Dog('Fido')
e = Dog('Buddy')

d.add_trick('roll over')
print(d.tricks) # unexpectedly shared by all dogs

e.add_trick('play dead')
print(e.tricks) # unexpectedly shared by all dogs

exit()
