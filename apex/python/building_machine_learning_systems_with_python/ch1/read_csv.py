#!/usr/bin/python3

import scipy as sp

data = sp.getfromtxt("data/web_traffic.tsv", delimiter="\t")

print(data[:10])

exit()
