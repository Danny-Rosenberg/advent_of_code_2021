class Whale
	require_relative '../utils/file_parser'

	attr_reader :values

	def initialize(values)
		@values = values
	end


	def find_horizontal_position
		max = values.max
		min = values.min

		min_fuel = max * max
		min_position = max + 1

		(min..max).each do |c|
			fuel = fuel_spent(values, c)
			if fuel < min_fuel
				min_fuel = fuel
				min_position = c
			end
		end

		[min_fuel, min_position]
	end


	def fuel_spent(crab_positions, position)
		crab_positions.sum { |c| (c - position).abs }
	end


	def self.parse_file
		FileParser.new('day_7_input.txt').parse_single_row_csv
	end

end

values = Whale.parse_file
# values = [16,1,2,0,4,2,7,1,2,14]
results = Whale.new(values).find_horizontal_position
puts "the cheapest position is: #{results[1]}"
puts "the fuel spent is #{results[0]}"
