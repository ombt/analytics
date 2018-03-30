#!/usr/bin/python3

squares = []

for x in range(10):
    squares.append(x**2)

print(squares)

squares = list(map(lambda x: x**2, range(10)))
print(squares)

squares = [x**2 for x in range(10)]
print(squares)

diff = [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y]
print(diff)

combs = []
for x in [1,2,3]:
    for y in [3,1,4]:
        if x != y:
            combs.append((x, y))

print(combs)

vec = [-4, -2, 0, 2, 4]
print(vec)

# create a new list with the values doubled
print([x*2 for x in vec])

# filter the list to exclude negative numbers
print([x for x in vec if x >= 0])

# apply a function to all the elements
print([abs(x) for x in vec])

# call a method on each element
freshfruit = ['  banana', '  loganberry ', 'passion fruit  ']
print([weapon.strip() for weapon in freshfruit])

# create a list of 2-tuples like (number, square)
print([(x, x**2) for x in range(6)])

# the tuple must be parenthesized, otherwise an error is raised
# [x, x**2 for x in range(6)]
#   File "<stdin>", line 1, in <module>
#    [x, x**2 for x in range(6)]

# flatten a list using a listcomp with two 'for'
vec = [[1,2,3], [4,5,6], [7,8,9]]
print(vec)

print([num for elem in vec for num in elem])

matrix = [ [1, 2, 3, 4],
           [5, 6, 7, 8],
           [9, 10, 11, 12] ]

print([[row[i] for row in matrix] for i in range(4)])

transposed = []
for i in range(4):
    transposed.append([row[i] for row in matrix])
print(transposed)

transposed = []
for i in range(4):
    # the following 3 lines implement the nested listcomp
    transposed_row = []
    for row in matrix:
        transposed_row.append(row[i])
        transposed.append(transposed_row)

print(transposed)

print(list(zip(*matrix)))

exit()

