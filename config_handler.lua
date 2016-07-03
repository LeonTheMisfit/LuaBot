local config_handler = {}

local flags = {}

function config_handler.load_flags()
  for _, flag in ipairs(arg) do
    local split = util.split(flag, "=")
    flags[split[1]] = split[2]
  end
end

function config_handler.load_file()
  config = dofile("config.lua")
  for flag,val in pairs(flags) do
    config[flag] = val
  end
end

return config_handler
