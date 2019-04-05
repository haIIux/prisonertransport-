

-- Call AI Transport : DONE
-- Transport created, arrives. : DONE
-- Takes player, drives to Bollingbrooke. : DONE
-- Fancy Screen Fade Shit : DONE
-- Adjust drive styles. : DONE
-- Adjust / Fix Steam ID Loop (Server Side) : DONE



-- TO DO

-- Figure out a display timer. :
-- Do prison time shit. - Keeps breaking.... :

--RegisterCommand('ptrans', function()
function transport()
	print("Loading transport.")
	local ped = PlayerPedId()
	if not DoesEntityExist(prisonBus) then
		if not IsPedInAnyVehicle(ped, false) or not IsPedInAnyPoliceVehicle(ped) then 
			print("Creating Bus.")

			prisBus = CreateBus(x, y, z)
			while not DoesEntityExist(prisonBus) do
				Wait(1)
			end

			print("Creating AI Driver.")
			copPed = CreateCopPed(prisonBus)
			while not DoesEntityExist(copPed) do
				Wait(1)
			end


			LoadAllPathNodes(true)
			while not AreAllNavmeshRegionsLoaded() do
				Wait(1)
			end

			SetPedIntoVehicle(ped, prisonBus, 2)

			blackOut()		
			
			AIBrain()

			speedthefuckup()
			
			jailed = true

			TriggerServerEvent("jailTimer")

			Citizen.CreateThread(function()
				while true do
					Wait(0)
					if IsPedInVehicle(ped, prisonBus, true) then

						if Vdist2(GetEntityCoords(ped, true), 1828.94, 2608.301, 45.58876) < 15.0 then
							blackOut()
							SetEntityCoordsNoOffset(ped, 1641.27, 2530.39, 45.5649, false, false, false, true)
							Wait(5000)
						end
					else SetEntityAsNoLongerNeeded(prisonBus)
						SetEntityAsNoLongerNeeded(ped)
						Wait(100)
						DeleteEntity(copPed)
						DeleteEntity(prisonBus)
					end
				end
			end)	
		end
	end
end




RegisterNetEvent("jailPlayer")
AddEventHandler("jailPlayer", function(ptime)
	print("Triggering Client.")
	defaultTime = ptime
	if not jailed then
		transport()
		jailed = true
	end
end)

------------------------------------------------------------------
------------------------------------------------------------------
------------------------ FUNCTIONS -------------------------------
------------------------------------------------------------------
------------------------------------------------------------------

function TeleportOutJail()
	blackOut()
	print("Teleporting out.")
    SetEntityCoords(GetPlayerPed(PlayerId()), 1851.12, 2585.54, 45.672, 0.0, 0.0, 0.0, false)
    SetEntityInvincible(GetPlayerPed(PlayerId()), false)
end

local defaultTime = 60
local jailed = false

-function jailTimer()
	print("Jail Timer Started")
	Citizen.CreateThread(function()
		while jailed do
			Wait(0)
			for i = 1, defaultTime do
				print("Timer Ticking.")
				Wait(1000)
				if defaultTime - i == 0 then
					jailed = false
					TeleportOutJail()
				end
			end
		end
	end)
end


function speedthefuckup()
	Citizen.CreateThread(function()
		while true do
			Wait(100)
			if IsEntityInArea(prisonBus, 410.566, -580.4334, 28.72797, 2014.971, 2564.957, 54.63419) then -- Highway
				-- print("Highway")
				SetDriveTaskCruiseSpeed(copPed, 50.0)
			elseif IsEntityInArea(prisonBus, 2021.39, 2571.746, 54.64583, 2426.741, 2857.89, 48.94244) then -- Prior to Ramp + Ramp
				-- print("Ramp")
				SetDriveTaskCruiseSpeed(copPed, 12.0)
			elseif IsEntityInArea(prisonBus, 1978.467, 2641.469, 46.35927, 1828.94, 2608.301, 45.58876) then -- Entry to Bollingbrooke.
				-- print("Entry")
				SetDriveTaskCruiseSpeed(copPed, 8.0)
			end
		end
	end)
end


function AIBrain()
	Wait(100)
	SetDriverAbility(copPed, 1.0)
	SetDriverAggressiveness(copPed, 0.0)
	TaskVehicleDriveToCoordLongrange(copPed, prisBus, 1828.94, 2608.301, 45.58876, 15.0, 511, 2.0) -- Good Style "959"
	SetPedKeepTask(copPed, true)
	SetDriveTaskMaxCruiseSpeed(copPed, 50.0)
end

function blackOut()
        DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(100)
    end
        DoScreenFadeIn(500)
end


function CreateCopPed(prisonBus)
	local model = GetHashKey("csb_cop")

	if DoesEntityExist(prisonBus) then
		if IsModelValid(model) then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(1)
			end

			local ped = CreatePedInsideVehicle(prisonBus, 26, model, -1, true, false)	
			SetBlockingOfNonTemporaryEvents(ped, true)
			SetEntityAsMissionEntity(ped, true, true)

			SetModelAsNoLongerNeeded(model)
			return ped
		end
	end
end

function CreateBus(x, y, z)
	local prisonTrans = GetHashKey("pbus")

	if IsModelValid(prisonTrans) then
		if IsThisModelACar(prisonTrans) then
			RequestModel(prisonTrans)
			while not HasModelLoaded(prisonTrans) do
				Wait(1)
			end

			if not DoesEntityExist(prisonBus) then 

				prisonBus = CreateVehicle(prisonTrans, 481.475, -1021.103, 27.94788, 272.40118408203, true, false)

				SetEntityAsMissionEntity(prisonBus, true, true)
				SetVehicleEngineOn(prisonBus, true, true, false)

				local blip = AddBlipForEntity(prisonBus)
				SetBlipSprite(blip, 198)
				SetBlipFlashes(blip, true)
				SetBlipFlashTimer(blip, 5000)

				SetModelAsNoLongerNeeded(prisonTrans)

				SetHornEnabled(prisonBus, true)
				StartVehicleHorn(prisonBus, 1000, GetHashKey("NORMAL"), false)

				return prisonBus
			end
		end
	end	
end


RegisterCommand('heading', function()
	local ped = PlayerPedId()
	print(GetEntityHeading(ped))
end)

RegisterCommand('loc', function()
	local ped = PlayerPedId()
	print(GetEntityCoords(ped))
end)






---------- Indra's Stolen Super Top Secret Code


function DrawTimerBar(title, text, barIndex)
	local width = 0.13
	local hTextMargin = 0.003
	local rectHeight = 0.038
	local textMargin = 0.008
	
	local rectX = GetSafeZoneSize() - width + width / 2
	local rectY = GetSafeZoneSize() - rectHeight + rectHeight / 2 - (barIndex - 1) * (rectHeight + 0.005)
	
	DrawSprite("timerbars", "all_black_bg", rectX, rectY, width, 0.038, 0, 0, 0, 0, 128)
	
	DrawText(title, GetSafeZoneSize() - width + hTextMargin, rectY - textMargin, 0.32)
	DrawText(string.upper(text), GetSafeZoneSize() - hTextMargin, rectY - 0.0175, 0.5, true, width / 2)
end

function DrawText(text, x, y, scale, right, width)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextColour(254, 254, 254, 255)

	if right then
		SetTextWrap(x - width, x)
		SetTextRightJustify(true)
	end
	
	BeginTextCommandDisplayText("STRING")	
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end
