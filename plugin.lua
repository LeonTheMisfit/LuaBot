local plugin = {}

local plugins = {}
local plugin_lut = {}

function plugin.load()
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

function plugin.check(cmd)
  if plugin_lut[cmd] then
    return true
  end
  return false
end

function plugin.run(cmd, msg)
  plugins[plugin_lut[cmd]].handle_command(cmd, msg)
end

return plugin
