class SevenSegment

	#			  [0]
	#				 -
	#	 [1] |   | [2]
	#			  [3]
	#			   -
	#	 [4] |   | [5]
	#			   -
	#       [6]

	attr_reader :signals_output

	def initialize(signals_output)
		@signals_output = signals_output
	end


	def add_unique_segments
		sum = 0
		signals_output.each_value do |outputs|
			sum += outputs.sum do |output|
				decrypt_one_output(output) > 0 ? 1 : 0
			end
		end
		sum
	end


	def add_output_values
		signals_output.sum do |signals, output|
			decrypted_array = SignalDecrypter.new(signals).decrypt_signals
			puts "the decrypted array is: #{decrypted_array}"
			# decrypt outputs
		end
	end


private

	# solution 1
	def decrypt_one_output(single_output)
		results = value_checks.map do |func|
			func.call(single_output)
		end

		results.find { |res| !res.nil? } || 0
	end


	# used in solution 1
	def value_checks
		@value_checks ||= begin
			[
			one   = -> (out) { 1 if out.length == 2 },
			four  = -> (out) { 4 if out.length == 4 },
			seven = -> (out) { 7 if out.length == 3 },
			eight = -> (out) { 8 if out.length == 7 }
			]
		end
	end


	class SignalDecrypter

		ALL_SEGMENTS = 'abcdefg'

		attr_reader :signals

		def initialize(signals)
			@signals = signals
		end


		def decrypt_signals
			signal_indices = [-1, -1, -1, -1, -1, -1, -1]

			signal_indices[0] = find_zero_index
			signal_indices[2], signal_indices[4], signal_indices[5] = find_two_four_five_indices
			signal_indices[1] = find_one_index
			signal_indices[3] = find_three_index
			signal_indices[6] = find_six_index(signal_indices)
			signal_indices
		end


		def zero_signal
			@zero_signal ||= six_nine_zero_signals.find { |sig| sig != six_signal && sig != nine_signal }
		end


		def one_signal
			@one_signal ||= signals.find { |sig| sig.length == 2 }
		end


		def two_signal
			@two_signal ||= two_three_five_signals.select { |sig| (nine_signal.split('') - sig.split('')).length == 2 }.first
		end


		def three_signal
			@three_signal ||= \
				two_three_five_signals.select { |sig| (sig.split('') - one_signal.split('')).length == 3 }.first
		end


		def four_signal
			@four_signal ||= signals.find { |sig| sig.length == 4 }
		end


		def five_signal
			@five_signal ||= (two_three_five_signals - [two_signal, three_signal]).first
		end


		def two_three_five_signals
			@two_three_five_signals ||= signals.select { |sig| sig.length == 5 }
		end


		def six_nine_zero_signals
			@six_nine_zero_signals ||= signals.select { |sig| sig.length == 6 }
		end


		def six_signal
			@six_signal ||= six_nine_zero_signals.find { |sig| (sig.split('') - one_signal.split('')).length == 5 }
		end


		def seven_signal
			@seven_signal ||= signals.find { |sig| sig.length == 3 }
		end


		def nine_signal
			@nine_signal ||= \
				six = six_signal # some weird memoization problem here
				zero_nine = six_nine_zero_signals.reject { |sig| sig == six_signal }
				zero_nine.select { |sig| (sig.split('') - four_signal.split('')).length == 2 }.first
		end


		def find_zero_index
			# 'dab' - 'ab' = 'd'
			(seven_signal.split('') - one_signal.split('')).first
		end


		def find_one_index
			(five_signal.split('') - two_signal.split('') - one_signal.split('')).first
		end


		def find_three_index
			# 'bcdf' - 'abcefg' = 'd'
			(four_signal.split('') - zero_signal.split('')).first
		end


		def find_two_four_five_indices
			four_index = (six_signal.split('') - nine_signal.split('')).first
			two_index = (one_signal.split('') - six_signal.split('')).first
			five_index = (one_signal.split('') - [two_index]).first
			return two_index, four_index, five_index
		end


		def find_six_index(signal_indices)
			# 'abcdefg' - 'abcdef'
			(ALL_SEGMENTS.split('') - signal_indices).first
		end

	end
end


require_relative '../utils/file_parser'

signals_output = FileParser.new('day_8_input.txt').parse_spaces_with_line
sev = SevenSegment.new(signals_output)
puts "the sum of all known segments (1, 4, 7, 8) is: #{sev.add_unique_segments}"

# day 2 solution
sev.add_output_values
