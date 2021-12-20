class Lanternfish

	attr_reader :values

	NEW_FISH_COUNTDOWN = 8
	OLD_FISH_COUNTDOWN = 6


	def initialize(values)
		@values = values
	end


	def number_of_fish_after(days)
		(1..days).each do
			decrement_values
		end
		values.length
	end


	def decrement_values
		# update values in place
		(0...values.length).each do |i|
			if values[i] == 0
				values[i] = apply_birth_rule
				values << new_fish_rule
			else
				values[i] -= 1
			end
		end
	end


	def new_fish_rule
		NEW_FISH_COUNTDOWN
	end


	def apply_birth_rule
		OLD_FISH_COUNTDOWN
	end

end


require_relative '../utils/file_parser'
values = FileParser.new('day_6_input.txt').parse_single_row_csv
number_fish = Lanternfish.new(values).number_of_fish_after(80)
puts "number of fish after 80 days: #{number_fish}"
