#!/usr/bin/ruby

require 'date'
require 'rubygems'
require 'aws/s3'


AWS.config(:ssl_verify_peer => false)

s3 = AWS::S3.new(
  :access_key_id => 'AKIAI6WMFH3GYHEXOKGQ',
  :secret_access_key => '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')

#Initialize mapper data
bucket = s3.buckets['collocationdata']

words = []
left_regex = "\\b([a-zA-Z0-9]+)\\b[ \\t]*\\b("
right_regex = "\\b("
words_file = bucket.objects['process_words']
words_text = words_file.read

#Read 'interesting' words from file
words_text.split.each do | word |
    left_regex <<  word << "|"
    right_regex << word << "|"
end

left_regex.chop!
right_regex.chop!

left_regex << ")\\b"
right_regex << ")\\b[ \\t]*\\b([a-zA-Z0-9]+)\\b"

#puts left_regex
#puts right_regex

STDIN.each_line do |line|
  if line.chomp =~ /([0-9]*):(.*)/
    docid = $1
    file = bucket.objects[$2]
    if file == nil
      next
    end
    process_file = file.read
    next if process_file.size == 0

    process_file.downcase!
    #puts process_file.size
    #puts process_file[0..-1]

    left_regex_obj = Regexp.new( left_regex );
    right_regex_obj = Regexp.new( right_regex );
    position = 0
    while true 
        m = process_file[position..-1].match( right_regex_obj )
        break if m == nil
        position += Regexp.last_match.begin(0) + $1.length
        puts $1 + "\t" + $2 + ":" + "R:" + docid
    end
    position = 0
    while true 
        m = process_file[position..-1].match( left_regex_obj )
        break if m == nil
        position += Regexp.last_match.begin(0) + $1.length
        puts $2 + "\t" + $1 + ":" + "L:" + docid
    end
  end
end
