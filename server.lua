AddEventHandler('chatMessage', function(source, name, message)
	if message:sub(1,6) == '/phone' then
		TriggerClientEvent('phone:phone', source, message)
		CancelEvent()
	end
end)

RegisterNetEvent('phone_server:receiveMessage')
AddEventHandler('phone_server:receiveMessage', function(receiver, name, message, fallback)
	if receiver == 0 then receiver = fallback end
	print(name.." [" ..tostring(source).."] sent a message to "..GetPlayerName(receiver).." ["..tostring(receiver).."]: \""..message.."\"")
	TriggerClientEvent('phone:receiveMessage', receiver, name, message)
end)