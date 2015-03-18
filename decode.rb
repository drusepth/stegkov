#!/usr/bin/ruby
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file}

key = ARGV[0] || exit
encoded_message = ARGV[1] || exit

puts "Extracting message"
decoded_message = Stegkov.new.decode encoded_message, key

puts "Done."
puts "Message: #{decoded_message}"

