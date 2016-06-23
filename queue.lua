local Queue = {
  __queue = {}
}

function Queue:push(msg)
  local cnt = #self.__queue + 1
  self.__queue[cnt] = msg
  return cnt
end

function Queue:pop()
  local cnt = #self.__queue
  if cnt > 0 then
    local msg = self.__queue[1]
    table.remove(self.__queue, 1)
    return msg
  end
end

function Queue:count()
  return #self.__queue
end

function Queue:new()
  local queue = {}
  setmetatable(queue, self)
  self.__index = self
  queue.__queue = {}
  return queue
end

return Queue
