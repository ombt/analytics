#!/usr/bin/python3
#
###################################################################3
#
# modules
#
import os
import sys
import getopt
import time
#
###################################################################3
#
# constants and globals
#
CMD_LINE_SHORT_OPTIONS = "hHmo:rs"
CMD_LINE_LONG_OPTIONS = [ "help", 
                          "hidden", 
                          "modified", 
                          "order=", 
                          "recursive", 
                          "sizes" ]
USAGE = """
    usage: {0} \\
        [-h |--help] \\
        [-H |--hidden] \\
        [-m |--modified] \\
        [-o [[n]ame, [m]odified, [s]size]] \\
        [--order=[[n]ame, [m]odified, [s]size]] \\
        [-r | --recursive] \\
        [-s | --sizes] \\
        [path [...]]
 
"""
#
###################################################################3
#
def usage():
    print(USAGE.format(sys.argv[0]))
#
def process_args(opts):
    #
    try:
        optlist, arglist = getopt.getopt(sys.argv[1:], 
                                         CMD_LINE_SHORT_OPTIONS,
                                         CMD_LINE_LONG_OPTIONS)
        for (opt,optval) in optlist:
            if opt in ("-h", "--help"):
                usage()
                sys.exit(2)
            elif opt in ("-H", "--hidden"):
                opts["hidden"] = True;
            elif opt in ("-m", "--modified"):
                opts["modified"] = True;
            elif opt in ("-o", "--order"):
                opts["order"] = optval
                if optval in ("name", 'n'):
                    opts["key"] = lambda x: x.split(" ")[0]
                elif optval in ("modified", 'm'):
                    opts["key"] = lambda x: float(x.split(" ")[0])
                    opts["modified"] = True;
                elif optval in ("size", 's'):
                    opts["key"] = lambda x: int(x.split(" ")[0])
                    opts["sizes"] = True
                else:
                    print("Invalid value '{0}' for order".format(optval))
                    usage()
                    exit(2)
            elif opt in ("-r", "--recursive"):
                opts["recursive"] = True
            elif opt in ("-s", "--sizes"):
                opts["sizes"] = True
            else:
                assert False, "Unknown option: {0}".format(opt)
        #
        if len(arglist) > 0:
            return arglist
        else:
            return [ "." ]
    except getopt.GetoptError as err:
        print(err)
        sys.exit(2)
#
def process_path(opts, path):
    #
    data_to_sort = []
    #
    if os.path.isdir(path):
        if opts["recursive"]:
            seen = set()
            #
            for (dpath, dnames, fnames) in os.walk(path):
                for dname in dnames:
                    if (dname.startswith(".") and (not opts["hidden"])):
                        continue    # skip hidden files
                    fullpath = os.path.join(dpath, dname)
                    if fullpath not in seen:
                        seen.add(fullpath)
                        mtime = None
                        mtime_date = None
                        if opts["modified"]:
                            mtime = os.path.getmtime(fullpath)
                            mtime_date = time.ctime(mtime)
                        sizes = None
                        if opts["sizes"]:
                            sizes = os.path.getsize(fullpath)
                        line = None
                        if not opts["order"]:
                            line = ("{0} {1} {2}/".format(mtime_date, 
                                                         sizes, 
                                                         fullpath))
                            print(line)
                        elif opts["order"] in ("n", "name"):
                            line = ("{0} {1} {2} {3}/".format(fullpath,
                                                             mtime_date, 
                                                             sizes, 
                                                             fullpath))
                            data_to_sort.append(line)
                        elif opts["order"] in ("s", "size"):
                            line = ("{0} {1} {2} {3}/".format(sizes,
                                                             mtime_date, 
                                                             sizes, 
                                                             fullpath))
                            data_to_sort.append(line)
                        elif opts["order"] in ("m", "modified"):
                            line = ("{0} {1} {2} {3}/".format(mtime,
                                                             mtime_date, 
                                                             sizes, 
                                                             fullpath))
                            data_to_sort.append(line)
                        else:
                            line = ("{0} {1} {2}/".format(mtime_date, 
                                                         sizes, 
                                                         fullpath))
                            print(line)
                for fname in fnames:
                    if (fname.startswith(".") and (not opts["hidden"])):
                        continue    # skip hidden files
                    fullpath = os.path.join(dpath, fname)
                    if fullpath not in seen:
                        seen.add(fullpath)
                        mtime = None
                        mtime_date = None
                        if opts["modified"]:
                            mtime = os.path.getmtime(fullpath)
                            mtime_date = time.ctime(mtime)
                        sizes = None
                        if opts["sizes"]:
                            sizes = os.path.getsize(fullpath)
                        line = None
                        if not opts["order"]:
                            line = ("{0} {1} {2}".format(mtime_date, 
                                                         sizes, 
                                                         fullpath))
                            print(line)
                        elif opts["order"] in ("n", "name"):
                            line = ("{0} {1} {2} {3}".format(fullpath,
                                                             mtime_date, 
                                                             sizes, 
                                                             fullpath))
                            data_to_sort.append(line)
                        elif opts["order"] in ("s", "size"):
                            line = ("{0} {1} {2} {3}".format(sizes,
                                                             mtime_date, 
                                                             sizes, 
                                                             fullpath))
                            data_to_sort.append(line)
                        elif opts["order"] in ("m", "modified"):
                            line = ("{0} {1} {2} {3}".format(mtime,
                                                             mtime_date, 
                                                             sizes, 
                                                             fullpath))
                            data_to_sort.append(line)
                        else:
                            line = ("{0} {1} {2}".format(mtime_date, 
                                                         sizes, 
                                                         fullpath))
                            print(line)
        else:
            for fname in os.listdir(path):
                if (fname.startswith(".") and (not opts["hidden"])):
                    continue    # skip hidden files
                fullpath = os.path.join(path, fname)
                mtime = None
                mtime_date = None
                if opts["modified"]:
                    mtime = os.path.getmtime(fullpath)
                    mtime_date = time.ctime(mtime)
                sizes = None
                if opts["sizes"]:
                    sizes = os.path.getsize(fullpath)
                line = None
                if os.path.isdir(fullpath):
                    if not opts["order"]:
                        line = ("{0} {1} {2}/".format(mtime_date, 
                                                     sizes, 
                                                     fullpath))
                        print(line)
                    elif opts["order"] in ("n", "name"):
                        line = ("{0} {1} {2} {3}/".format(fullpath,
                                                         mtime_date, 
                                                         sizes, 
                                                         fullpath))
                        data_to_sort.append(line)
                    elif opts["order"] in ("s", "size"):
                        line = ("{0} {1} {2} {3}/".format(sizes,
                                                         mtime_date, 
                                                         sizes, 
                                                         fullpath))
                        data_to_sort.append(line)
                    elif opts["order"] in ("m", "modified"):
                        line = ("{0} {1} {2} {3}/".format(mtime,
                                                         mtime_date, 
                                                         sizes, 
                                                         fullpath))
                        data_to_sort.append(line)
                    else:
                        line = ("{0} {1} {2}/".format(mtime_date, 
                                                     sizes, 
                                                     fullpath))
                        print(line)
                else:
                    if not opts["order"]:
                        line = ("{0} {1} {2}".format(mtime_date, 
                                                     sizes, 
                                                     fullpath))
                        print(line)
                    elif opts["order"] in ("n", "name"):
                        line = ("{0} {1} {2} {3}".format(fullpath,
                                                         mtime_date, 
                                                         sizes, 
                                                         fullpath))
                        data_to_sort.append(line)
                    elif opts["order"] in ("s", "size"):
                        line = ("{0} {1} {2} {3}".format(sizes,
                                                         mtime_date, 
                                                         sizes, 
                                                         fullpath))
                        data_to_sort.append(line)
                    elif opts["order"] in ("m", "modified"):
                        line = ("{0} {1} {2} {3}".format(mtime,
                                                         mtime_date, 
                                                         sizes, 
                                                         fullpath))
                        data_to_sort.append(line)
                    else:
                        line = ("{0} {1} {2}".format(mtime_date, 
                                                     sizes, 
                                                     fullpath))
                        print(line)
        if len(data_to_sort) > 0:
            data_to_sort.sort(key=opts["key"])
            for rec in data_to_sort:
                print(rec)
    else:
        print("{0}".format(path))
#
def main():
#
    opts = dict(hidden=False, 
                modified=False, 
                order=None, 
                key=None,
                recursive=False, 
                sizes=False )
    #
    arglist = process_args(opts)
    #
    for path in arglist:
        process_path(opts, path)
#
###################################################################
#
# start of program
#
if __name__ == "__main__":
    main()
#
sys.exit(0);

