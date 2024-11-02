function PlayAnimation(ped, dict, name, flag)
	if not DoesAnimDictExist(dict) then
		return
	end

	RequestAnimDict(dict)

	while not HasAnimDictLoaded(dict) do
		Wait(0)
	end

	TaskPlayAnim(ped, dict, name, 1.0, 1.0, -1, flag, 0, false, false, false, '', false)

	RemoveAnimDict(dict)
end

function ScreenEffect(effect, time)
	print(effect, time)
	AnimpostfxPlay(effect)
	Citizen.Wait(time)
	AnimpostfxStop(effect)
end

function vomitCheck()
	
	if crazyDrunk then hard = 3 end
	if blackoutDrunk then hard = 5 end

	if hard == 1 then
		local vomitchance = math.random(1,10) -- 10% chance
		if vomitchance == 1 then
			local vom = math.random(1,3)
			PlayAnimation(PlayerPedId(), Vomits["vomit"..vom])
		end
	elseif hard == 2 then
		local vomitchance = math.random(1, 4) -- 25% chance
		if vomitchance == 1 then
			local vom = math.random(1,3)
			PlayAnimation(PlayerPedId(), Vomits["vomit"..vom])
		end
	elseif hard == 3 then
		local vomitchance = math.random(1, 2) -- 50% chance
		if vomitchance == 1 then
			local vom = math.random(1,3)
			PlayAnimation(PlayerPedId(), Vomits["vomit"..vom])
		end
	elseif hard == 4 then
		local vomitchance = math.random(1, 1) -- 100% chance
		if vomitchance == 1 then
			local vom = math.random(1,3)
			PlayAnimation(PlayerPedId(), Vomits["vomit"..vom])
		end
	elseif hard == 5 then
		SetPedToRagdoll(PlayerPedId(-1), 60000, 60000, 0, 0, 0, 0)
		ScreenEffect("PlayerDrunk01", 5000)
		ScreenEffect("PlayerDrunk01_PassOut", 30000)
		hard = 0
	end
		
end

function copyTable(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = copyTable(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function clearMemory()
    collectgarbage("collect")
    lastPlayerState = nil
    lastPlayerState = copyTable(playerState)
end

function ensureModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end 
    end
    return model
end

function ApplyDamage()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    
    ApplyDamageToPed(ped,Config.HealthLoss)
end

function RefreshNearby()
    local closePlayerCount = 0
    local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true, true)
	
    for _, player in pairs(GetActivePlayers()) do
        local target = GetPlayerPed(player)

        if target ~= playerPed then
            local targetCoords = GetEntityCoords(target, true, true)
            local distance = #(targetCoords - coords)

            if distance < closestDistance then
                closePlayerCount = closePlayerCount + 1
            end
        end
    end

    for colour, value in pairs(Colours) do
        if closePlayerCount >= value then
           playerState.playerIndicator = colour
        end
    end
	
end

--------------------------- CORE FUNCTION --------------------------------
function updateNeeds(isRunning, isTalking, isMuted, onHorse,
	innerHealth, outerHealth, innerStamina, outerStamina,
	innerHealthGold, outerHealthGold, innerStaminaGold, outerStaminaGold,
	horseInnerHealth, horseOuterHealth, horseInnerStamina, horseOuterStamina,
	horseInnerHealthGold, horseOuterHealthGold, horseInnerStaminaGold, horseOuterStaminaGold,
    thirst, hunger, temp, dirt, voiceRange, playerIndicator,inCinematic)
	SendNUIMessage ({
		type = "HUD",
		voiceSystem = Config.VoiceSystem,

		isrunning = isRunning,
		isTalking = isTalking,
		isMuted = isMuted,
		onHorse = onHorse,

		innerHealth = innerHealth,
		outerHealth = outerHealth,
		innerStamina =  innerStamina,
		outerStamina = outerStamina,

		innerHealthGold = innerHealthGold, 
		outerHealthGold = outerHealthGold, 
		innerStaminaGold = innerStaminaGold, 
		outerStaminaGold = outerStaminaGold,

        horseInnerHealth = horseInnerHealth,
        horseOuterHealth = horseOuterHealth,
		horseInnerStamina = horseInnerStamina,
        horseOuterStamina = horseOuterStamina,

		horseInnerHealthGold = horseInnerHealthGold,
        horseOuterHealthGold = horseOuterHealthGold,
		horseInnerStaminaGold = horseInnerStaminaGold,
        horseOuterStaminaGold = horseOuterStaminaGold,

		thirst = thirst,
		hunger = hunger,
		tempNumber = temp,
		dirt = dirt,
		voiceRange = voiceRange,
		playerIndicator = playerIndicator,

		inCinematic = inCinematic
	})
end

function startHud()
	Citizen.CreateThread(function()
		while true do
			local changed = false
			-- Compare current state with last state
			for key, value in pairs(playerState) do
				if lastPlayerState[key] ~= value then
					changed = true
					break
				end
			end
			
			-- If changes detected, update UI and store new state
			if changed and not EditMode then
			
				updateNeeds(
					playerState.isRunning,
					playerState.isTalking,
					playerState.isMuted,
					playerState.onHorse,
					
					playerState.innerHealth,
					playerState.outerHealth,
					playerState.innerStamina,
					playerState.outerStamina,

					playerState.innerHealthGold,
					playerState.outerHealthGold,
					playerState.innerStaminaGold,
					playerState.outerStaminaGold,

                    playerState.horseInnerHealth,
                    playerState.horseOuterHealth,
                    playerState.horseInnerStamina,
                    playerState.horseOuterStamina,

					playerState.horseInnerHealthGold,
                    playerState.horseOuterHealthGold,
                    playerState.horseInnerStaminaGold,
                    playerState.horseOuterStaminaGold,
                    
					playerState.thirst,
					playerState.hunger,
					
					playerState.temp,
					playerState.dirt,
					playerState.voiceRange,
					playerState.playerIndicator,

					playerState.inCinematic
				)

				clearMemory()
				
			end
			
			if GetGameTimer() % 1000 == 0 then 
				collectgarbage("collect")
			end
			

			Wait(1000)
		end
	end)
end
