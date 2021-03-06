class FileParser

	attr_reader :file

	def initialize(file_location)
		@file = file_location
	end

	def parse_arrows
		lines = []
		File.foreach(file) do |line|
			line.chomp! # remove newline character
			line = line.split(' -> ')
			# take ["309,347", "309,464"] and turn it into [309, 347, 309, 464]
			lines << (line[0].split(',') + line[1].split(',')).map(&:to_i)
		end
		lines
	end


	# ex. [1, 3, 4, 1, 4, 7]
	def parse_single_row_csv
		File.read(file)
				.chomp!
				.split(',')
				.map(&:to_i)
	end


	# for day 8 i.e. aebgc fa afe | fa af defgc
	# add to a hash
	def parse_spaces_with_line
		signals_output = {}
		File.foreach(file) do |line|
			line.chomp!
			line = line.split(' | ')
			signals_output[line[0].split(' ')] = line[1].split(' ')
		end
		signals_output
	end

end
