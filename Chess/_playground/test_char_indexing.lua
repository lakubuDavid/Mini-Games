-- Test character indexing and __index metamethod
local Strings = require("lib.strings")

print("=== Testing Strings Character Indexing ===\n")

local str = Strings:new("hello")

print("Test 1: Basic character indexing")
print("String: 'hello'")
print("str[1] = '" .. (str[1] or "nil") .. "' (expected: 'h')")
print("str[2] = '" .. (str[2] or "nil") .. "' (expected: 'e')")
print("str[3] = '" .. (str[3] or "nil") .. "' (expected: 'l')")
print("str[4] = '" .. (str[4] or "nil") .. "' (expected: 'l')")
print("str[5] = '" .. (str[5] or "nil") .. "' (expected: 'o')")

print("\nTest 2: Out of bounds indexing")
print("str[0] = " .. tostring(str[0]) .. " (expected: nil)")
print("str[6] = " .. tostring(str[6]) .. " (expected: nil)")
print("str[999] = " .. tostring(str[999]) .. " (expected: nil)")

print("\nTest 3: Negative indexing (not supported, expected nil)")
print("str[-1] = " .. tostring(str[-1]) .. " (expected: nil)")

print("\nTest 4: Method lookup still works (access through __index)")
print("str:upper() works: " .. tostring(str:upper() == Strings:new("HELLO")))
print("str:len() = " .. str:len() .. " (expected: 5)")

print("\nTest 5: Character indexing with single char string")
local single = Strings:new("x")
print("Single char string 'x':")
print("single[1] = '" .. (single[1] or "nil") .. "' (expected: 'x')")

print("\nTest 6: Character indexing with empty string")
local empty = Strings:new("")
print("Empty string:")
print("empty[1] = " .. tostring(empty[1]) .. " (expected: nil)")

print("\nTest 7: Iterating through string using numeric indexing")
local test = Strings:new("abc")
local result = ""
for i = 1, test:len() do
  result = result .. test[i]
end
print("Concatenated via indexing: '" .. result .. "' (expected: 'abc')")

print("\n✓ All character indexing tests completed!")
