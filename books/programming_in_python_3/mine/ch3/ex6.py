#!/usr/bin/python3
#
import os
import collections
#
greens = dict(green="#0080000", olive="#808000", lime="#00FF00")
print("{green} {lime}".format(**greens))
#
# dictionary comprehension -
#
# {keyexpression: valueexpression for key, value in iterable}
# {keyexpression: valueexpression for key, value in iterable if condition}
#
file_sizes = {name: os.path.getsize(name) for name in os.listdir(".") if os.path.isfile(name)}
#
print("file_sizes = ", file_sizes)
#
# default dictionary - allows the creation of hashtable entries which
# do not exist.
#
# old way:
#
# words = {}
# words[word] = words.get(word, 0) + 1
#
# new way with default ctor():
#
# words = collections.defaultdict(int)
# words[word] += 1
#
# ordered dictionaries -
#
d = collections.OrderedDict([('z', -4), ('e', 19), ('k', 7)])
print("ordered dict d is ... ", d);
#
tasks = collections.OrderedDict()
tasks[8031] = "Backup"
tasks[4027] = "Scan Email"
tasks[5733] = "Build System"
print("ordered dict tasks is ... ", tasks);
#
# this dictionary does NOT maintain sorting order of you
# have new inserts.
#
exit(0);

