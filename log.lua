local sql = require("luasql.sqlite3").sqlite3()

local log = {}

log.events = {
  INFO = "info",
  ERR = "error",
  WARN = "warning",
  FLAG = "opflag",
  CRERR = "coroutineerror",
}

log.conn = {}

function log.load_db()
  log.conn = sql:connect(config.db_file)
end

function log.close_db()
  log.conn:commit()
  log.conn:close()
end

function log.raw_message(uuid, timestamp, msg)
  local query = string.format([[
    INSERT INTO raw_messages(uuid, timestamp, message)
    VALUES ('%s', %i, '%s')
  ]], uuid, timestamp, msg)
  log.conn:execute(query)
end

function log.chat_message(msg)
  local query = string.format([[
    INSERT INTO chat_log(uuid, prefix, command, recipient, message)
    VALUES ('%s', '%s', '%s', '%s', '%s')
  ]], msg.uuid, msg.prefix, msg.command, msg.params[1], msg.params[2])
  log.conn:execute(query)
end

function log.system(event, message)
  message = message:gsub("'", "''")
  local query = string.format([[
    INSERT INTO system_log(uuid, timestamp, event_type, message)
    VALUES ('%s', %i, '%s', '%s')
  ]], uuid.generate(), os.time(), event, message)
  log.conn:execute(query)
end

return log
