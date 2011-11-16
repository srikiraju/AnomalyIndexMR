#!/usr/bin/ruby

#Get files to process for Q2
require 'rubygems'
require 'aws/s3'

s3 = AWS::S3.new(
  :access_key_id => 'AKIAI6WMFH3GYHEXOKGQ',
  :secret_access_key => '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')


s3.buckets.each do |bucket|
#   puts bucket.name
end

bucket = s3.buckets['/cs7960/']


bucket.objects.with_prefix('NSFAbstractsSmall').each do |object|
  if( object.key.include? ".txt" )
    puts object.key #=> no data is fetched from s3, just a list of keys
  end
end

