#!/usr/bin/python3

import os
print(os.getcwd())      # Return the current working directory

# os.chdir('/server/accesslogs')   # Change current working directory

# os.system('mkdir today')

print(dir(os))
# <returns a list of all module functions>

# import shutil
# shutil.copyfile('data.db', 'archive.db')
# shutil.move('/build/executables', 'installdir')

help(os)
# <returns an extensive manual page created from the module's docstrings>



exit()
