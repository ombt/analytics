#!/usr/bin/python3
#
# template for console programs and modules.
#
print("type integers, each followed by <enter>, or ^D or ^Z to finish")
#
total = 0
count = 0
#
while True:
    try:
        line = input()
        if line:
            number = int(line)
            total += number
            count += 1
    except ValueError as err:
        print(err)
        continue
    except EOFError:
        break
if count:
    print("count = ", count, ", total = ", total, ", mean = ", total/count)
#
exit(0);

