local plugin = {}

function plugin.get_commands()
  return { "--looptest"}
end

function plugin.handle_command(cmd, msg, id)
  if util.has(config.chans, msg.params[1]) then
    outbound:push(factory.message(msg.params[1], "ID: " .. id))
    local i = 0
    repeat
      outbound:push(factory.message(msg.params[1], tostring(i)))
      i = i + 1
    until coroutine.yield() == "STOP"
  end
end

function plugin.is_admin()
  return false
end

return plugin
