#!/usr/bin/python3
#
# read a list of files and calculate some basic stats.
#
import sys as os
import collections as cols
#
# data types
#
Data = cols.namedtuple("Data", "recno value")
Stats = cols.namedtuple("Stats", "minval maxval num mean mode")
#
def usage():
    print("usage: {0} file [...]".format(os.argv[0]))
#
def read_data(fpath, raw):
    #
    print("\nReading file: {0}".format(fpath))
    #
    for lnno, val in enumerate(open(fpath), start=1):
        try:
            val = int(val.rstrip())
            raw.append(Data(recno=lnno, value=val))
        except ValueError:
            continue
    #
    print("Read in {0} records.".format(len(raw)))
    #
    return True
#
def process_data(fpath, raw, proc):
    #
    print("Processing file: {0}".format(fpath))
    #
    min_val = raw[0].value
    max_val = raw[0].value
    #
    total = 0.0
    nvalues = 0
    #
    values = []
    #
    for data in raw[1:]:
        if data.value < min_val:
            min_val = data.value
        if data.value > max_val:
            max_val = data.value
        total += data.value
        nvalues += 1
        #val_cnts[data.value] = val_cnts.get(data.value, 0) + 1
        values.append(data.value)
    #
    average = total/nvalues
    #
    counts = {k:values.count(k) for k in set(values)}
    modes = sorted( dict( filter( lambda x: x[1] == max(counts.values()), counts.items())).keys())
    mode = modes[-1]
    #
    proc.append(Stats(min_val, max_val, nvalues, average, mode))
    #
    return True
#
def print_stats(fpath, proc):
    #
    print("Printing data for file: {0}".format(fpath))
    #
    print("Minimum Value: {0}\n"
          "Maxium Value : {1}\n"
          "Records      : {2}\n"
          "Average      : {3}\n"
          "Mode         : {4}".format(proc[0].minval,
                                      proc[0].maxval,
                                      proc[0].num,
                                      proc[0].mean,
                                      proc[0].mode))
    return
#
def main():
    #
    if len(os.argv) < 2:
        usage()
        os.exit(-1)
    # 
    for fpath in os.argv[1:]:
        #
        raw = list()
        proc = list()
        #
        if not read_data(fpath, raw):
            print("read_data failed for {0}".format(fpath))
            return
        elif not process_data(fpath, raw, proc):
            print("process_data failed for {0}".format(fpath))
            return
        else:
            print_stats(fpath, proc)
#
# start of programs
#
main()
#
os.exit(0);

