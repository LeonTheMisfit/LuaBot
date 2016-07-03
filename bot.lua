#!/usr/bin/lua

builder = require("builder")
commands = require("commands")
config = require("config")
dispatcher = require("dispatcher")
factory = require("factory")
handler = require("handler")
log = require("log")
parser = require("parser")
plugin_handler = require("plugin_handler")
queue = require("queue")
socket = require("socket")
util = require("util")
uuid = require("uuid")

local lfs = require("lfs")
local socket = require("socket")

inbound = queue:new()
outbound = queue:new()
client = socket.tcp()
run = true

local function load_flags()
  log.system(log.events.INFO, "Loading flags.")
  for _, flag in ipairs(arg) do
    local split = util.split(flag, "=")
    config[split[1]] = split[2]
  end
end

local function connect()
  log.system(log.events.INFO, "Connecting to host.")
  client:settimeout(0)
  client:connect(config.host, config.port)
end

local function auth()
  log.system(log.events.INFO, "Authenticating with server.")
  util.sleep(1)
  client:send(factory.pass(config.password))
  client:send(factory.nick(config.nick))
  client:send(factory.user(config.nick, config.user))
end

local function loop()
  log.system(log.events.INFO, "Starting main loop.")
  while run do
    dispatcher.receive()
    handler.run()
    dispatcher.run()
    dispatcher.send()
  end
  log.system(log.events.INFO, "Bot stopping.")
  client:close()
  log.close_db()
end

local function init()
  log.load_db()
  load_flags()
  plugin_handler.load()
  log.system(log.events.INFO, "Bot initialized.")
end

init()
connect()
auth()
loop()
