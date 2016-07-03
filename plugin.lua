local function is_user_admin(user)
  if user.hostmask == "snoonet" then
    return true
  elseif user.hostmask == "user" then
    if util.has(config.admins, user.username) then
      return true
    end
  end
  return false
end

local plugin = {}

local plugins = {}
local plugin_lut = {}

function plugin.load()
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

function plugin.check(cmd, msg)
  if plugin_lut[cmd] then
    local user = parser.parse_user(msg.prefix)
    if not plugins[plugin_lut[cmd]].is_admin() or is_user_admin(user) then
      return true
    end
  end
  return false
end

function plugin.run(cmd, msg)
  plugins[plugin_lut[cmd]].handle_command(cmd, msg)
end

return plugin
