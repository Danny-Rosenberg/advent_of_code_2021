class Dive2

	FORWARD = 'forward'
	DOWN	  = 'down'
	UP		  = 'up'

	class << self
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
			aim   = 0

			parsed_lines.each do |line|
				if line[0] == FORWARD
					horizontal += line[1]
					depth += (aim * line[1])
				elsif line[0] == DOWN
					aim += line[1]
				else
					aim -= line[1]
				end
			end

			[horizontal, depth]
		end

		def perform_calculations(values)
			values[0] * values[1]
		end
	end

end

lines  = Dive2.parse_file
values = Dive2.calculate_pos_and_depth(lines)
puts "values are: #{values}"
result = Dive2.perform_calculations(values)
puts "Result of multiplying horizontal position and depth: #{result}"
