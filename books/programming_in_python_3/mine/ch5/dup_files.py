#!/usr/bin/python3
#
import sys
import os
import collections
#
data = collections.defaultdict(list)
#
for path in sys.argv[1:]:
    print("Path is {0}".format(path))
    for root, dirs, files in os.walk(path):
        print("\tRoot is {0}".format(root))
        print("\tDirs is {0}".format(dirs))
        print("\tFiles is {0}".format(files))
        for filename in files:
            fullname = os.path.join(root, filename)
            key = (os.path.getsize(fullname), filename)
            data[key].append(fullname)
    #
    for size, filename in sorted(data):
        names = data[(size, filename)]
        if len(names) > 1:
            print("{filename} ({size} bytes) may be duplicated "
                  "({0} files):".format(len(names), **locals()))
            for name in names:
                print("\t{0}".format(name))
#
sys.exit(0);

