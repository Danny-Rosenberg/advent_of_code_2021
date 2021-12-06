class Dive1

	FORWARD = 'forward'
	DOWN	  = 'down'
	UP		  = 'up'

	# Read lines and split on space
	def parse_file
		lines = []

		File.foreach("day_2_input.txt") do |line|
			line = line.split(' ')
			line[1] = line[1].to_i
			lines << line
		end

		lines
	end


	def calculate_pos_and_depth(parsed_lines)
		horizontal = 0
		depth = 0

		parsed_lines.each do |line|
			if line[0] == FORWARD
				horizontal += line[1]
			elsif line[0] == DOWN
				depth += line[1]
			else
				depth -= line[1]
			end
		end

		[horizontal, depth]
	end

	def perform_calculations(values)
		values[0] * values[1]
	end

end

dive = Dive1.new

lines  = dive.parse_file
values = dive.calculate_pos_and_depth(lines)
puts "values are: #{values}"
result = dive.perform_calculations(values)
puts "Result of multiplying horizontal position and depth: #{result}"
