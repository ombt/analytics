#!/usr/bin/python3
#
import sys
#
space = [ " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " " ]
zero = [ "  000  ",
         " 0   0 ",
         "0     0",
         "0     0",
         "0     0",
         " 0   0 ",
         "  000  " ]
one = [ " 1 ",
        "11 ",
        " 1 ",
        " 1 ",
        " 1 ",
        " 1 ",
        "111" ]
two = [ " 222 ",
        "2   2",
        "2  2 ",
        "  2  ",
        " 2   ",
        "2    ",
        "22222" ]
three = [ " 333 ",
          "3   3",
          "    3",
          " 333 ",
          "    3",
          "3   3",
          " 333 " ]
four = [ "   4 ",
         "  44 ",
         " 4 4 ",
         "4  4 ",
         "44444",
         "   4 ",
         "   4 " ]
five = [ "5555 ",
         "5    ",
         "5    ",
         " 555 ",
         "    5",
         "5   5",
         " 555 " ]
six = [ "  6  ",
        " 6   ",
        "6    ",
        "6666 ",
        "6   6",
        "6   6",
        " 666 " ]
seven = [ "77777",
          "    7",
          "   7 ",
          "  7  ",
          " 7   ",
          "7    ",
          "7    " ]
eight = [ " 888 ",
          "8   8",
          "8   8",
          " 888 ",
          "8   8",
          "8   8",
          " 888 " ]
nine = [ " 999 ",
         "9   9",
         "9   9",
         " 9999",
         "    9",
         "   9 ",
         "  9  " ]
#
numbers = [ zero, one, two, three, four, five, six, seven, eight, nine ]
#
for numeral in sys.argv:
    for row in [ 0, 1, 2, 3, 4, 5, 6 ]:
        for number in numeral:
            try:
                inum = int(number)
            except ValueError:
                continue
            print(numbers[inum][row], space[row], sep='', end='')
        print()
    print()
#
exit(0);

