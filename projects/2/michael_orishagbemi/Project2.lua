if #arg < 2 then
    print("Usage: lua greet.lua <name> <number>")
    os.exit(1)
end

local name = arg[1]
local count = tonumber(arg[2])

if not count or count <= 0 then
    print("Please provide a valid positive integer for <number>.")
    os.exit(1)
end

for i = 1, count do
    print("Hello, " .. name .. "!")
end