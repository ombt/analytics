#!/usr/bin/python3
#
import sys
#
delimiter = ","
#
def usage():
    print(sys.argv[0],"[-?] [-d delimiter]")
#
def get_opts():
    #
    global delimiter
    #
    # check if any arguments were given.
    #
    if len(sys.argv) == 1:
        print("Using default values:")
        print("default delimiter = ", delimiter)
    else:
        iarg = 1
        iargmax = len(sys.argv)
        #
        while iarg<iargmax:
            arg = sys.argv[iarg]
            if arg == "-d":
                iarg += 1
                delimiter = sys.argv[iarg]
            elif arg == "-?":
                usage()
                exit(2)
            iarg += 1
        #
        print("delimiter = ", delimiter)
#
def tokenize(line):
    #
    token = ""
    tokens = []
    in_string = False
    #
    for c in line:
        if in_string == True:
            if c in """"'""":
                in_string = False
            else:
                token += c
        elif c in """"'""":
            in_string = True
        elif c == delimiter:
            tokens.append(token.strip())
            token = ""
        else:
            token += c
    #
    if len(token) > 0:
        tokens.append(token.strip())
        token = ""
    else:
        token = ""
        tokens.append(token.strip())
    #
    return tokens
#
def print_start_table():
    print("<table>")

def print_header(header):
    print("<tr>")
    #
    header_record = ""
    for col in header:
        header_record.format("<td>{0}</td>".format(col))
    print(header_record)
    print("</tr>")

def print_data(table):
    for row in table:
        print("<tr>")
        for col in row:
            print("<td>{0}</td>".format(col))
        print("</tr>")

def print_end_table():
    print("</table>")

def print_html(header, data):
    #
    print_start_table()
    print_header(header)
    print_data(data)
    print_end_table()
    
def main():
    #
    # get command line options, if any.
    #
    get_opts()
    #
    # start reading lines from stdin
    #
    record = 0
    header = [ ]
    data = [ ]
    #
    while True:
        #
        # read next line from stdin
        #
        try:
            line=input()
            record += 1;
            print("line ... ", line)
        except EOFError:
            break
        #
        if record == 1:
            header = tokenize(line)
        else:
            data.append(tokenize(line))
    #
    print_html(header, data)
#
# start of program
#
main()
#
exit(0);

