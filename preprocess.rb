#!/usr/bin/ruby
#Find word count across all files by concatenating all results
total=0
word_count={}
STDIN.each_line do |line|
  break if line.chomp == "end"
  file = File.new(line.chomp)
  while (process_line = file.gets)
    if( process_line =~ /(.*)\t([0-9]*)/i )
      word_count[$1] ||= 0
      word_count[$1] += $2.to_i
      total += $2.to_i
    end
  end
end

file_out = File.new( "all_words", "w" )
word_count.each{ |word, count|
    file_out<<"#{word}\t#{count}\n";
}
puts "Total=" + total.to_s
