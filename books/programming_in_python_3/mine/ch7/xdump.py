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
CMD_LINE_SHORT_OPTIONS = "hb:de:"
CMD_LINE_LONG_OPTIONS = [ "help", 
                          "blocksize=", 
                          "decimal", 
                          "encoding=" ]
USAGE = """
    usage: {0} \\
        [-h |--help] \\
        [-b size | --b blocksize] \\
        [-d | --decimal] \\
        [-e encoding | --encoding encoding] \\
        file [file2 ...]
 
    where:
        blocksize is in [8-80] bits (default=16)
        encoding is in [ ascii, utf-8, .... utf-32] (default=utf-8)

"""
#
###################################################################3
#
def usage():
    print(USAGE.format(sys.argv[0]))
#
def process_args():
    #
    opts = dict(blocksize=16, 
                decimal=True, 
                encoding="utf-8" )
    #
    try:
        optlist, arglist = getopt.getopt(sys.argv[1:], 
                                         CMD_LINE_SHORT_OPTIONS,
                                         CMD_LINE_LONG_OPTIONS)
        for (opt,optval) in optlist:
            if opt in ("-h", "--help"):
                usage()
                sys.exit(2)
            elif opt in ("-b", "--blocksize"):
                opts["blocksize"] = optval
            elif opt in ("-d", "--decimal"):
                opts["decimal"] = True
            elif opt in ("-e", "--encoding"):
                opts["encoding"] = optval
            else:
                assert False, "Unknown option: {0}".format(opt)
        #
        if len(arglist) > 0:
            return (opts, arglist)
        else:
            print("No files given.")
            usage()
            sys.exit(2)
    except getopt.GetoptError as err:
        print(err)
        sys.exit(2)
#
def bytes_from_file(fpath, chunksize=8192):
    with open(fpath, "rb") as f:
        while True:
            chunk = f.read(chunksize)
            if chunk:
                yield chunk
            else:
                break;
#
def process_path(opts, fpath):
    #
    # check if it's plain file
    if os.path.isdir(fpath):
        print("Skipping directory: {0}".format(fpath))
        return
    else:
        print("Dump file: {0}".format(fpath))
    #
    # open file for read
    #
    offset = 0
    blocksize = opts["blocksize"]
    #
    for buffer in bytes_from_file(fpath, blocksize):
        print("{0} {1}".format(offset, buffer))
        offset += len(buffer)
#
def main():
#
    (opts, arglist) = process_args()
    #
    for fpath in arglist:
        process_path(opts, fpath)
#
###################################################################
#
# start of program
#
if __name__ == "__main__":
    main()
#
sys.exit(0);

