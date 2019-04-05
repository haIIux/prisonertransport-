leo = {
	"steam:1100001018d0707",
}

--[[RegisterCommand('jail', function(source, args)
    local jailedPlayer = tonumber(args[1])
	local jailTime = tonumber(args[2] * 60)
		for i = 1, #leo do
			if GetPlayerIdentifiers(source)[1] == leo[i] then
				TriggerClientEvent('jailPlayer', jailedPlayer, jailTime)
				print("Triggering Server Side.")
				--TriggerClientEvent('chat:addMessage', 1, { args = { '^1Judge Thundercock', 'has been sent to jail for.'}})
			end
		end
end)]]


RegisterCommand('jail', function(source, args, raw)
    local jailedPlayer = tonumber(args[1])
    local jailTime = tonumber(args[2] * 60)
    local reason = args[3]

    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(id, "steam:") then
            steam_id = id 
            break -- break the _loop_
        end
    end
    for i=1, #leo do
        if steam_id == leo[i] then
        	print("Steam ID Checks out.")
        	if jailedPlayer == nil then
        		print("Invalid Player.")
        	elseif jailTime == nil then
        		print("Invalid Time Specified.")
        	else
	            TriggerClientEvent('jailPlayer', jailedPlayer, jailTime)
	            print("Triggering Client Side.")
            break
        end
    end
end)

--[[RegisterCommand('unjail', function(source, args)
	local jailedPlayer = tonumber(args[1])
		for _, id in ipairs(GetPlayerIdentifiers(source)) do
			print("Loopin da loop.")
			if string.match(id, "steam:") then
				steam_id = id
				print("Steam ID Found.")
				for i = 1, #leo do
					if id == leo[i] then 
						print("Steam ID match LEO Table for unjailing.")
							UnJail()
							print("Unjailing.")
						end	
					end
				end
			break -- This may break the script, no pun intended.
			end
		end
end)

function UnJail( jailedPlayer )
	TriggerClientEvent("TeleportOutJail")

--	EditJailTime(jailedPlayer, 0)

end


--[[function EditJailTime(source, jailTime)
	for _, id in ipairs(GetPlayerIdentifiers(source)) do
			print("Loopin da loop.")
			if string.match(id, "steam:") then
				steam_id = id
				print("Steam ID Found.")
--				break
				for i = 1, #leo do
					if id == leo[i] then 
						print("Steam ID match LEO Table for time edit.")

						MySQL.Async.execute(
							"UPDATE users SET jail = @newJailTime where identifier = @identifier",
							{
								['@identifier'] = Identifier,
								['@newJailTime'] = tonumber(jailTime)
							}
						)
					end
				end
			break
			end
	end
end
]]
