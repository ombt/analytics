# #
# # exit() functions associated with objects, just like dtors.
# #
# Context managers allow us to simplify code by ensuring that certain opera-
# tions are performed before and after a particular block of code is executed. The
# behavior is achieved because context managers define two special methods,
# __enter__() and __exit__() , that Python treats specially in the scope of a with
# statement. When a context manager is created in a with statement its __en-
# ter__() method is automatically called, and when the context manager goes out
# of scope after its with statement its __exit__() method is automatically called.
# We can create our own custom context managers or use predefined ones—as
# we will see later in this subsection, the file objects returned by the built-in
# open() function are context managers. The syntax for using context managers
# is this:
# with expression as variable:
# suite
# The expression must be or must produce a context manager object; if the
# optional as variable part is specified, the variable is set to refer to the object
# returned by the context manager’s __enter__() method (and this is often the
# context manager itself). Because a context manager is guaranteed to execute
# its “exit” code (even in the face of exceptions), context managers can be used to
# eliminate the need for finally blocks in many situations.
# Some of Python’s types are context managers—for example, all the file objects
# that open() can return—so we can eliminate finally blocks when doing file
# handling as these equivalent code snippets illustrate (assuming that process()
# is a function defined elsewhere):
# 
# fh = None
# try:
# fh = open(filename)
# for line in fh:
# process(line)
# except EnvironmentError as err:
# print(err)
# finally:
# if fh is not None:
# fh.close()
# try:
# with open(filename) as fh:
# for line in fh:
# process(line)
# except EnvironmentError as err:
# print(err)
# 
# A file object is a context manager whose exit code always closes the file if it
# was opened. The exit code is executed whether or not an exception occurs, but
# in the latter case, the exception is propagated. This ensures that the file gets
# closed and we still get the chance to handle any errors, in this case by printing
# a message for the user.
# In fact, context managers don’t have to propagate exceptions, but not doing so
# effectively hides any exceptions, and this would almost certainly be a coding
# error. All the built-in and standard library context managers propagate ex-
# ceptions.
# Sometimes we need to use more than one context manager at the same time.
# For example:
# try:
# with open(source) as fin:
# with open(target, "w") as fout:
# for line in fin:
# fout.write(process(line))
# except EnvironmentError as err:
# print(err)
# Here we read lines from the source file and write processed versions of them to
# the target fil
# 
# Here we read lines from the source file and write processed versions of them to
# the target file.
# Using nested with statements can quickly lead to a lot of indentation. Fortu-
# nately, the standard library’s contextlib module provides some additional sup-
# port for context managers, including the contextlib.nested() function which
# allows two or more context managers to be handled in the same with statement
# rather than having to nest with statements. Here is a replacement for the code
# just shown, but omitting most of the lines that are identical to before:
# try:
# with contextlib.nested(open(source), open(target, "w")) as (
# fin, fout):
# for line in fin:Further Object-Oriented Programming
# 371
# It is only necessary to use contextlib.nested() for Python 3.0; from Python 3.1
# this function is deprecated because Python 3.1 can handle multiple context
# managers in a single with statement. Here is the same example—again
# omitting irrelevant lines—but this time for Python 3.1:
# 3.1
# try:
# with open(source) as fin, open(target, "w") as fout:
# for line in fin:
# Using this syntax keeps context managers and the variables they are associ-
# ated with together, making the with statement much more readable than if we
# were to nest them or to use contextlib.nested()
# 
# 
