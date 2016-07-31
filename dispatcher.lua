local dispatcher = {}

dispatcher.__threads = {}
dispatcher.__threadids = {}
dispatcher.thread_count = 0

function dispatcher.__count_check(n)
  return inbound:count() <= n and
    outbound:count() <= n and
    dispatcher.thread_count <= n
end

function dispatcher.receive()
  if dispatcher.__count_check(0) then
    client:settimeout(-1)
  elseif dispatcher.__count_check(5) then
    client:settimeout(1)
  else
    client:settimeout(0)
  end

  local data, status
  repeat
    data, status = client:receive("*l")
    if data and data ~= "" then
      inbound:push(data)
      client:settimeout(0)
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
  dispatcher.thread_count = dispatcher.thread_count + 1
  return cnt, id
end

function dispatcher.run()
  local threads = {}
  local threadids = {}
  local thread_count = 0
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
      thread_count = thread_count + 1
    end
  end
  dispatcher.__threads = threads
  dispatcher.__threadids = threadids
  dispatcher.thread_count = thread_count
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
