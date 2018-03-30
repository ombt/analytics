#!/usr/bin/python3

# lists as queues is very inefficient since when
# an item is removed, then all the other items have
# to be moved down one.
#
# use this instead
#

from collections import deque

queue = deque(["Eric", "John", "Michael"])
print(queue)

queue.append("Terry")
print(queue)

queue.append("Graham")
print(queue)

print(queue.popleft())
print(queue)

queue.popleft()
print(queue)

exit()
