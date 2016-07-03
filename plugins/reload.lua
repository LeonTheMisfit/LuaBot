local cmds = {}

cmds["--reload"] = function(msg)
  plugin_handler.load()
  local message = factory.action("reloads plugins.")
  for _, chan in ipairs(config.chans) do
    outbound:push(factory.message(chan, message))
  end
end

cmds["--config"] = function(msg)
  config_handler.load_file()
  local message = factory.action("reloads config file.")
  for _, chan in ipairs(config.chans) do
    outbound:push(factory.message(chan, message))
  end
end

local plugin = {}

function plugin.get_commands()
  return { "--reload", "--config" }
end

function plugin.handle_command(cmd, msg)
  if util.has(config.chans, msg.params[1]) then
    cmds[cmd](msg)
  end
end

function plugin.is_admin()
  return true
end

return plugin
