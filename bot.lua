#!/usr/bin/lua

commands = require("commands")
config = require("config")
dispatcher = require("dispatcher")
factory = require("factory")
handler = require("handler")
parser = require("parser")
queue = require("queue")
util = require("util")

local lfs = require("lfs")
local socket = require("socket")

inbound = queue:new()
outbound = queue:new()
client = socket.tcp()
plugins = {}
run = true

function load_plugins()
  plugins = {}
  for file in lfs.dir("plugins/") do
    if file ~= "." and file ~= ".." then
      plugins[#plugins+1] = dofile("plugins/" .. file)
    end
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
end

load_plugins()
connect()
auth()
loop()
