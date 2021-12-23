class Lanternfish2

	attr_reader :values, :starting_count

	NEW_FISH_COUNTDOWN = 8
	OLD_FISH_COUNTDOWN = 6
	GIVEN_VALUES = [3, 4, 3, 1, 2]
  GIVEN_SUM = 26984457539


	def initialize(values)
		@values = values
		remove_known_values
		puts "we have removed known values from problem set"
	end


	def number_of_fish_after(days)
		puts "we're calculating the fish population after 100 days"
		starting_fish_array = descendants_for_fish_at(values, days - 156)

		puts "now we're calculating the descendant population of every fish age possibility"
		puts "for 156 years"
		age_descendants = calculate_descendants_per_age(156)
		puts "how do age descendants look before final sum? #{age_descendants}"
		puts "now we'll take the 100 day fish population and add a # of fish for each one to our total,"
		puts "based on the descendant populations we calculated in the previous step"
		calculate_fish_total(age_descendants, starting_fish_array) + starting_count
	end


	def calculate_descendants_per_age(days)
		# calculate lifetime for each possible starting value (i.e. 0 - 8)
		age_descendants = {}
		(0..8).each do |i|
			age_descendants[i] = descendants_for_fish_at(i, days).length
		end
		age_descendants
	end


	def calculate_fish_total(age_descendants_hash, starting_fish_array)
		puts "length of starting fish array: #{starting_fish_array.length}"
		starting_fish_array.sum do |v|
			age_descendants_hash[v]
		end
	end


	def descendants_for_fish_at(age, days)
		fish_arr = [age].flatten
		(1..days).each do |d|
			(0...fish_arr.length).each do |i|
				if fish_arr[i] == 0
					fish_arr[i] = apply_birth_rule
					fish_arr << new_fish_rule
				else
					fish_arr[i] -= 1
				end
			end
		end
		fish_arr
	end


	# optimization to reduce problem size:
	# given that 3,4,3,1,2 yields 26984457539, calculate
	# all occurrences of the pattern and remove them from values set
	def remove_known_values
		full_matches = 0
		more_matches = true
		while more_matches
			matched = []
			given_copy = GIVEN_VALUES.dup
			GIVEN_VALUES.each do |v|
				deleted = values.delete_at(values.index(v) || values.length)
				if deleted.nil?
					# restore values that were deleted but didn't have a full match
					values << matched unless matched.empty?
					more_matches = false
					break
				end
				matched << v
				given_copy.delete_at(given_copy.index(v))
				if given_copy.empty?
					full_matches += 1
					matches = []
				end
			end
		end
		@starting_count = full_matches * GIVEN_SUM
	end


	def new_fish_rule
		NEW_FISH_COUNTDOWN
	end


	def apply_birth_rule
		OLD_FISH_COUNTDOWN
	end

end


require_relative '../utils/file_parser'

# first generate array of all fish after 156 days
# then calculate number of fish descendants between ages 0 - 8 for 100 days, create a hash
# finally, loop through 156 day fish array, for each value sum the corresponding age
# with its value in the hash

values = FileParser.new('day_6_input.txt').parse_single_row_csv

lantern2 = Lanternfish2.new(values)
total_number_fish = lantern2.number_of_fish_after(256)
puts "total number of fish after 256 days: #{total_number_fish}"
