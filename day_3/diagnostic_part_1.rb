class Diagnostic1

	attr_reader :lines

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
	end


	def gamma_array
	  @gamma_array ||= build_gamma_array
	end


	def epsilon_array
		@epsilon_array ||= build_epsilon_array
	end


	def build_gamma_array
		gamma      = []
		column_sum = 0

		# iterate by column in 2d array
		(0...lines.first.length).each do |i|
			lines.each do |line|
				column_sum += line[i].to_i
			end

			gamma << apply_gamma_logic(column_sum)
			column_sum = 0
		end

		gamma
	end


	def apply_gamma_logic(value)
		puts "value is: #{value}"
		if value > lines.length / 2
			"1"
		else
			"0"
		end
	end


	def build_epsilon_array
		# implement bitwise 'not'
		gamma_array.map { |num| num == "1" ? "0" : "1" }
	end

	def calculate_consumption
		Integer("0b#{gamma_array.join}") * Integer("0b#{epsilon_array.join}")
	end
end

consumption = Diagnostic1.new.calculate_consumption
puts "total consumption is: #{consumption}"

