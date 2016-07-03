local plugin = {}

function plugin.get_commands()
  return { "--reload" }
end

function plugin.handle_command(cmd, msg)
  if util.has(config.chans, msg.params[1]) then
    plugin_handler.load()
    local message = factory.action("reloads plugins.")
    for _, chan in ipairs(config.chans) do
      outbound:push(factory.message(chan, message))
    end
  end
end

function plugin.is_admin()
  return true
end

return plugin
