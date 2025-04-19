name = ARGV[0]?
count = ARGV[1]?.try &.to_i?

if name.nil? || count.nil? || count <= 0
  puts "Usage: ./hello <name> <number> (number must be a positive integer)"
  exit(1)
end

count.times { puts "Hello #{name}" } # times amounts to basically a for loop for the amount of times specified