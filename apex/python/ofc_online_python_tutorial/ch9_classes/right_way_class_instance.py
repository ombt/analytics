#!/usr/bin/python3

class Dog:

    def __init__(self, name):
        self.name = name
        self.tricks = [] # creates a new list for each dog

    def add_trick(self, trick):
        self.tricks.append(trick)

d = Dog('Fido')
e = Dog('Buddy')

d.add_trick('roll over')
print(d.tricks)

e.add_trick('play dead')
print(e.tricks)

exit()
