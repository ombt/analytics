#!/usr/bin/python3
#
#
import sys
#
# import syntax:
#
# import importable
# import importable1, importable2, ..., importableN
# import importable as preferred_name
#
# other import syntaxes:
#
# from importable import object as preferred_name
# from importable import object1, object2, ..., objectN
# from importable import (object1, object2, object3, object4, object5,
# object6, ..., objectN)
# from importable import *
#
#
# In the last syntax, the * means “import everything that is not private”,which in
# practical termsmeans either that every object in the module is imported except
# for those whose names begin with a leading 
# underscore, or, if the module has
a global __all__ variable that holds a list of names, that all the objects named
# in the __all__ variable are imported.
#
# import os
# print(os.path.basename(filename)) # safe fully qualified access
#
# import os.path as path
# print(path.basename(filename)) # risk of name collision with path
#
# from os import path
# print(path.basename(filename)) # risk of name collision with path
#
# from os.path import basename
# print(basename(filename)) # risk of name collision with basename
#
# from os.path import *
# print(basename(filename)) # risk of many name collisions
#
# A question that naturally arises is, how does Python know where to look for
# the modules and packages that are imported? The built-in sys module has a
# list called sys.path that holds a list of the directories that constitute the Python
# path. The first directory is the directory that contains the program itself, even
# if the program was invoked from another directory. If the PYTHONPATH environment
# variable is set, the paths specified in it are the next ones in the list, and
# the final paths are those needed to access Python’s standard library—these are
# set when Python is installed.
#

#
sys.exit(0);

