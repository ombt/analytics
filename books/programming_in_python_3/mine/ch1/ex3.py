#!/usr/bin/python3
#
# template for console programs and modules.
#
print("type integers, each followed by <enter>, or just <enter> to finish")
#
total = 0
count = 0
#
while True:
    line = input("Enter an integer: ")
    if line:
        try:
            number = int(line)
        except ValueError as err:
            print(err)
            continue
        total += number
        count += 1
    else:
        break
if count:
    print("count = ", count, ", total = ", total, ", mean = ", total/count)
#
exit(0);

