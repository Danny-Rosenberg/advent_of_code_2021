lines = []
# convert to ints, for convenience
File.foreach("day_1_input.txt") { |line| lines << line.to_i }

WINDOW_SIZE = 3
count = 0

prev = lines.first(WINDOW_SIZE).sum
for num in WINDOW_SIZE..lines.length - 1
	sum = prev - lines[num - WINDOW_SIZE] + lines[num]
	if sum > prev
		count += 1
	end
	prev = sum
end

puts "How many sums are larger than the previous sum? #{count}"
