local Strings = require("...lib.strings")

local str = Strings:new("Hello world I am\n Hieie \n Mekdkdnk")

local parts = str:lines()
print(#parts .. " parts")
for _, part in ipairs(parts) do
  print("part: ", part:trimmed())
end


local shortStr = Strings:new("Hello")

for i,part in ipairs(shortStr:split(" ")) do
  print(i,part)
end

print(shortStr:usplit(" "))

