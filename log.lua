local sql = require("luasql.sqlite3").sqlite3()

local log = {}

local conn = {}
local curs = {}

function log.load_db()
  conn = sql:connect(config.db_file)
end

function log.close_db()
  conn:commit()
  conn:close()
end

function log.raw_message(uuid, timestamp, msg)
  local query = string.format([[
    INSERT INTO raw_messages(uuid, timestamp, message)
    VALUES ('%s', %i, '%s')
  ]], uuid, timestamp, msg)
  conn:execute(query)
end

function log.chat_message(msg)
  local query = string.format([[
    INSERT INTO chat_log(uuid, prefix, command, recipient, message)
    VALUES ('%s', '%s', '%s', '%s', '%s')
  ]], msg.uuid, msg.prefix, msg.command, msg.params[1], msg.params[2])
  conn:execute(query)
end

return log
