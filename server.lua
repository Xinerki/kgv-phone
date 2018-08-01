AddEventHandler('chatMessage', function(source, name, message)
	if message:sub(1,6) == '/phone' then
		TriggerClientEvent('phone:phone', source, message)
		CancelEvent()
	end
end)