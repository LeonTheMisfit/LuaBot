local plugin = {}

function plugin.get_commands()
  return { "--stop" }
end

function plugin.handle_command(cmd, msg)
  if util.has(config.chans, msg.params[1]) then
    local _, id = table.unpack(util.split(msg.params[2], " "))
    dispatcher.stop(id)
  end
end

function plugin.is_admin()
  return false
end

return plugin
