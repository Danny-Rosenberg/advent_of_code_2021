class Bingo1

	INPUT = "day_4_input.txt"
	WINNING_LINE = [-1, -1, -1, -1, -1]
	MARK = -1

	attr_reader :lines, :numbers, :boards

	def initialize
		parse_file
	end


	def run_game
		numbers.each do |num|
			execute_turn(num)
			winning_board = find_winning_board

			unless winning_board.nil?
				puts "we found a winning board: #{winning_board}"
				puts "Score of the winning board is: #{calculate_score(winning_board, num)}"
				break
			end
		end
	end


	def execute_turn(called_num)
	  boards.each do |board|
			mark_boards!(called_num)
		end
	end


private


	def calculate_score(winning_board, called_num)
		sum = 0

	  (0...winning_board.length).each do |x|
			(0...winning_board.length).each do |y|
				sum += winning_board[x][y] if winning_board[x][y] != MARK
			end
		end

		sum * called_num
	end


	def mark_boards!(called_num)
		(0...boards.length).each do |b|
			(0...boards[b].length).each do |x|
				(0...boards[b].length).each do |y|
					if boards[b][x][y] == called_num
						boards[b][x][y] = MARK
					end
				end
			end
		end
	end


	def find_winning_board
		boards.each do |board|
			# check rows
			board.each do |line|
				if line == WINNING_LINE
					puts "hit a row win"
					return board
				end
			end

			# check columns
			(0...board.length).each do |x|
				column = []
				(0...board.length).each do |y|
					column << board[x][y]
				end
				if column == WINNING_LINE
					puts "hit a column win"
					return board
				end
			end
		end
		nil
	end


	def parse_file
		@lines = []

		File.foreach(INPUT) do |line|
			line.chomp! # remove newline character
			line = line.split(' ')
			@lines << line
		end

		@numbers = extract_numbers(lines)
		@boards  = extract_boards(lines)
	end


	# returns an array of numbers (strings)
	def extract_numbers(arr)
		arr.first.first.split(',').map(&:to_i)
	end


	def extract_boards(arr)
		arrays = []
		current_board = []

		# remove the array of numbers and a newline
		@lines[2..-1].each do |line|
			# we've hit a new board when we hit a new line
			if line.empty?
				arrays << current_board
				current_board = []
			else
				current_board << line.map(&:to_i) # convert to ints for convenience
			end
		end
		arrays
	end

end

bingo = Bingo1.new
bingo.run_game
