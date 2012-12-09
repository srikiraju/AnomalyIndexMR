#!/usr/bin/ruby

require 'date'
require 'rubygems'
require 'aws/s3'
require 'bigdecimal'
require "bigdecimal/math"
require 'statsample'

include BigMath

prev_word = nil
$collocation_table = {}


def calculate()
  $collocation_table.each{ |key1,value1|
    if $collocation_table[key1][2] < 200
      $collocation_table.delete(key1)
    end 
  }

  return if $collocation_table.size < 3

  matrix_data = []
  matrix_fields = []

  keys = $collocation_table.keys
  for i in 0..keys.length-1
    value1 = $collocation_table[keys[i]]
    matrix_fields << keys[i]

    tmp = []
    for j in 0..keys.length-1
      value2 = $collocation_table[keys[j]]
      jaccard = (value1[1] & value2[1]).length.to_f / ( value1[1] | value2[1] ).length.to_f
      tmp << jaccard
    end
    matrix_data << tmp
  end

  matrix =  Matrix.rows( matrix_data )
  matrix.extend Statsample::CovariateMatrix
  puts matrix.summary

  matrix.fields=matrix_fields
  fa = Statsample::Factor::PCA.new( matrix, :m=>3, :smc=>false )
  puts fa.summary

if false
  output = []
  keys = $collocation_table.keys
  for i in 0..keys.length-1
    value1 = $collocation_table[keys[i]]
    for j in i+1..keys.length-1
        value2 = $collocation_table[keys[j]]
        jaccard = (value1[1] & value2[1]).length.to_f / (value1[1] | value2[1]).length.to_f;
        output << jaccard.to_s + " = " + keys[i] + " :: " + keys[j]
    end
  end
  output.sort
  output.each{ |line| puts line }
  puts "---------------------------------------" if output.length > 0
end
end

STDIN.each_line do |line|
  line.chomp!
  if line =~ /(.*)\t(.*):(L|R):([0-9]*)/
    base_word = $1
    collocate = $2
    l_r = $3
    docid = $4

    prev_word = base_word if prev_word == nil
    if prev_word != nil && prev_word != base_word
        calculate()
        $collocation_table = {}
        prev_word = base_word
    end

    collocate_data = nil
    if l_r == 'L'
        collocate_data = collocate + " " + base_word
    else
        collocate_data = base_word + " " + collocate
    end
    $collocation_table[ collocate_data ] ||= []
    $collocation_table[ collocate_data ][1] ||= []
    $collocation_table[ collocate_data ][2] ||= 0
    $collocation_table[ collocate_data ][1] << docid
    $collocation_table[ collocate_data ][2] += 1

  end
end
