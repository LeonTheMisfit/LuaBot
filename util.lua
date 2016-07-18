local util = {}

function util.split(str, sep)
  local parts = {}
  local patt = "([^" .. sep .. "]+)"
  for match in str:gmatch(patt) do
    parts[#parts+1] = match
  end
  if #parts == 0 then
    parts[1] = str
  end
  return parts
end

function util.has(tbl, val)
  for _,v in pairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

function util.sleep(n)
  local start = os.clock()
  while os.clock() < start + n do
    --Burn cycles
  end
end

function util.explode(str)
  local chars = {}
  for i = 1, #str do
    chars[i] = str:sub(i,i)
  end
  return chars
end

function util.any(tbl, func)
  for _, v in pairs(tbl) do
    if func(v) then
      return true
    end
  end
  return false
end

function util.remove_char(str, char)
  local new_string = ""
  for i = 1, #str do
    local c = str:sub(i, i)
    if c ~= char then
      new_string = new_string .. c
    end
  end
  return new_string
end

return util
