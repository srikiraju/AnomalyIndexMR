#!/usr/bin/ruby

k = 5
topk = Hash.new

STDIN.each_line do |line|
  line.chomp!
  break if line == 'end'
  if( line =~ /(.*)\t([0-9]*\.[0-9]*)/i )
    topk[$1] = $2.to_f
    if topk.length > 5
      low = topk.keys[0]
      topk.each do |k,v|
        if v < topk[low]
          low = k
        end
      end
      topk.delete(low)
    end
  end
end

topk.each do |k,v|
    puts "#{k}:#{v}"
end
