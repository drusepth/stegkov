class Stegkov
  def dictionary
    # todo cache this
    File.foreach('/usr/share/dict/american-english').map(&:downcase).map(&:strip).map{|word| word.tr('^A-Za-z', '')}.uniq.select{|word| word.length > 3}
  end

  def generate_key_for unencoded_message
    dictionary.select{|word| (('a'..'z').to_a - unencoded_message.downcase.split(' ').map{|i| i[0]}).include? word[0]}.sample
  end

  def encode unencoded_message
    key = generate_key_for unencoded_message
    key_index = -1

    [unencoded_message.downcase.split(' ').map do |unencoded_word|
      key_index = key_index == key.length ? 0 : key_index + 1
      [
        random_words(rand(15), key[key_index]),                      # Random number of prefixing words
        dictionary.select{|word| word[0] == key[key_index]}.sample,  # Sentinel word
        unencoded_word,                                              # Next word to inject
        random_words(rand(5), key[key_index])                        # Random number of affixing words
      ]
    end.flatten.join(' ').capitalize, key]
  end

  def decode encoded_message, key
    key_index = 0
    sentinel_active = false
    decoded_message = encoded_message.split(' ').map do |word|
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
  end

  def random_words num, key
    (1..num).map do |context_word|
      dictionary.reject{|word| word[0] == key}.sample
    end
  end
end
