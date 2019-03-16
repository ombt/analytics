#!/usr/bin/python3
#
import sys
#
# packages
#
# A package is simply a directory that contains a set of modules and a file called __init__.py.
#
# Graphics/
#     __init__.py
#     Bmp.py
#     Jpeg.py
#     Png.py
#     Tiff.py
#     Xpm.py
#
#
# Here’s
# how we can import and use our module:
# import Graphics.Bmp
# image = Graphics.Bmp.load("bashful.bmp")
# For short programs some programmers prefer to use shorter names, and
# Python makes this possible using two slightly different approaches.
# import Graphics.Jpeg as Jpeg
# image = Jpeg.load("doc.jpeg")
# Here we have imported the Jpeg module from the Graphics package and told
# Python that we want to refer to it simply as Jpeg rather than using its fully
# qualified name, Graphics.Jpeg.
# from Graphics import Png
# image = Png.load("dopey.png")
# This code snippet imports the Png module directly from the Graphics package.
# This syntax (from …import) makes the Png module directly accessible.
# We are not obliged to use the original package names in our code. For example:
# from Graphics import Tiff as picture
# image = picture.load("grumpy.tiff")
# Here we are using the Tiff module, but have in effect renamed it inside our
# program as the picture module.
#
# In some situations it is convenient to load in all of a package’s modules using
# a single statement. To do this we must edit the package’s __init__.py file
# to contain a statement which specifies which modules we want loaded. This
# statement must assign a list of module names to the special variable __all__.
# For example, here is the necessary line for the Graphics/__init__.py file:
# __all__ = ["Bmp", "Jpeg", "Png", "Tiff", "Xpm"]
# 
# That is all that is required, although we are free to put any other code we like in
# the __init__.py file. Now we can write a different kind of import statement:
# from Graphics import *
# image = Xpm.load("sleepy.xpm")
# The from package import * syntax directly imports all the modules named in the
# __all__ list. So, after this import, not only is the Xpm module directly accessible,
# but so are all the others.
#
######################################################################
#
# custom imports
#
######################################################################
#
# std lib:
#
# string
#
# io.StringIO:
#
# We can access io.StringIO if we do import io, and we can use it to capture output
# destined for a file object such as sys.stdout:
# sys.stdout = io.StringIO()
# If this line is put at the beginning of a program, after the imports but before
# any use is made of sys.stdout, any text that is sent to sys.stdout will actually
# be sent to the io.StringIO file-like object which this line has created and which
# has replaced the standard sys.stdout file object. Now, when the print() and
# sys.stdout.write() lines shown earlier are executed, their output will go to
# the io.StringIO object instead of the console. (At any time we can restore the
# original sys.stdout with the statement sys.stdout = sys.__stdout__.)
# 
#
# optparse Module
# 
# def main():
#     parser = optparse.OptionParser()
#     parser.add_option("-w", "--maxwidth", dest="maxwidth", type="int",
#          help=("the maximum number of characters that can be "
#               "output to string fields [default: %default]"))
#     parser.add_option("-f", "--format", dest="format",
#          help=("the format used for outputting numbers "
#               "[default: %default]"))
#     parser.set_defaults(maxwidth=100, format=".0f")
#                         opts, args = parser.parse_args()
#
# Only nine lines of code are needed, plus the import optparse statement.
#
# decimal module;
#
# provides: decimal.Decimal, fractions.Decimal
#
# very importan modules are:
#
# NumPy and SciPy
#
# for dates use"
#
# calendar and datetime modules
#
import calendar, datetime, time
#
moon_datetime_a = datetime.datetime(1969, 7, 20, 20, 17, 40)
#
moon_time = calendar.timegm(moon_datetime_a.utctimetuple())
#
moon_datetime_b = datetime.datetime.utcfromtimestamp(moon_time)
#
moon_datetime_a.isoformat() # returns: '1969-07-20T20:17:40'
#
moon_datetime_b.isoformat() # returns: '1969-07-20T20:17:40'
#
time.strftime("%Y-%m-%dT%H:%M:%S", time.gmtime(moon_time))
#
# algorithms and collecion data types
#
import heapq
heap = []
heapq.heappush(heap, (5, "rest"))
heapq.heappush(heap, (2, "work"))
heapq.heappush(heap, (4, "study"))
#
for x in heapq.merge([1, 3, 5, 8], [2, 4, 7], [0, 1, 6, 8, 9]):
    print(x, end=" ")
print()
#
# modules for file formats, encodings, and data persistence
#
# modules for file, directory and proecss handling.
#
# os module has:
#
# os.environ
# os.getwd(0
# os.chdir()
# os.access()
# os.listdir()
# os.stat()
# os.mkdir()
# os.rmdir()
# os.removedirs()
# os.rename()
# os.remove()
#
# os.path.abspath()
# os.path.split()
# os.path.basename()
# os.path.dirname()
# os.path.splitext()
#
# os.path.exists()
# os.path.getsize()
# os.path.isdir()
# os.path.join()
#
#
# 
# Here is a code snippet taken from the finddup.py program.★ The code creates a
dictionary where each key is a 2-tuple (file size, filename) where the filename
# excludes the path, and where each value is a list of the full filenames that
# match their key’s filename and have the same file size:
# data = collections.defaultdict(list)
# for root, dirs, files in os.walk(path):
# for filename in files:
# fullname = os.path.join(root, filename)
# key = (os.path.getsize(fullname), filename)
# data[key].append(fullname)
#
# network and internet programming
#
# XML - SAX and DOM are provided.
#
# threading module, queue module provides thread-safe queues.
#


sys.exit(0);

