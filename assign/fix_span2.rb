#! /usr/bin/env ruby

STDIN.each_line do |line|
  line.rstrip!
  line.gsub!(/`([^`]*)`\{\.([a-z-]+)\}/) { |s| "<span class='#{$2}' markdown='1'>#{$1}</span>" }
  puts line
end
