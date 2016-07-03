local handler = {}

function handler.run()
  while true do
    local raw = inbound:pop()
    if raw and raw ~= "" then
      local msg = parser.parse_message(raw)
      log.raw_message(msg.uuid, os.time(), raw)
      if commands[msg.command] then
        dispatcher.add_thread(commands[msg.command], msg)
        break
      end
    else
      break
    end
  end
end

return handler
