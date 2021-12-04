lines = []
# convert to ints, for convenience
File.foreach("day_1_input.txt") { |line| lines << line.to_i }

count = 0
prev = lines.first
lines.each do |num|
	if num > prev
		count += 1
	end
	prev = num
end

puts "How many measurements are larger than the previous measurement? #{count}"
