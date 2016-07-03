local parser = {}

function parser.parse_message(msg)
  local chars = util.explode(msg)
  local parts = { builder:new(), builder:new(), {} }
  local part_index = 2
  local param_index = 0
  local final_param = false

  function handle_colon(i)
    if i ~= 1 and part_index == 3 then
      if not final_param then
        final_param = true
      else
        parts[3][param_index]:append(":")
      end
    elseif i == 1 then
      part_index = 1
    end
  end

  function handle_space(i)
    if part_index < 3 then
      part_index = part_index + 1
    else
      if not final_param then
        param_index = param_index + 1
        parts[3][param_index] = builder:new()
      else
        parts[3][param_index]:append(" ")
      end
    end
  end

  function handle_char(i, char)
    if part_index < 3 then
      parts[part_index]:append(char)
    else
      if param_index == 0 then
        parts[3][1] = builder:new()
        param_index = 1
      end
      parts[3][param_index]:append(char)
    end
  end

  for i, char in ipairs(chars) do
    if char == ":" then
      handle_colon(i)
    elseif char == " " then
      handle_space(i)
    else
      handle_char(i, char)
    end
  end

  for i, param in ipairs(parts[3]) do
    parts[3][i] = param.string
  end

  return {
    prefix = parts[1].string,
    command = parts[2].string,
    params = parts[3],
    uuid = uuid.generate()
  }
end

function parser.parse_user(prefix)
  local user = {
    nick = "",
    id = "",
    hostmask = "",
    username = ""
  }

  local chars = util.explode(prefix)
  if util.has(chars, "@") and util.has(chars, "/") then
    local split = util.split(prefix, "@")
    if util.has(chars, "!") then
      local nicksplit = util.split(split[1], "!")
      user.nick = nicksplit[1]
      user.id = nicksplit[2]
    else
      user.nick = split[1]
    end
    if util.has(chars, "/") then
      local hostparts = util.split(split[2], "/")
      user.hostmask = hostparts[1]
      user.username = hostparts[#hostparts]
    else
      user.hostmask = split[2]
    end
  end

  return user
end

return parser
