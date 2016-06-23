local dispatcher = {}

dispatcher.__threads = {}

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
  dispatcher.__threads[cnt] = coroutine.create(function()
    func(arg)
  end)
  return cnt
end

function dispatcher.run()
  local threads = {}
  for _, thread in ipairs(dispatcher.__threads) do
    if coroutine.status(thread) ~= "dead" then
      coroutine.resume(thread)
    end
    if coroutine.status(thread) ~= "dead" then
      threads[#threads+1] = thread
    end
  end
  dispatcher.__threads = threads
end

return dispatcher
