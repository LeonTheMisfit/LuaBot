local url = require("socket.url")
local http = require("socket.http")

local function get_flag(time, chan)
  local lines = {}
  local query = string.format([[
    SELECT
       r.timestamp AS timestamp
      ,c.prefix AS user
      ,c.message AS message
    FROM
      chat_log AS c
    LEFT JOIN
      raw_messages AS r
    ON
      c.uuid = r.uuid
    WHERE
      r.timestamp > %i AND c.recipient = '%s'
  ]], time, chan)
  local res = log.conn:execute(query)
  if res then
    local row = res:fetch({}, "a")
    while row do
      local line = string.format(
        "[%s] %s: %s", row.timestamp, row.user, row.message)
      lines[#lines+1] = line
      row = res:fetch(row, "a")
    end
  else
    log.system(log.events.ERR, "An error occurred when querying the DB.")
  end
  return lines
end

local function param_to_string(params)
  local str = ""
  for k,v in pairs(params) do
    if str ~= "" then
      str = str .. "&"
    end
    str = str .. k .. "=" .. v
  end
  return str
end

local pastebin = "http://pastebin.com/api/api_post.php"
local function paste(chan, lines)
  local line = "LOGS FOR " .. chan .. "\r\n\r\n"
  for _,l in ipairs(lines) do
    line = line .. l .. "\r\n"
  end
  local params = {
    api_option = "paste",
    api_dev_key = config.pastebin_key,
    api_paste_code = url.escape(line),
    api_paste_name = "chatlogs",
    api_paste_expire_date = "1W"
  }
  local resp = http.request(pastebin, param_to_string(params))
  return resp
end

local plugin = {}

local history = {}

function plugin.get_commands()
  return { "--flag" }
end

function plugin.handle_command(cmd, msg)
  local chan = msg.params[1]
  local user = msg.prefix
  if util.has(config.chans, chan) then
    local log_msg = "OP flag in channel " .. chan .. " from user " ..user
    log.system(log.events.FLAG, log_msg)
    if not history[chan] or history[chan] + config.flag_time < os.time() then
      history[chan] = os.time()
      local back_time = os.time() - config.flag_time
      local lines = get_flag(back_time, chan)
      local url = paste(chan, lines)
      outbound:push(factory.message(chan, "Chat history has been grabbed. " .. url))
      log.system(log.events.INFO, "Chat history: " .. url)
    else
      outbound:push(factory.message(chan, "Flag is still in a cool down."))
    end
  end
end

function plugin.is_admin()
  return false
end

return plugin
