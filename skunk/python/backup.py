#!/usr/local/bin/python

"""Usage: backup.py [options] <source dir 1> <source dir 2> ... <dest dir>

WARNING: This utility can cause lost data if used improperly and it is
provided WITHOUT WARRANTY.  See --readme and --license for more info.

Options:
    -v
    --verbose
        generate additional status messages on stdout

    -l
    --log
        generate a log file of status messages

    --msdos
        activates various hacks to enable compatibility on Microsoft
        DOS or Windows based environments (eg. strips ":" characters
        out of the destination path so "C:/blah" becomes "C/blah")

    --purge
        automatically deletes extraneous files and directories that
        are found in the dest path (WARNING: if you use this option
        and reverse your dest and src dirs, you will wipe out the files
        that you are trying to back up)

    --skip_check
        skips the step of using an MD5 hash to ensure that the file
        was copied correctly (faster but less robust)

    --paranoid
        instead of comparing file timestamps, uses MD5 hashes to check
        whether files are the same (very slow over a network)

    -h
    --help
        displays this message

    --license
        displays the license that this software is provided under

    --readme
        displays additional readme
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
Requires Python 2.4 or higher.

If you like this software, visit my web site:

    http://www.bushidoburrito.com/

About:

    This backup script basically does a recursive tree-copy on the given
    source paths into the given destination path.  The real magic happens when
    the script is run again since it will avoid re-copying files that have not
    been changed since the last run.

Examples:

    If you want a simple tree-copy from directory "src" into a new dir called
    "dest", then try the following:

    mkdir dest
    python backup.py src dest

    If you're using Windows XP and want to backup everything under
    "C:\Documents and Settings" to a network drive called "\\backup_serv"
    then try the following:

    python backup.py --msdos "C:\Documents and Settings" "\\backup_serv"

    If you want to flat-out mirror the contents of directory "src" to
    directory "dest" with absolute confidence that it worked and dangerously
    clobbering everything in the way, try the following:

    python backup.py --paranoid --purge src dest

    Remember to always exercise caution with this program, as it will
    clobber files in any destination path that you point it at.
"""

import sys, os, re, stat, string, getopt, time, md5, shutil
from os.path import join, abspath

class Logger:
    """A simple class for optionally logging messages to a file
       and/or sending those same messages to stdout."""

    def __init__(self):
        self.verbose = False
        self.log = False
        self.always_flush = False
        self.__log_file = None

    def __del__(self):
        self.close_log_file()

    def open_log_file(self):
        """Used to create the log file.  The filename is based on
        today's date."""
        if self.__log_file != None:
            self.__log_file.close()
        filename = time.strftime("log-%Y-%m-%d.txt")
        self.__log_file = open(filename, "a")

    def close_log_file(self):
        """Used to close the log file."""
        if self.__log_file != None:
            self.__log_file.close()
            self.__log_file = None

    def send(self, msg, force=False):
        """Log a message to stdout and/or the log file, depending
        on the current values of self.verbose and self.log.
        The force param will cause the message to be sent to stdout
        regardless of self.verbose, which is useful for errors
        and warning messages."""
        if self.verbose or force:
            print msg
        if self.log:
            if self.__log_file == None:
                self.open_log_file()
            self.__log_file.write(msg + "\n")
            if self.always_flush:
                self.__log_file.flush()

def compare_files(file1, file2):
    """Returns True only if the files with the given paths have the
    same MD5 hash."""
    hash1 = md5.new()
    f = open(file1)
    try:
        for line in f:
            hash1.update(line)
    finally:
        f.close()

    hash2 = md5.new()
    f = open(file2)
    try:
        for line in f:
            hash2.update(line)
    finally:
        f.close()

    return hash1.digest() == hash2.digest()

def compare_file_timestamps(file1, file2):
    """Returns True only if the files with the given paths have the
    same "LastModified" timestamps."""
    stat1 = os.stat(file1)
    stat2 = os.stat(file2)
    return stat1[stat.ST_MTIME] == stat2[stat.ST_MTIME]

def format_time_str(time):
    """Takes a float number of seconds and converts that to a string
    telling the number of hours, minutes, and seconds represented."""
    hours = int(time / 3600)
    time = time % 3600
    mins = int(time / 60)
    time = time % 60
    return str(hours) + " hours, " + str(mins) + " minutes, and " + \
            str(round(time, 2)) + " secs"

#
#  main program starts here
#
def main(argv=None):
    # this way we can test main from the interpreter prompt
    if argv is None:
        argv = sys.argv

    try:
        opts, args = getopt.getopt(argv[1:], "hvl", \
                ["help", "license", "readme", "verbose", "log", "msdos", \
                "skip_check", "paranoid", "purge"])
    except getopt.GetoptError:
        print __doc__
        return 2

    log = Logger()

    # set default options
    purge = False
    skip_check = False
    paranoid = False
    msdos = False

    for o, a in opts:
        if o in ("-v", "--verbose"):
            log.verbose = True
        elif o in ("-l", "--log"):
            log.log = True
        elif o == "--purge":
            purge = True
        elif o == "--skip_check":
            skip_check = True
        elif o == "--paranoid":
            paranoid = True
        elif o == "--msdos":
            msdos = True
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
    dest_dir = args[len(args)-1]
    src_dirs = args[0:len(args)-1]
    if len(src_dirs) < 1:
        print __doc__
        return 2
    if not os.path.exists(dest_dir):
        log.send(str("error: destination "+dest_dir+" does not exist"), True)
        return 0
    src_dirs_copy = list(src_dirs)
    for dir in src_dirs_copy:
        abs_dir = abspath(dir)
        if not os.path.exists(abs_dir):
            log.send("warning: source "+dir+" does not exist", True)
            src_dirs.remove(dir)
            continue
        for root, dirs, files in os.walk(dir, topdown=True):
            if root == abspath(dest_dir):
                log.send("error: destination cannot be a sub-directory " \
                        + "of any source dirs", True)
                return 1
    if len(src_dirs) < 1:
        log.send("error: no valid src dirs were given", True)
        return 1
    # --purge is not allowed if the last src dir given is empty, since
    # it is suspected that the user could have confused dest with src
    if purge:
        for root, dirs, files in os.walk(src_dirs[len(src_dirs)-1], \
                topdown=True):
            if len(dirs) < 1 and len(files) < 1:
                log.send("error: --purge not allowed if the last src dir "\
                        + "is empty (check the order of your args!)", True)
                return 1
            break

    start_time = time.time()

    seen_dirs = []  # tracks which dirs have been processed

    # scan for extraneous files in the dest dir
    dest = abspath(dest_dir)
    for root, dirs, files in os.walk(dest, topdown=False):

        root_dir = root[root.find(dest)+len(dest)+1:]

        # re-insert ":" chars removed by msdos processing
        if msdos and re.compile(r"^[A-Z]\\").match(root_dir[0:3]):
            root_dir = root_dir[0:1] + ":" + root_dir[1:]
        if msdos and len(root_dir) == 1 and re.match("[A-Z]", root_dir):
            root_dir = root_dir + ":\\"

        for file in files:
            path = join(root_dir, file)
            if not os.path.exists(path):
                path = join(root, file)
                log.send("warning: extraneous dest file " + path, True)
                if purge:
                    try:
                        os.unlink(path)
                    except OSError, e:
                        log.send("warning: cannot delete " + path + \
                                " (" + e[1] + ")", True)

        # with --msdos hacks enabled, the lowest-level root should
        # only contain drive letter dirs
        if msdos and root == dest:
            for dir in dirs:
                if not re.match("[A-Z]", dir):
                    path = join(root, dir)
                    log.send("warning: extraneous dest dir " + path, True)
                    if purge:
                        try:
                            os.rmdir(path)
                        except OSError, e:
                            log.send("warning: cannot rmdir " + path + \
                                    " (" + e[1] + ")", True)

        for dir in dirs:
            path = join(root_dir, dir)
            if not os.path.exists(path):
                path = join(root, dir)
                log.send("warning: extraneous dest dir " + path, True)
                if purge:
                    try:
                        os.rmdir(path)
                    except OSError, e:
                        log.send("warning: cannot rmdir " + path + \
                                " (" + e[1] + ")", True)

    # begin the actual backup process
    for dir in src_dirs:

        dir = abspath(dir)  # simplifies dir path issues
        log.send("processing " + dir)

        for root, dirs, files in os.walk(dir, topdown=True):

            # avoid processing redundant dirs
            if root in seen_dirs:
                continue
            seen_dirs.append(root)

            if msdos:
                # DOS paths will contain : chars after the drive letter
                temp = string.replace(root, ":", "")
                dest = join(dest_dir, temp)
            else:
                dest = join(dest_dir, root)

            if not os.path.exists(dest):
                os.makedirs(dest)
                # shutil.copytree(root, dest)  # optimizaton?
                log.send("new dir: " + root)

            for file in files:
                src_file = join(root, file)
                dest_file = join(dest, file)

                if os.path.exists(dest_file):
                    files_equal = False
                    if paranoid and compare_files(src_file, dest_file):
                        continue
                    elif compare_file_timestamps(src_file, dest_file):
                        continue
                    else:
                        # delete the old file
                        try:
                            os.unlink(dest_file)
                            log.send("updated: " + src_file)
                        except OSError, e:
                            log.send("warning: cannot delete " + dest_file + \
                                    " (" + e[1] + ")", True)
                else:
                    log.send("new file: " + src_file)

                try:
                    shutil.copy2(src_file, dest)
                    if not skip_check and \
                            not compare_files(src_file, dest_file):
                        log.send("warning: file copy check failed for " \
                                + dest_file, True)
                except IOError, e:
                    log.send("warning: cannot copy " + src_file + \
                            " (" + e[1] + ")", True)

    log.send("done in " + format_time_str(time.time() - start_time))

if __name__ == "__main__":
    sys.exit(main())

