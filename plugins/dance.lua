local plugin = {}

local delim = string.char(0x01)

function plugin.get_commands()
  return { delim .. "ACTION" }
end

function plugin.handle_command(cmd, msg)
  if util.has(config.chans, msg.params[1]) then
    if msg.params[2]:find("dances") then
      local ctcp = factory.action("dances")
      outbound:push(factory.message(msg.params[1], ctcp))
    end
  end
end

return plugin
