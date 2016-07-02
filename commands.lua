local commands = {}

function commands.PING(msg)
  client:send(factory.pong(msg.params[1]))
end

local join = false
commands["004"] = function(msg)
  if not join then
    for _, chan in ipairs(config.chans) do
      client:send(factory.join(chan))
    end
    join = true
  end
end

function commands.ERROR(msg)
  run = false
end

function commands.PRIVMSG(msg)
  log.chat_message(msg)
  local cmd = util.split(msg.params[2], " ")[1]
  if plugin.check(cmd) then
    plugin.run(cmd, msg)
  end
end

function commands.NOTICE(msg)
  commands.PRIVMSG(msg)
end

return commands
