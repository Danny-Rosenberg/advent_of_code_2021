class FileParser

	FILE = "day_5_input.txt"

	class << self
		def parse
			lines = []
			File.foreach(FILE) do |line|
				line.chomp! # remove newline character
				line = line.split(' -> ')
				# take ["309,347", "309,464"] and turn it into [309, 347, 309, 464]
				lines << (line[0].split(',') + line[1].split(',')).map(&:to_i)
			end
			lines
		end
	end


end
