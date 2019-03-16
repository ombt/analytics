#!/usr/bin/python3
#
##########################################################################
#
# create a template HTML file.
#
##########################################################################
#
# modules
#
import sys
import datetime
import xml.sax.saxutils
#
##########################################################################
#
# constants (sort of)
#
COPYRIGHT_TEMPLATE = "Copyright (c) {0} {1}. All rights reserved."
#
STYLESHEET_TEMPLATE = ('<link rel="stylesheet" type="text/css" '
                       'media="all" href="{0}" />\n')
#
HTML_TEMPLATE = """<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" \
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<title>{title}</title>
<!-- {copyright} -->
<meta name="Description" content="{description}" />
<meta name="Keywords" content="{keywords}" />
<meta equiv="content-type" content="text/html; charset=utf-8" />
{stylesheet}\
</head>
<body>
</body>
</html>
"""
# 
##########################################################################
# 
def read_string(text, default):
    default = ("" if default == None else default)
    ans = input(text + "[{0}]:".format(default))
    ans = (default if len(ans) == 0 else ans)
    return ans
#
def populate_information(information):
    information["filename"] = \
        read_string("Enter file name: ", information["filename"])
    information["name"] = \
        read_string("Enter name: ", information["name"])
    information["year"] = \
        read_string("Enter year: ", information["year"])
    information["title"] = \
        read_string("Enter title: ", information["title"])
    information["description"] = \
        read_string("Enter description: ", information["description"])
    information["keywords"] = \
        read_string("Enter keywords: ", information["keywords"])
    information["stylesheet"] = \
        read_string("Enter stylesheet: ", information["stylesheet"])
#
def write_html_template(name,
                        year,
                        filename,
                        title,
                        description,
                        keywords,
                        stylesheet):
    #
    copyright = COPYRIGHT_TEMPLATE.format(year, xml.sax.saxutils.escape(name))
    title = xml.sax.saxutils.escape(title)
    description = xml.sax.saxutils.escape(description)
    keywords = ",".join([xml.sax.saxutils.eclass CancelledError(Exception): passscape(k) for k in keywords]) if keywords else ""
    stylesheet = (STYLESHEET_TEMPLATE.format(stylesheet) if stylesheet else "")
    html = HTML_TEMPLATE.format(**locals())
    #
    print(html)
#
def main():
    class CancelledError(Exception): pass

    information = dict(name=None,
                       year=datetime.date.today().year,
                       filename=None,
                       title=None,
                       description=None,
                       keywords=None,
                       stylesheet=None)
    while True:
        try:
            print("\nMake HTML Template\n")
            populate_information(information)
            write_html_template(**information)
        except CancelledError:
            print("Cancelled")
        ans = read_string("Create another (y/n)?", default="y")
        if (ans.lower() not in { "y", "yes" }):
            break
#
##########################################################################
#
# start of program
#
main()
#
# bye!
#
sys.exit(0);

