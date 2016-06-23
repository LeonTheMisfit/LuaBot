local factory = {}

local ctcp_delim = string.char( 0x01 )
local msg_delim = "\r\n"

function factory.action(message)
  return factory.ctcp("ACTION " .. message)
end

function factory.ctcp(message)
  return ctcp_delim .. message .. ctcp_delim
end

function factory.join(channel)
  return "JOIN " .. channel .. msg_delim
end

function factory.nick(nick)
  return "NICK " .. nick .. msg_delim
end

function factory.pass(password)
  return "PASS " .. password .. msg_delim
end

function factory.pong(ping)
  return "PONG " .. ping .. msg_delim
end

function factory.message(recipient, message)
  return "PRIVMSG " .. recipient .. " :" .. message .. msg_delim
end

function factory.quit(message)
  return "QUiT :" .. message .. msg_delim
end

function factory.user(nick, user)
  return "USER " .. nick .. " NULL NULL :" .. user .. msg_delim
end

return factory
