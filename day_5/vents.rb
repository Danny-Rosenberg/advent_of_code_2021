class Vents
	require_relative 'file_parser'

	# indices of single set of hydrothermal vents (a 4 element array)
	X1 = 0
	Y1 = 1
	X2 = 2
	Y2 = 3

	HOR = 'hor'
	VER = 'ver'

	ADD = '+'
	SUB = '-'

	# lines where at least n lines overlap
	OVERLAP = 2

	attr_reader :lines, :graph, :with_diagonal

	def initialize(with_diagonal = false)
		@lines =  FileParser.parse

		dimension = lines.flatten.max + 1
		@graph = Array.new(dimension) { Array.new(dimension, 0) }
		@with_diagonal = with_diagonal
	end


	def find_overlaps
		lines.each do |line|
		  increment_graph_at_points(line)
		end
		calculate_overlaps
	end


private


	def increment_graph_at_points(line)
		marks = marks_for(line)
		marks.each do |l|
			graph[l[0]][l[1]] += 1
		end
	end


	def marks_for(line)
		if direction_for(line) == HOR
			start  = ([line[X1], line[X2]]).min
			finish = ([line[X1], line[X2]]).max
			(start..finish).map do |i|
				[i, line[Y1]]
			end
		elsif direction_for(line) == VER
			start  = ([line[Y1], line[Y2]]).min
			finish = ([line[Y1], line[Y2]]).max
			(start..finish).map do |i|
				[line[X1], i]
			end
		else # it is diagonal
			if with_diagonal
				length = length_of_diagonal(line)

				# determine direction of line
				x_operator = line[X1] > line[X2] ? SUB : ADD
				y_operator = line[Y1] > line[Y2] ? SUB : ADD

				marks = []
				(0..length).each do |i|
					marks << [line[X1].send(x_operator, i), line[Y1].send(y_operator, i)]
				end
				marks
			else
				[]
			end
		end
	end


	def calculate_overlaps
		count = 0
		(0...graph.length).each do |x|
			(0...graph.length).each do |y|
				count +=1 if graph[x][y] >= OVERLAP
			end
		end
		count
	end


  def direction_for(line)
		x_diff = line[X1] - line[X2]
		y_diff = line[Y1] - line[Y2]

		if x_diff != 0 && y_diff != 0
			nil # diagonal line
		else
			x_diff != 0 ? HOR : VER
		end
	end


	def length_of_diagonal(line)
		(line[X1] - line[X2]).abs
	end

end

vent = Vents.new
puts "The number of at least 2 overlaps without diagonals: #{vent.find_overlaps}"
vent = Vents.new(with_diagonal: true)
puts "The number of at least 2 overlaps including diagonals: #{vent.find_overlaps}"
