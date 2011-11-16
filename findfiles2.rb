#!/usr/bin/ruby

require 'rubygems'
require 'aws/s3'

#Find files to process for Q3, in subsets of size 2
s3 = AWS::S3.new(
  :access_key_id => 'AKIAI6WMFH3GYHEXOKGQ',
  :secret_access_key => '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')


s3.buckets.each do |bucket|
#   puts bucket.name
end

bucket = s3.buckets['/cs7960/']

files = Array.new

bucket.objects.with_prefix('NSFAbstractsSmall/awd_1990_57').each do |object|
  if( object.key.include? ".txt" )
    files.push( object.key )
  end
end

files.each do | file |
  files.slice( files.index( file )..files.size() ).each do | file2 |
    puts file + "," + file2
  end
end
