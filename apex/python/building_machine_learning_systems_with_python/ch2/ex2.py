#!/usr/bin/python3

from matplotlib import pyplot as plt

from sklearn.datasets import load_iris

import numpy as np

# We load the data with load_iris from sklearn
data = load_iris()

features = data['data']
feature_names = data['feature_names']
target = data['target']

for t,marker,c in zip(range(3),">ox","rgb"):
    # We plot each class on its own to get different colored markers
    plt.scatter(features[target == t,0],
                features[target == t,1],
                marker=marker,
                c=c)

exit()
