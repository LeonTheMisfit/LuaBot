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

return util
