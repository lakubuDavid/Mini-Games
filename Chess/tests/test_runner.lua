-- [[
-- Simple Test Runner
-- ]]

local TestRunner = {
  passed = 0,
  failed = 0,
  tests = {}
}

function TestRunner:new()
  local instance = {
    passed = 0,
    failed = 0,
    tests = {}
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function TestRunner:test(name, fn)
  self.tests[#self.tests + 1] = { name = name, fn = fn }
end

function TestRunner:run()
  for _, test in ipairs(self.tests) do
    local success, err = pcall(test.fn)
    if success then
      self.passed = self.passed + 1
      print("[PASS] " .. test.name)
    else
      self.failed = self.failed + 1
      print("[FAIL] " .. test.name .. ": " .. tostring(err))
    end
  end

  print("")
  print(string.format("Results: %d passed, %d failed", self.passed, self.failed))
  return self.failed == 0
end

function TestRunner:reset()
  self.passed = 0
  self.failed = 0
  self.tests = {}
end

return TestRunner