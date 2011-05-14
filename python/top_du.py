#!/usr/local/bin/python

"""Usage: top_du.py [options] <source dir 1> <source dir 2> ...

Analyzes all of the given document roots and puts together a list
of the largest files and directories that were found.

Options:
    -n[num]
    --results=[num]
        displays the top [num] results in the output (default: 20)

    -k
        displays the results in bytes, kb, mb, and gb instead of just bytes

    -h
    --help
        displays this message

    --license
        displays the license that this software is provided under

    --readme
        displays additional readme

Examples:

    The following bit would show you the top 50 stats on disk usage
    in your home directory under Unix:

    python top_du.py -n50 ~

    The same can be accomplished in Windows XP:

    python top_dy.py -n50 "C:\Documents and Settings\[Username]\My Documents"

    Note that you must replace [Username] with your login user name.
"""

license = """(BSD style license follows)

  Copyright (c) 2007, Jason Estey
  All rights reserved.
  
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  
  * Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  * Neither the name of the Bushido Burrito nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
"""

readme = """
If you like this software, visit my web site:

    http://www.bushidoburrito.com/

"""

import sys, os, getopt, time
from os.path import join, getsize, abspath

def format_size_str(size):
    """Takes an integer number of bytes and converts it to a string
    that represents it in kilobytes, megabytes, or gigabytes."""
    if size < 1024:
        return str(size) + " bytes"
    if size < pow(1024, 2):
        return str(size/1024) + " kb"
    if size < pow(1024, 3):
        return str(size/pow(1024, 2)) + " mb"
    return str(size/pow(1024, 4)) + " gb"

#
#  main program starts here
#
def main(argv=None):
    # this way we can test main from the interpreter prompt
    if argv is None:
        argv = sys.argv

    try:
        opts, args = getopt.getopt(argv[1:], "hn:k", \
                ["help", "license", "readme", "results="])
    except getopt.GetoptError:
        print __doc__
        return 2

    # set default options
    top_n = 20
    show_kilobytes = False

    for o, a in opts:
        if o in ("-n", "--results"):
            top_n = int(a)
        elif o == "-k":
            show_kilobytes = True
        elif o in ("-h", "--help"):
            print __doc__
            return 0
        elif o == "--license":
            print license
            return 0
        elif o == "--readme":
            print readme
            return 0

    # check for invalid args
    if len(args) < 1:
        print __doc__
        return 0
    for dir in args:
        if not os.path.exists(dir):
            print "warning: directory", dir, "does not exist"
            args.remove(dir)
    if top_n < 1:
        print "warning: -n option must be at least 1"
        top_n = 1

    print "now walking the dirs...",
    start_time = time.time()

    dir_dict = {}  # used to store temp dir size results

    # final results go in these three vars
    root_dir_totals = []
    sub_dir_totals = []
    file_totals = []

    for dir in args:

        dir = abspath(dir)  # simplifies dir path issues

        for root, dirs, files in os.walk(dir, topdown=False):

            # it's possible for the user to supply redundant dirs
            # in the argument list, so check for that
            redundant = False
            for dir_size, num_files, dir in sub_dir_totals:
                if dir == root:
                    redundant = True
                    break
            if redundant:
                continue

            dir_size = sum(getsize(join(root, name)) for name in files)
            sub_dir_totals.append(( \
                dir_size, \
                len(files), \
                root ))

            # for the root dir, also add the size of each sub dir
            # note: this depends on topdown=False for os.walk
            for name in dirs:
                dir_name = join(root, name)
                if dir_dict.has_key(dir_name):
                    dir_size += dir_dict[dir_name]
            dir_dict[root] = dir_size  # store for parent use
            root_dir_totals.append(( \
                dir_size, \
                root ))

            for name in files:
                filename = join(root, name)
                file_totals.append(( \
                    getsize(filename), \
                    filename ))

    print "done (" + str(round(time.time() - start_time, 2)) + " secs)"

    print "now sorting the results...",
    start_time = time.time()

    root_dir_totals.sort(reverse=True)
    sub_dir_totals.sort(reverse=True)
    file_totals.sort(reverse=True)

    print "done (" + str(round(time.time() - start_time, 2)) + " secs)"

    # now we display all of the results for the user

    print
    print "Top", top_n, "Largest Root Directories"
    print "--------------------"

    i = 0
    for dir_size, dir in root_dir_totals:
        size_str = str(dir_size) + " bytes"
        if show_kilobytes:
            size_str = format_size_str(dir_size)
        print size_str, "under", dir
        i += 1
        if i >= top_n:
            break

    print
    print "Top", top_n, "Largest Sub-Directories"
    print "--------------------"

    i = 0
    for dir_size, file_count, dir in sub_dir_totals:
        size_str = str(dir_size) + " bytes"
        if show_kilobytes:
            size_str = format_size_str(dir_size)
        print size_str, "in", file_count, "files:", dir
        i += 1
        if i >= top_n:
            break

    print
    print "Top", top_n, "Largest Files"
    print "--------------------"

    i = 0
    for file_size, file_name in file_totals:
        size_str = str(file_size) + " bytes"
        if show_kilobytes:
            size_str = format_size_str(file_size)
        print size_str, "in", file_name
        i += 1
        if i >= top_n:
            break

    return 0

if __name__ == "__main__":
    sys.exit(main())

