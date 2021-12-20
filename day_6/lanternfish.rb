class Lanternfish

	attr_reader :values

	NEW_FISH_COUNTDOWN = 8
	OLD_FISH_COUNTDOWN = 6


	def initialize(values)
		@values = values
	end


	def number_of_fish_after(days)
		# calculate lifetime for each possible starting value
		age_descendants = {}
		(1..5).each do |i|
			age_descendants[i] = descendants_for_fish_at(i, days).length
		end

		puts "how do our descendants look? #{age_descendants}"

		calculate_fish_total(age_descendants)
	end


	def calculate_fish_total(age_descendants_hash)
		values.sum do |v|
			age_descendants_hash[v]
		end
	end


	def descendants_for_fish_at(age, days)
		fish_arr = [age]
		(1..days).each do |d|
			(0...fish_arr.length).each do |i|
				if fish_arr[i] == 0
					fish_arr[i] = apply_birth_rule
					fish_arr << new_fish_rule
				else
					fish_arr[i] -= 1
				end
			end
			puts "end of day: #{d}"
			puts "fish so far: #{fish_arr.length}"
		end
		fish_arr
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
number_fish = Lanternfish.new(values).number_of_fish_after(256)
puts "number of fish after 256 days: #{number_fish}"
