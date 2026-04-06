-- Test both __pairs() and chars() implementations
local Strings = require("lib.strings")

print("=== Testing Strings Iterator Implementations ===\n")

local str = Strings:new("hello")

print("Test 1: Using chars() with for...in loop")
print("String: 'hello'")
print("Result:")
for char in str:chars() do
  print("  char: " .. char)
end

print("\nTest 2: Using pairs() with for...in loop")
print("String: 'hello'")
print("Result:")
for index, char in pairs(str) do
  print("  [" .. index .. "]: " .. char)
end

print("\nTest 3: Empty string with chars()")
local empty = Strings:new("")
local count = 0
for char in empty:chars() do
  count = count + 1
end
print("Empty string iteration count: " .. count .. " (expected: 0)")

print("\nTest 4: Single character with chars()")
local single = Strings:new("x")
for char in single:chars() do
  print("Single char: " .. char)
end

print("\nTest 5: Concatenating chars from iterator")
local test = Strings:new("abc")
local result = ""
for char in test:chars() do
  result = result .. char
end
print("Concatenated result: '" .. result .. "' (expected: 'abc')")

print("\n✓ All tests completed successfully!")
