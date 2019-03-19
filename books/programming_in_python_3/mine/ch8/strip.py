
#
# how to define a functor in python. define __call__
#
class Strip:

    def __init__(self, characters):
        self.characters = characters

    def __call__(self, string):
        return "".join(c for c in string if c not in self.characters)
