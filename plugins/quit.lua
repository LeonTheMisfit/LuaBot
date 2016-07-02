local plugin = {}

local quits = {
  ["--quit"] = "I must leave you",
}

function plugin.get_commands()
  return { "--quit" }
end

function plugin.handle_command(cmd, msg)
  if util.has(config.chans, msg.params[1]) then
    local message = quits[cmd]
    outbound:push(factory.quit(message))
    run = false
  end
end

return plugin
