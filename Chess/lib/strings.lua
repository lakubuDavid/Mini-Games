local Strings = { ___className = "Strings" }

function Strings:new(content)
  local instance = {}
  if type(content == "table") and
      content.___className ~= nil and
      content.___className == "Strings" then
    instance = {
      str = content.str
    }
  elseif type(content) == "nil" then
    instance = {
      str = ""
    }
  else
    instance = { str = tostring(content) }
  end
  setmetatable(instance, self)
  return instance
end

function Strings:__index(key)
  -- Numeric indexing for character access (1-based)
  if type(key) == "number" then
    if key >= 1 and key <= #self.str then
      return self.str:sub(key, key)
    end
    return nil
  end
  -- Method/property lookup
  return rawget(Strings, key)
end

function Strings:__tostring()
  return self.str
end

function Strings:__len()
  return self:len()
end

function Strings:__concat(a, b)
  return Strings:new(tostring(a) .. tostring(b))
end

function Strings:__pairs()
  local index = 0
  local len = #self.str
  local str = self.str
  return function(_, k)
    if k == nil then
      k = 0
    end
    k = k + 1
    if k <= len then
      return k, str:sub(k, k)
    end
  end, self, nil
end

function Strings:__eq(b)
  if type(b) == "table" and
      b.___className and
      b.___className == "Strings" then
    return self.str == b
  else
    return self.str == tostring(b)
  end
end

function Strings:chars()
  local index = 0
  local len = #self.str
  local str = self.str
  return function()
    index = index + 1
    if index <= len then
      return Strings:new(str:sub(index, index))
    end
  end
end

-- Basic string operations
function Strings:trim()
  self.str = self.str:gsub("^%s+", ""):gsub("%s+$", "")
  return self
end

function Strings:trimmed()
  local str = self.str:gsub("^%s+", ""):gsub("%s+$", "")
  return Strings:new(str)
end

function Strings:split(separator)
  local parts = {}
  local remaining = self.str

  while remaining ~= "" do
    local from, to, rest = string.find(remaining, separator)

    if not from then
      table.insert(
        parts,
        Strings:new(
          remaining
        )
      )
      break
    end

    table.insert(
      parts,
      Strings:new(string.sub(remaining, 1, from - 1))
    )
    remaining = string.sub(remaining, to + 1)
  end

  return parts
end

function Strings:charAt(index)
  return Strings:new(string.sub(self.str,index,index))
end

-- Split the string based on teh separator and unpack the result
-- Similar t calling `table.unpack(str:split())`
function Strings:usplit(separator)
  return table.unpack(self:split(separator))
end

function Strings:lines()
  local lines = self:split("\n")
  return lines
end

function Strings:isLowerChar()
  local ansii = string.byte(self.str)
  return ansii >= 97 and ansii <= 122
end

function Strings:isUpperChar()
  local ansii = string.byte(self.str)
  return ansii >= 65 and ansii <= 90
end

-- Builtin Lua string methods
function Strings:upper()
  return Strings:new(string.upper(self.str))
end

function Strings:lower()
  return Strings:new(string.lower(self.str))
end

function Strings:len()
  return string.len(self.str)
end

function Strings:length()
  return self:len()
end

function Strings:sub(i, j)
  return Strings:new(string.sub(self.str, i, j))
end

function Strings:substring(i, j)
  return self:sub(i, j)
end

function Strings:find(pattern, init, plain)
  return string.find(self.str, pattern, init, plain)
end

function Strings:match(pattern, init)
  return string.match(self.str, pattern, init)
end

function Strings:gmatch(pattern)
  return string.gmatch(self.str, pattern)
end

function Strings:gsub(pattern, repl, n)
  local result = string.gsub(self.str, pattern, repl, n)
  return Strings:new(result)
end

function Strings:rep(n)
  return Strings:new(string.rep(self.str, n))
end

function Strings:reverse()
  return Strings:new(string.reverse(self.str))
end

function Strings:format(...)
  return Strings:new(string.format(self.str, ...))
end

function Strings:byte(i, j)
  return string.byte(self.str, i, j)
end

function Strings:char(...)
  return Strings:new(string.char(...))
end

-- Utility methods
function Strings:startsWith(prefix)
  return self.str:sub(1, #prefix) == prefix
end

function Strings:endsWith(suffix)
  return self.str:sub(- #suffix) == suffix
end

function Strings:contains(substring)
  return self.str:find(substring, 1, true) ~= nil
end

function Strings:replace(old, new)
  return Strings:new(self.str:gsub(old, new))
end

function Strings:capitalize()
  return Strings:new(self.str:sub(1, 1):upper() .. self.str:sub(2):lower())
end

function Strings:isEmpty()
  return self:len() == 0
end

function Strings:isBlank()
  return self:trimmed():isEmpty()
end

function Strings:isNumeric()
  if self:isEmpty() then
    return false
  end
  local trimmed = self:trimmed().str
  return tonumber(trimmed) ~= nil
end

function Strings:count(pattern)
  local _, count = self.str:gsub(pattern, "")
  return count
end

function Strings:repeated(n)
  return self:rep(n)
end

return Strings
