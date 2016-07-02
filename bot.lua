#!/usr/bin/lua

builder = require("builder")
commands = require("commands")
config = require("config")
dispatcher = require("dispatcher")
factory = require("factory")
handler = require("handler")
log = require("log")
parser = require("parser")
plugin = require("plugin")
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
  for _, flag in ipairs(arg) do
    local split = util.split(flag, "=")
    config[split[1]] = split[2]
  end
end

local function connect()
  client:settimeout(0)
  client:connect(config.host, config.port)
end

local function auth()
  util.sleep(1)
  client:send(factory.pass(config.password))
  client:send(factory.nick(config.nick))
  client:send(factory.user(config.nick, config.user))
end

local function loop()
  while run do
    dispatcher.receive()
    handler.run()
    dispatcher.run()
    dispatcher.send()
  end
  client:close()
  log.close_db()
end

local function init()
  load_flags()
  plugin.load()
  log.load_db()
end

init()
connect()
auth()
loop()
