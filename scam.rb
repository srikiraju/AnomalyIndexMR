#!/usr/bin/ruby

STDIN.each_line do |line|
  line.chomp!
  if( line =~ /(.*)\t([0-9]*\.[0-9]*)/i )
    puts "#{$2}:#{$1}"
  end
end
