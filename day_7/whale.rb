class Whale
	require_relative '../utils/file_parser'

	attr_reader :values, :strategy


	def initialize(values, strategy)
		incremental_strategy = Proc.new do |crab_positions, position|
			crab_positions.sum { |c| (c - position).abs }
		end


		increasing_strategy = Proc.new do |crab_positions, position|
			# (n^2 + n) / 2
			crab_positions.sum do |c|
			  sum = (c - position).abs
				((sum * sum) + sum) / 2
			end
		end

		@values   = values
		@strategy = strategy == :incremental ? incremental_strategy : increasing_strategy
	end


	def find_horizontal_position
		max = values.max
		min = values.min

		min_fuel = max * 1000000000 # placeholder
		min_position = -1 # placeholder

		(min..max).each do |c|
			fuel = strategy.call(values, c)
			if fuel < min_fuel
				min_fuel = fuel
				min_position = c
			end
		end

		[min_fuel, min_position]
	end


	def self.parse_file
		FileParser.new('day_7_input.txt').parse_single_row_csv
	end

end


values = Whale.parse_file
# values = [16,1,2,0,4,2,7,1,2,14]

# part 1
# go through each integer between min and max in the given range
# check the distance of each value in data set from the current value
# o(n^2)

results = Whale.new(values, :incremental).find_horizontal_position
puts "using the 'incremental' strategy, the fuel spent is #{results[0]}"
puts "the cheapest position is: #{results[1]}"

# part 2
# go through each integer between min and max in the given range
# check distance using 'addition factorial'
# o(n^2)
results2 = Whale.new(values, :increasing).find_horizontal_position
puts "using the 'increasing' strategy, the fuel spent is #{results2[0]}"
puts "the cheapest position is: #{results2[1]}"
