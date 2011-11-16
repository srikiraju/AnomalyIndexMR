#!/usr/bin/ruby

s3 = AWS::S3.new(
  :access_key_id => 'AKIAI6WMFH3GYHEXOKGQ',
  :secret_access_key => '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')
bucket = s3.buckets['/cs7960']

STDIN.each_line do |line|
  if line ~= /(.*),(.*)\t([0-9]*)/
    
  end 
end
