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

#bucket.objects.with_prefix('NSFAbstractsSmall').each do |object|
#puts object.key
#end

word_count = {}
STDIN.each_line do |line|
  line.chomp!
  $stderr.puts line + ":"
  if line =~ /([a-zA-Z0-9]*\.txt).*/
    $stderr.puts $1 + ":"
    file = nil
    bucket.objects.with_prefix('NSFAbstractsSmall').each do |obj|
      if obj.key.include? $1
        file = obj
        break
      end
    end
    if file == nil
      next
    end
    process_line = file.read
    process_line.split(/[^a-zA-Z0-9]+/).each do |word|
      next if word.downcase =~ /[0-9].*/
      word_count[word.downcase] ||= 0
      word_count[word.downcase] += 1
    end
  end
end

word_count.each do |k,v|
  #puts v
  #puts total_words
  #puts fw[k]
  #p = Math.log((BigDecimal.new(v.to_s)/BigDecimal.new(total_words.to_s))/(BigDecimal.new(fw[k].to_s)/BigDecimal.new('4418825')))
  #p = p * (BigDecimal.new(v.to_s)/BigDecimal.new(total_words.to_s));
  puts "#{k}\t#{v.to_s}"
end

