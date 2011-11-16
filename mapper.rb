#!/usr/bin/ruby

require 'rubygems'
require 'aws/s3'
require 'bigdecimal'
require "bigdecimal/math"

include BigMath

AWS.config(:ssl_verify_peer => false)

s3 = AWS::S3.new(
  :access_key_id => 'AKIAI6WMFH3GYHEXOKGQ',
  :secret_access_key => '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')
bucket = s3.buckets['/cs7960']


#Initialize mapper data
mybucket = s3.buckets['srikanthraju']
all_words = mybucket.objects['all_words']

fw = Hash.new

all_words.read.each_line do |s| 
  if s =~ /(.*)\t([0-9]*)/
#    puts $1 + $2
    fw[$1] = $2.to_i
  end
end


#bucket.objects.with_prefix('NSFAbstractsSmall').each do |object|
#puts object.key
#end

STDIN.each_line do |line|
  file = bucket.objects.with_prefix('NSFAbstractsSmall')[line.chomp]
  if file == nil
    next
  end
  process_line = file.read
  word_count = {}
  process_line.split(/[^a-zA-Z0-9]+/).each do |word|
    next if word.downcase =~ /[0-9].*/
    word_count[word.downcase] ||= 0
    word_count[word.downcase] += 1
  end
 
  total_words = 0
  word_count.each do |k,v|
    total_words += v
  end

  word_count.each do |k,v|
    #puts v
    #puts total_words
    #puts fw[k]
    p = Math.log((BigDecimal.new(v.to_s)/BigDecimal.new(total_words.to_s))/(BigDecimal.new(fw[k].to_s)/BigDecimal.new('4418825')))
    p = p * (BigDecimal.new(v.to_s)/BigDecimal.new(total_words.to_s));
    puts "DoubleValueSum:#{line.chomp}\t#{p.to_f.to_s}"
  end
end
