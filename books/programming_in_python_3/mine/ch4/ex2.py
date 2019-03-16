#!/usr/bin/python3
#
# exceptios syntax:
#
# try:
#     try_suite
# except exception_group1 as variable1:
#     except_suite1
# …
# except exception_groupN as variableN:
#     except_suiteN
# else:
#     else_suite
# finally:
#     finally_suite
#
# example of finally-clause:
#
def read_data(filename):
    lines = []
    fh = None
    try:
        fh = open(filename, encoding="utf8")
        for line in fh:
            if line.strip():
                lines.append(line)
    except (IOError, OSError) as err:
        print(err)
        return []
    finally:
        if fh is not None:
        fh.close()
    return lines
#
# could also use the base class for IOError and OSError:
#
def read_data2(filename):
    lines = []
    fh = None
    try:
        fh = open(filename, encoding="utf8")
        for line in fh:
            if line.strip():
                lines.append(line)
    except EnvironmentError as err:
        print(err)
        return []
    finally:
        if fh is not None:
        fh.close()
    return lines
#
# raising exceptions
#
# raise exception(args)
# raise exception(args) from original_exception
# raise
#
# custom exceptions:
#
# class exceptionName(baseException): pass
#
# example for getting out of deeply nested loops:
#
# UGH WAY TO DO IT
#
# found = False
# for row, record in enumerate(table):
#     for column, field in enumerate(record):
#         for index, item in enumerate(field):
#             if item == target:
#                 found = True
#                 break
#         if found:
#             break
#     if found:
#         break
# if found:
#     print("found at ({0}, {1}, {2})".format(row, column, index))
# else:
#     print("not found")
#
# another way by using exceptions:
#
# class FoundException(Exception): pass
#
# try:
#     for row, record in enumerate(table):
#         for column, field in enumerate(record):
#             for index, item in enumerate(field):
#                 if item == target:
#                     raise FoundException()
# except FoundException:
#     print("found at ({0}, {1}, {2})".format(row, column, index))
# else:
#     print("not found")
#
#
exit(0);

