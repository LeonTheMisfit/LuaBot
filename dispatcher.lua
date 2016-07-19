local dispatcher = {}

dispatcher.__threads = {}
dispatcher.__threadids = {}

function dispatcher.receive()
  local data, status
  repeat
    data, status = client:receive("*l")
    if data and data ~= "" then
      inbound:push(data)
    end
  until status == "timeout"
end

function dispatcher.send()
  local i = 0
  while i < config.send_limit and outbound:count() > 0 do
    local msg = outbound:pop()
    if msg and msg ~= "" then
      client:send(msg)
      i = i + 1
      util.sleep(1)
    end
  end
end

function dispatcher.add_thread(func, arg)
  local cnt = #dispatcher.__threads + 1
  local id = uuid.generate(4)
  dispatcher.__threads[cnt] = coroutine.create(id, function()
    func(arg, id)
  end)
  dispatcher.__threadids[id] = dispatcher.__threads
  return cnt, id
end

function dispatcher.run()
  local threads = {}
  local threadids = {}
  for _, thread in ipairs(dispatcher.__threads) do
    if coroutine.status(thread) ~= "dead" then
      local success, error = coroutine.resume(thread)
      if not success then
        log.system(log.events.CRERR, error)
      end
    end
    if coroutine.status(thread) ~= "dead" then
      threads[#threads+1] = thread
      threadids[thread.id] = thread
    end
  end
  dispatcher.__threads = threads
  dispatcher.__threadids = threadids
end

function dispatcher.stop(id)
  local thread = dispatcher.__threadids[id]
  if thread then
    if coroutine.status(thread) ~= "dead" then
      coroutine.resume(thread, "STOP")
    end
  end
end

return dispatcher
