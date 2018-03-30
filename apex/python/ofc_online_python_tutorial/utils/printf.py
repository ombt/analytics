#
# from:
# https://stackoverflow.com/questions/19457227/how-to-print-like-printf-in-python3
#

import sys

class Error(Exception):
    pass

class PrintfTypeError(Error):
    def __init__(self, err):
        self.message = str(err)

class PrintfValueError(Error):
    def __init__(self, err):
        self.message = str(err)

class PrintfOtherError(Error):
    def __init__(self, err):
        self.message = str(err)

def printf(format, *args):
    try:
        sys.stdout.write(format % args)
    except TypeError as err:
        # format string and values do not match ???
        raise PrintfTypeError(err)
    except ValueError as err:
        # format is unknown ???
        raise PrintfValueError(err)
    except Exception as err:
        # unknown type of error
        raise PrintfOtherError(err)

