require 'set'
require 'debugger'

class WordChain

	attr_reader :neighbor_map

	def initialize(word_length)
		build_neighbor_map(word_length)
	end

	def build_neighbor_map(word_length, dictionary = './dictionary.txt')
		init_neighbor_map

		File.foreach(dictionary) do |word|
			add_to_map(word.chomp) if word.chomp.length == word_length
		end

		# prune_deadend_words!
	end

	def trace(parent_to_children)
		puts parent_to_children
	end

	def build_path(
			start_word,
			end_word,
			curr_level = Set.new << start_word,
			parent_roster = Hash.new { |hash, key| hash[key] = Set.new }
		)
		# debugger

		next_level = Set.new

		curr_level.each do |parrent_word|

			parrent_word.size.times do |letter_index|
				neighbor_type = parrent_word.dup
				neighbor_type[letter_index] = "0"

				children_array = Set.new.merge(@neighbor_map[neighbor_type.to_sym])

				parent_roster[parrent_word.to_sym].merge(children_array)

				if children_array.include?(end_word)
					#trace
					return trace(parent_roster)
				end
				
				next_level.merge(children_array)
			end
		end
		build_path(
			start_word,
			end_word,
			curr_level = next_level,
			parent_roster
		)
	end

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

	def prune_deadend_words!
		@neighbor_map = @neighbor_map.select { |key, val| val.length > 1 }
	end
end

if $0 == __FILE__
	a= WordChain.new(4)
	
	a.build_path("ably","abbe")
end