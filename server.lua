leo = {
	"steam:1100001018d0707",
}


RegisterCommand('jail', function(source, args, raw)
    local jailedPlayer = tonumber(args[1])
	local jailTime = tonumber(args[2] * 60)
	local reason = args[3]
		for _, id in ipairs(GetPlayerIdentifiers(source)) do
			print("Loopin da loop.")
			if string.match(id, "steam:") then
				steam_id = id
				print("Steam ID Found.")
				for i = 1, #leo do
					if id == leo[i] then 
						print("Steam ID match LEO Table.")
						if reason == nil then
							print("No Reason Found.")
						else
							TriggerClientEvent('jailPlayer', jailedPlayer, jailTime)
							print("Triggering Server Side.")
						end	
					end
				end
			break 
		end
	end
end)

RegisterCommand('unjail', function(source, args)
	local jailedPlayer = tonumber(args[1])
		for _, id in ipairs(GetPlayerIdentifiers(source)) do
			print("Loopin da loop.")
			if string.match(id, "steam:") then
				steam_id = id
				print("Steam ID Found.")
				for i = 1, #leo do
					if id == leo[i] then 
						print("Steam ID match LEO Table for unjailing.")
							TriggerClientEvent('unjail', jailedPlayer)
							print("Unjailing.")
						end	
					end
				end
			break 
		end
end)


