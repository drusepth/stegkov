#!/usr/bin/ruby
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file}

unencoded_message = ARGV[0] || "You should have passed in a string"

puts "Stegoing message"
encoded_message, key = Stegkov.new.encode unencoded_message

# Output results
puts "Done."
puts "Your key is #{key}", "Message: #{encoded_message}"
