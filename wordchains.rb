class WordChain

	attr_reader :neighbor_map

	def init_neighbor_map
		@neighbor_map = Hash.new { |hash, key| hash[key] = [] }
	end

	def add_to_map(word)
		word.size.times do |letter_index|
			key = word.dup
			key[letter_index] = "0"
			@neighbor_map[key.to_sym] << word
		end
	end

	def prune_isolated_words
		@neighbor_map.select { |key, val| val.length > 1 }
	end

	def build_neighbor_map(word_length, dictionary = './dictionary.txt')
		init_neighbor_map

		File.foreach(dictionary) do |word|
			add_to_map(word.chomp) if word.chomp.length == word_length
		end
	end

end