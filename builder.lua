local Builder = {
  string = ""
}

function Builder:append(str)
  self.string = self.string .. tostring(str)
end

function Builder:prepend(str)
  self.string = tostring(str) .. self.string
end

function Builder:new()
  local builder = {}
  setmetatable(builder, self)
  self.__index = self
  builder.string = ""
  return builder
end

return Builder
