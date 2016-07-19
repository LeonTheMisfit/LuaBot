local function is_channel_admin(user)
  return util.any(config.chans, function(chan)
    return user.host:find(util.remove_char(chan, "#"))
  end)
end

local function is_user_admin(user)
  if user.host:find("snoonet/") then
    return true
  elseif is_channel_admin(user) then
    return true
  elseif user.host:find("user/") then
    if util.has(config.admins, user.nick) or util.has(config.admins, user.user) then
      return true
    end
  end
  return false
end

local plugin_handler = {}

local plugins = {}
local plugin_lut = {}

function plugin_handler.load()
  log.system(log.events.INFO, "Loading plugins.")
  plugins = {}
  plugin_lut = {}
  for file in lfs.dir("plugins/") do
    if file ~= "." and file ~= ".." then
      plugins[#plugins+1] = dofile("plugins/" .. file)
      for _, cmd in ipairs(plugins[#plugins].get_commands()) do
        plugin_lut[cmd] = #plugins
      end
    end
  end
end

function plugin_handler.check(cmd, msg)
  if plugin_lut[cmd] then
    local user = parser.parse_user(msg.prefix)
    if not plugins[plugin_lut[cmd]].is_admin() or is_user_admin(user) then
      return true
    end
  end
  return false
end

function plugin_handler.run(cmd, msg, id)
  plugins[plugin_lut[cmd]].handle_command(cmd, msg, id)
end

return plugin_handler
