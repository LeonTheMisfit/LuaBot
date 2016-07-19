local cr = coroutine

local comp_cr = {}
comp_cr.id = ""

function comp_cr.resume(thread, ...)
  return cr.resume(thread.__thread, ...)
end

function comp_cr.status(thread, ...)
  return cr.status(thread.__thread, ...)
end

function comp_cr.yield(...)
  return cr.yield(...)
end

function comp_cr.__eq(left, right)
  return left.id and right.id and left.id == right.id
end

function comp_cr.create(id, ...)
  local tbl = {}
  setmetatable(tbl, comp_cr)
  comp_cr.__index = comp_cr
  tbl.id = id
  tbl.__thread = cr.create(...)
  return tbl
end

return comp_cr
