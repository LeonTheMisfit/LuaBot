local commands = {}

function commands.PING(msg)
  client:send(factory.pong(msg.params[1]))
  log.system(log.events.INFO, "Responded to ping.")
end

local join = false
commands["004"] = function(msg)
  if not join then
    for _, chan in ipairs(config.chans) do
      client:send(factory.join(chan))
    end
    join = true
    log.system(log.events.INFO, "Channels joined.")
  end
end

function commands.ERROR(msg)
  run = false
  log.system(log.events.ERR, "Server sent an error response.")
end

function commands.PRIVMSG(msg, id)
  log.chat_message(msg)
  local cmd = util.split(msg.params[2], " ")[1]
  if plugin_handler.check(cmd, msg) then
    plugin_handler.run(cmd, msg, id)
  end
end

function commands.NOTICE(msg, id)
  commands.PRIVMSG(msg, id)
end

function commands.INVITE(msg, id)
  config.chans[#config.chans+1] = msg.params[2]
  outbound:push(factory.join(msg.params[2]))
end

return commands
