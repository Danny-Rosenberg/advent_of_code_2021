class SevenSegment

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


private


	def decrypt_one_output(single_output)
		results = value_checks.map do |func|
			func.call(single_output)
		end

		results.find { |res| !res.nil? } || 0
	end


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

end


require_relative '../utils/file_parser'

signals_output = FileParser.new('day_8_input.txt').parse_spaces_with_line
sev = SevenSegment.new(signals_output)
puts "the sum of all known segments (1, 4, 7, 8) is: #{sev.add_unique_segments}"
