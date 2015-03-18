#!/usr/bin/ruby
unencoded = ARGV[0] || "You should have passed in a string"

puts "Building dictionary"
dict = File.foreach('/usr/share/dict/american-english').map(&:downcase).map(&:strip).map{|word| word.tr('^A-Za-z', '')}.uniq.select{|word| word.length > 3}

puts "Generating key"
possible_keys = ARGV[1] || begin
  ('a'..'z').to_a - unencoded.downcase.split(' ').map{|i| i[0]}
end
key = dict.select{|word| possible_keys.include? word[0]}.sample
key_index = -1

def random_words dict, num, key
  (1..num).map do |context_word|
    dict.reject{|word| word[0] == key}.sample
  end
end

puts "Stegoing message"
corpus = unencoded.downcase.split(' ').map do |unencoded_word|
  key_index = key_index == key.length ? 0 : key_index + 1
  [
    random_words(dict, rand(15), key[key_index]),          # Random number of prefixing words
    dict.select{|word| word[0] == key[key_index]}.sample,  # Sentinel word
    unencoded_word,                                        # Next word to inject
    random_words(dict, rand(5), key[key_index])            # Random number of affixing words
  ]
end.flatten.join(' ').capitalize

# Output results
puts "Done."
puts "Your key is #{key}", "Message: #{corpus}"
