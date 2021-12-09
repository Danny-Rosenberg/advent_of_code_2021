class Diagnostic2

	attr_reader :lines, :oxygen_array, :co2_array

	def initialize
		parse_file
	end

	def parse_file
		lines = []

		File.foreach("day_3_input.txt") do |line|
			line.chomp! # remove newline character
			line = line.split('')
			lines << line
		end

		@lines = lines

		@oxygen_array = build_array(OxygenStrategy.new)
		@co2_array    = build_array(CO2Strategy.new)
	end


	def build_array(strategy)
		matching_lines = lines

		(0...lines.first.length).each do |i|
		  matching_lines = strategy.filter_lines(matching_lines, i)
			break if matching_lines.length == 1 # we've found our rating
		end

		matching_lines
	end


	class DiagnosticStrategy

		def apply_criteria
			raise NotImplementedError
		end

		def filter_lines(diagnostic_lines, i)
			zeros = []
			ones  = []
		  diagnostic_lines.each do |line|
				if line[i] == "0"
				  zeros << line
				else
					ones << line
				end
			end

			apply_criteria(zeros, ones)
		end
	end


	class OxygenStrategy < DiagnosticStrategy

		# oxygen critera: use most common value
		def apply_criteria(zeros, ones)
			if zeros.length > ones.length
				zeros
			else # more ones than zeros, or lengths are equal
				ones
			end
		end

		def to_s
			"oxygen"
		end
	end


	class CO2Strategy < DiagnosticStrategy

		# oxygen critera: use most common value
		def apply_criteria(zeros, ones)
			if zeros.length > ones.length
				ones
			else # more ones than zeros, or lengths are equal
				zeros
			end
		end

		def to_s
			"co2"
		end
	end


	def calculate_life_support_rating
		Integer("0b#{oxygen_array.join}") * Integer("0b#{co2_array.join}")
	end
end

diagnostic = Diagnostic2.new
rating = diagnostic.calculate_life_support_rating
puts "oxygen rating: #{diagnostic.oxygen_array} and co2 rating: #{diagnostic.co2_array}"
puts "total consumption is: #{rating}"
