#!/usr/bin/ruby
unencoded = ARGV[0] || "You should have passed in a string"
dict = File.foreach('/usr/share/dict/american-english').map(&:downcase).map(&:strip).map{|word| word.tr('^A-Za-z', '')}.uniq.select{|word| word.length > 3}

# build key: word that doesn't start with the same character as any other word
possible_keys = ARGV[1] || begin
  ('a'..'z').to_a - unencoded.downcase.split(' ').map{|i| i[0]}
end
key = dict.select{|word| possible_keys.include? word[0]}.sample
key_index = -1

def words_until dict, key
  more_words dict, rand(15), key
end

def more_words dict, num, key
  (1..num).map do |context_word|
    dict.reject{|word| word[0] == key}.sample
  end
end

# build corpus
corpus = unencoded.downcase.split(' ').map do |unencoded_word|
  key_index += 1
  [words_until(dict, key[key_index]), dict.select{|word| word[0] == key[key_index]}.sample, unencoded_word]
end.flatten.join(' ').capitalize

puts "Your key is #{key}", corpus
