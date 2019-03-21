#!/usr/bin/python
#
# general libs
#
import sys
#
# data analysis libs
#
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy
#
from collections import defaultdict, Counter
#
# path to book data
#
BD_PATH = "/home/ombt/sandbox/analytics/books/python_for_data_analysis/mine/pydata-book-1st-edition/"
#
import json
path = BD_PATH + 'ch02/usagov_bitly_data2012-03-16-1331923249.txt'
records = [json.loads(line) for line in open(path)]
# 
print(records[0]['tz'])
#
time_zones = [rec['tz'] for rec in records if 'tz' in rec]
print(time_zones[:10])
#
def get_counts(sequence):
    counts = {}
    for x in sequence:
        if x in counts:
            counts[x] += 1
        else:
            counts[x] = 1
    return counts
#
counts = get_counts(time_zones)
#
print("America/New_York ... {0}".format(counts['America/New_York']))
#
def get_counts2(sequence):
    counts = defaultdict(int)
    for x in sequence:
        counts[x] += 1
    return counts
#
counts2 = get_counts2(time_zones)
print("America/New_York ... {0}".format(counts2['America/New_York']))
#
print(len(time_zones))
#
def top_counts(count_dict,n=10):
    value_key_pairs = [(count, tz) for tz, count in count_dict.items()]
    value_key_pairs.sort()
    return value_key_pairs[-n:]
#
top_10_counts = top_counts(counts2)
print(top_10_counts)
#
counts = Counter(time_zones)
print(counts.most_common(10))
#
# on page 21
#
sys.exit(0)
