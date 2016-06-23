local plugin = {}

function plugin.get_commands()
  return { "--reload" }
end

function plugin.handle_command(cmd, msg)
  if util.has(config.chans, msg.params[1]) then
    load_plugins()
    local message = factory.action("reloads plugins.")
    for _, chan in ipairs(config.chans) do
      outbound:push(factory.message(chan, message))
    end
  end
end

function plugin.tick() end

return plugin
