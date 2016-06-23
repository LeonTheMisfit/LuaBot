local parser = {}

local function parse_params(param_string)
  local indx = param_string:find(":")
  local params = {}
  if indx == nil then
    params = util.split(param_string, " ")
  elseif indx == 1 then
    params[1] = param_string:sub(2)
  else
    local parts = util.split(param_string, ":")
    params = util.split(parts[1], " ")
    params[#params+1] = parts[2]
  end
  return params
end

function parser.parse_message(msg)
  local message = {
    prefix = "",
    command = "",
    params = ""
  }

  local fspace = 0
  if msg:sub(1, 1) == ":" then
    fspace = msg:find(" ")
    message.prefix = msg:sub(1, fspace - 1)
  end

  local sspace = msg:find(" ", fspace + 1)
  message.command = msg:sub(fspace + 1, sspace - 1)

  message.params = parse_params(msg:sub(sspace + 1))

  return message
end

return parser
