local _plugin = {}

function _plugin.get_commands()
  return { "--reload" }
end

function _plugin.handle_command(cmd, msg)
  if util.has(config.chans, msg.params[1]) then
    plugin.load()
    local message = factory.action("reloads plugins.")
    for _, chan in ipairs(config.chans) do
      outbound:push(factory.message(chan, message))
    end
  end
end

function _plugin.is_admin()
  return true
end

return _plugin
