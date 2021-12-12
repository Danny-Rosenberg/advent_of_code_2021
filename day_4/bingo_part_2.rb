class Bingo2

	INPUT = "day_4_input.txt"
	WINNING_LINE = ['x', 'x', 'x', 'x', 'x']
	MARK = 'x'

	attr_reader :lines, :numbers, :boards

	def initialize
		parse_file
	end


	# run the game until all boards have won except one
	def run_anti_game
		eligible_boards_remaining = (0...boards.length).to_a
		final_board = []
		numbers.each do |num|
			execute_turn(num)
			winner_indices = find_winning_boards(eligible_boards_remaining)
			if winner_indices.length == 1 && eligible_boards_remaining.length == 1
				final_board = boards[eligible_boards_remaining.last]
			else
				winner_indices.each { |i| eligible_boards_remaining.delete(i) }
				winner_indices = []
			end

			if !final_board.empty?
				puts "what's our board? #{boards[eligible_boards_remaining.last]}"
				puts "what's the called number? #{num}"
				puts "Score of the losing-est board is: #{calculate_score(boards[eligible_boards_remaining.last], num)}"
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


	def find_winning_boards(eligible_board_indices)
		winning_boards = []
		(0...boards.length).each do |b|
			unless eligible_board_indices.include?(b)
				next
			end
			# check rows
			boards[b].each do |line|
				if line == WINNING_LINE
					winning_boards << b
				end
			end

			# check columns
			(0...boards[b].length).each do |x|
				column = []
				(0...boards[b].length).each do |y|
					column << boards[b][y][x] # row changes, column stays the same
				end
				if column == WINNING_LINE
					winning_boards << b unless winning_boards.include?(b)
				end
			end
		end
		winning_boards
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

bingo = Bingo2.new
bingo.run_anti_game
