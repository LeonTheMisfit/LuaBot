local parser = {}

function parser.parse_message(msg)
  local chars = util.explode(msg)
  local parts = { builder:new(), builder:new(), {} }
  local part_index = 2
  local param_index = 0
  local final_param = false

  for i, char in ipairs(chars) do
    if char == ":" then
      if i ~= 1 and part_index == 3 then
        final_param = true
      elseif i == 1 then
        part_index = 1
      end
    elseif char == " " then
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
    else
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
  end

  for i, param in ipairs(parts[3]) do
    parts[3][i] = param.string
  end

  return {
    prefix = parts[1].string,
    command = parts[2].string,
    params = parts[3]
  }
end

return parser
