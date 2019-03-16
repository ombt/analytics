#!/usr/bin/python3
#
import string
import sys
#
words = {}
#
strip = string.whitespace + string.punctuation + string.digits + "\"'"
#
for filename in sys.argv[1:]:
    for line in open(filename):
        for word in line.lower().split():
            word = word.strip(strip)
            if len(word) > 2:
                words[word] = words.get(word, 0) + 1
#
for word in sorted(words):
    print("'{0}' occurs {1} times".format(word, words[word]))
#
# checking if a hash entry already exists. if not, then return
# default value.
#
# words[word] = words.get(word, 0) + 1
#
# the same as below ...
#
# if word not in words:
#     words[word] = 0
# words[word] += 1
#
exit(0);

