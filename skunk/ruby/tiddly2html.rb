#!/usr/local/bin/ruby

# ------------------------------------------------------------------------------
#
#  tiddly2html
#
#  (BSD style license follows)
#
#  Copyright (c) 2006, Jason Estey
#  All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  
#  * Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#  * Neither the name of the Bushido Burrito nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#
# ------------------------------------------------------------------------------

require 'date'

# 
#  used to convert tiddly content text into HTML
#  eg. the string \\n should be <br>
#
#  TODO: handle [[Google|http://www.google.com/]] style links
#  TODO: handle <<< blockquotes
#  TODO: handle {{{ }}}} code quotes
#  TODO: handle !title title headings
#
def process_tiddly_content!(content, tiddler_names)

    # newline
    content.gsub!(/\\n/, "\n<br>\n")

    # bold
    while content.sub!(/''/, "<b>")
        content.sub!(/''/, "</b>")
    end

    # italics
    while content.sub!(/[^(http:)]\/\//, "<i>")
        content.sub!(/[^(http:)]\/\//, "</i>")
    end

    # internal links
    while content =~ /\[\[(.*?)\]\]/
        link_num = tiddler_names.index($1)
        link_text = $1
        if link_num != nil
            link_text = "<a href='" + link_num.to_s + ".html'>#{$1}</a>"
        end
        content.sub!(/\[\[.*?\]\]/, link_text)
    end
end

# ------------------------------------------------------------------------------
#  main program starts here
# ------------------------------------------------------------------------------

if (ARGV.length != 2)
    print "usage: tiddly2html <filename> <output path>\n"
    exit
end

input_path  = ARGV[0]
output_path = ARGV[1]

if (!FileTest.exists?(input_path) || !FileTest.readable?(input_path))
    print "error: could not read \"#{input_path}\""
    exit
end

if (!FileTest.exists?(output_path) || !FileTest.directory?(output_path))
    print "error: could not output to directory \"#{output_path}\""
    exit
end

tiddler_regex = /^<div tiddler="(.*?)" modifier="(.*?) modified="(.*?)" created="(.*?)" tags="(.*?)">(.*?)<\/div>/

# build up the tiddler names array, which is needed for building
# internal links between pages later
tiddler_names = Array.new
File.open(input_path).each do |line|
    if line =~ tiddler_regex
        tiddler_names.push($1)
    end
end

count = 0
File.open(input_path).each do |line|
    if line =~ tiddler_regex
        tiddler = $1
        modifier = $2
        modified = $3
        created = $4
        tags = $5
        content = $6

        modified_date = DateTime.parse(modified)
        created_date = DateTime.parse(created)
        process_tiddly_content!(content, tiddler_names)

        # TODO: do something useful with tags

        output_filename = output_path + "/" + count.to_s + ".html"
        puts "writing #{output_filename}"
        output_file = File.new(output_filename, "w")
        output_file.write("<html>
<head>
<title>TiddlyWiki Dump - #{tiddler}</title>
</head>

<body>
<h1>#{tiddler}</h1>
<h3>created on #{created_date.to_s}</h3>
<h3>modified by #{modifier} on #{modified_date.to_s}</h3>
<blockquote>#{content}</blockquote>
</body>
</html>
")
        output_file.close
        count = count + 1
    end
end

# now create an index file with all of the tiddler names

output_filename = output_path + "/index.html"
puts "writing #{output_filename}"
output_file = File.new(output_filename, "w")
output_file.write("<html>
<head>
<title>TiddlyWiki Dump</title>
</head>

<body>
<h1>TiddlyWiki Dump</h1>
<p>
")
count = 0
tiddler_names.each do |tiddler_name|
    output_file.write("<a href='#{count}.html'>#{tiddler_name}</a><br>")
    count = count + 1
end
output_file.write("</p>
</body>
</html>
")

