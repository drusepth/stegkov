#!/usr/bin/ruby
key = ARGV[0] || exit
encoded = ARGV[1] || exit

puts "Building dictionary"
dict = File.foreach('/usr/share/dict/american-english').map(&:downcase).map(&:strip).map{|word| word.tr('^A-Za-z', '')}.uniq.select{|word| word.length > 3}

puts "Extracting message"
key_index = 0
sentinel_active = false
decoded_message = encoded.split(' ').map do |word|
  if sentinel_active
    sentinel_active = false
    word
  elsif word[0] == key[key_index]
    sentinel_active = true
    key_index += 1
    nil
  else
    nil
  end
end.compact.join(' ')

puts "Done."
puts "Message: #{decoded_message}"

