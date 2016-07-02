local chars = {
  "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
}

local uuid = {}

function uuid.generate(len)
  math.randomseed(os.time())
  len = len or config.idlen
  local id = ""
  for _ = 1, len do
    local c = chars[math.random(1, #chars)]
    id = id .. c
  end
  return id
end

return uuid
