local plugin = {}

function plugin.get_commands()
  return { "--test" }
end

function plugin.handle_command(cmd, msg)
  if util.has(config.chans, msg.params[1]) then
    outbound:push(factory.message(msg.params[1], "This is a test. This is only a test."))
  end
end

return plugin
