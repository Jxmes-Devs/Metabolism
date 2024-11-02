--------------------------------------------------------------------------------
------------------------------- James Metabolism --------------------------------
--------------------------------------------------------------------------------

local VORPcore = exports.vorp_core:GetCore()
next = next 
checked = false
playerstatus = {}
metaLoaded = false
inCreation = false

drunkLevel = 0
drunkTimer = 0
crazyDrunk = true
blackoutDrunk = false

timer2 = 0
hard = 0
lastPlayerState = {}
IsPlayerLoaded = false
consuming = false
EditMode = false


----------------------------- Tables ----------------------------------
playerState = {
	loaded = false,
	useAddicition = nil,
	isTalking = false,
	isMuted = false,
	isRunning = false,
	onHorse = true,

	outerHealth = 100,
	outerHealthActual = 100,
	innerHealth = 100,
	innerStamina = 100,
	outerStamina = 100,

	innerHealthGold = 0,
	outerHealthGold = 0,
	innerStaminaGold = 0,
	outerStaminaGold = 0,

	horseOuterHealth = 0,
	horseOuterStamina = 0,
	horseInnerStamina = 0,
	horseOuterHealth = 0,

	hunger = Config.InitialHunger,
	thirst = Config.InitialThirst,

	temp = 15,
	dirt = 0,
	voiceRange = 10,
	playerIndicator = "green",

	inCinematic = false
}

playerCores = {
	playerhealth = 0,
	playerhealthcore = 1,
	playerdeadeye = 3,
	playerdeadeyecore = 2,
	playerstamina = 4,
	playerstaminacore = 5,
}

horsecores = {
	horsehealth = 6,
	horsehealthcore = 7,
	horsedeadeye = 9,
	horsedeadeyecore = 8,
	horsestamina = 10,
	horsestaminacore = 11,
}

Vomits = {
	["vomit1"] = {
			dict = "amb_misc@world_human_vomit@male_a@idle_a",
			name = "idle_a" ,
			flag = 0,
	},
	["vomit2"] = {
		dict = "amb_misc@world_human_vomit@male_a@idle_c",
		name = "idle_g" ,
		flag = 0,
	},
	["vomit3"] = {
		dict = "amb_misc@world_human_vomit@male_a@idle_c",
		name = "idle_h" ,
		flag = 0,
	},    
}

ClothesList ={
    0x9925C067, -- Hat
    0x2026C46D, -- Shirt
    0x1D4C528A, -- Pants
    0x777EC6EF, -- Boots
    0xE06D30CE, -- Coats
    0x662AC34, -- Closed Coats
    0xEABE0032, -- Gloves
    0x485EE834, -- Vest
    0xAF14310B, -- Ponchos 1
    0x3C1A74CD -- Ponchos 2
}

Colours = { 
    red = 25,
    yellow = 20,
    green = 0
}


--------------------------- EVENTS SECTION ----------------------------
RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function()
	TriggerServerEvent("James_meta:checkStatus")
	Citizen.Wait(25000)
	playerState.loaded = true
	TriggerServerEvent("James_meta:setMetabolismPosition")
	startHud()
	
end)

RegisterNetEvent("James_meta:useItem")
AddEventHandler("James_meta:useItem", function(group,index)
	consuming = true
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	-- NORMALISE

	if playerState.hunger < 0 then playerState.hunger = 0 end

	if playerState.hunger > 100 then playerState.hunger = 100 end

	if playerState.thirst < 0 then playerState.thirst = 0 end

	if playerState.thirst > 100 then playerState.thirst = 100 end

	-- FINDING THE ANIMS

	for k,v in pairs(Config.AnimationTypes) do
		if Consumables.Items[group][index].animation == k then
			
			HidePedWeapons(playerPed, 2, 1) -- Removes Weapon from animation

			if v.itemAnim == false then
				
				model = GetHashKey(Consumables.Items[group][index].propName)
				ensureModel(model)
				local prop = CreateObject(Consumables.Items[group][index].propName, coords.x, coords.y, coords.z + 0.2, true, true, false, false, true)
				local boneIndex = GetEntityBoneIndexByName(playerPed, v.bone)
				
				
				Citizen.Wait(0)
				PlayAnimation(playerPed, v.dict, v.name, v.flag)
				xPos, yPos, zPos, xRot, yRot, zPos = table.unpack(v.attachPoints)
				AttachEntityToEntity(prop, playerPed, boneIndex, xPos, yPos, zPos, xRot, yRot, zPos, true, true, false, true, 1, true)
				Citizen.Wait(4000)
				
				DeleteEntity(prop)
			else 
				if v.multiItem == false then
					
					
					local propEntity = CreateObject(GetHashKey(Consumables.Items[group][index].propName), coords, true, true, true)
					TaskItemInteraction_2(playerPed, v.propNameGXT, propEntity, GetHashKey(v.item1Anim), GetHashKey(v.name), 3, 0, -1.0)
					
				else
					
					
					local item1 = CreateObject(v.prop1, coords, true, true, true)
					local item2 = CreateObject(v.prop2, coords, true, true, true)
					Citizen.InvokeNative(0x669655FFB29EF1A9, item1, 0, v.name, 1.0)  -- named native is (N_0x669655ffb29ef1a9)
					Citizen.InvokeNative(0xCAAF2BCCFEF37F77, item1, 20) 			 -- named native is (N_0xcaaf2bccfef37f77)
					Citizen.InvokeNative(0xCAAF2BCCFEF37F77, item2, 82) 			 -- named native is (N_0xcaaf2bccfef37f77)

					if v.itemInteractionState ~= false then
						itemInteractionState = v.itemInteractionState 
					else
						GetHashKey(v.name)
					end

					TaskItemInteraction_2(playerPed, v.propNameGxt, item1, GetHashKey(v.item1Anim), itemInteractionState, 3, 0, -1.0)
					TaskItemInteraction_2(playerPed, v.propNameGxt, item2, GetHashKey(v.item2Anim), itemInteractionState, 3, 0, -1.0)
					Citizen.InvokeNative(0xB35370D5353995CB, playerPed, v.itemInteractionState, 1.0) -- named native is (N_0xb35370d5353995cb)
					Wait(20000)
					
					DeleteEntity(item1)
					DeleteEntity(item2)
					
				end
			end
		end
	end
	ClearPedSecondaryTask(playerPed)
	ClearPedTasks(playerPed)

	-- EFFECTS
	if Consumables.Items[group][index].drunk > 0 then
		Wait(1)
		
		
		drunkLevel = drunkLevel + Consumables.Items[group][index].drunk
		print(drunkLevel)
		if drunkLevel < 0.25 then return end
		
		drunkTimer = Consumables.Items[group][index].effectDuration
		SetPedIsDrunk(playerPed, true)

		if drunkLevel >= 0.25 and drunkLevel <= 0.49 then
			SetPedDrunkness(playerPed, true, 0.25)
		elseif drunkLevel >= 0.5 and drunkLevel <= 0.74 then
			SetPedDrunkness(playerPed, true, 0.5)
			SetPedDesiredLocoForModel(playerPed, 'default')
			SetPedDesiredLocoMotionType(playerPed, 'slightly_drunk')
		elseif drunkLevel >= 0.75 and drunkLevel <= 0.9 then
			SetPedDrunkness(playerPed, true, 0.75)
			SetPedDesiredLocoForModel(playerPed, 'default')
			SetPedDesiredLocoMotionType(playerPed, 'moderate_drunk')
		elseif drunkLevel >= 1.0 and drunkLevel < 2.0 then
			SetPedDrunkness(playerPed, true, 1.0)
			SetPedDesiredLocoForModel(playerPed, 'default')
			SetPedDesiredLocoMotionType(playerPed, 'very_drunk')
			crazyDrunk = true
		elseif drunkLevel >= 2.0 then
			blackoutDrunk = true
			SetPedDrunkness(playerPed, true, 1.0)
			SetPedDesiredLocoForModel(playerPed, 'default')
			SetPedDesiredLocoMotionType(playerPed, 'very_drunk')
		end		
	end

	if Config.VomitEnabled and (blackoutDrunk or crazyDrunk) then
		vomitCheck()
	end

	if (Consumables.Items[group][index].specialEffect ~= false) then
		ScreenEffect(Consumables.Items[group][index].specialEffect, Consumables.Items[group][index].effectDuration)
	end


	-- SETTING THE STATS

	playerState.hunger = playerState.hunger + tonumber(Consumables.Items[group][index].hunger)
	playerState.thirst = playerState.thirst + tonumber(Consumables.Items[group][index].thirst)
	
	

	if (Consumables.Items[group][index].stamina ~= 0) then
		local outerStamina = GetPedStaminaNormalized(playerPed)*100
		local stamina = GetAttributeCoreValue(playerPed, 1) --ACTUAL STAMINA CORE GETTER
		if stamina == false then
			stamina = 0
		end
		local newstamina = stamina + tonumber(Consumables.Items[group][index].stamina)
		
		if newstamina >= 100 then
			newStamina = 100
			playerState.innerStamina = newStamina


			--set inner stamina core
			SetAttributeCoreValue(playerPed, 1, tonumber(newStamina))	

			-- Handle overflow HP if new value is >= 100 to add to outer hp not just core
			local overflow = (100.0 - newstamina) * -1.0 -- stupid maths due to CFX SetPlayerStamina not working for redm
			newOuterStamina = overflow

			

			--set outer stamina core using above maths 
			playerState.outerStamina = (outerStamina + newOuterStamina)
			actualStaminaApplied = newOuterStamina / 100
			RestorePedStamina(playerPed, actualStaminaApplied)
		else
			
			playerState.outerStamina = outerStamina
			playerState.innerStamina = newStamina

			SetAttributeCoreValue(playerPed, 1, tonumber(newstamina))
			
		end
	end

	if (Consumables.Items[group][index].health ~= 0)then
		health = GetAttributeCoreValue(playerPed, 0) --ACTUAL HEALTH CORE GETTER
			local outerHP = GetEntityHealth(PlayerPedId())
			local newHealth = health + tonumber(Consumables.Items[group][index].health)
		

		if newHealth >= 100 then
			newHealth = 100
			playerState.innerHealth = newHealth
			SetAttributeCoreValue(PlayerPedId(), 0, newHealth)
			
			local overflow = 100.0 - newHealth
			playerState.outerHealth = outerHP + overflow
			SetEntityHealth(PlayerPedId(), playerState.outerHealth)
		end

	end


	if (Consumables.Items[group][index].goldInnerHealth ~= 0) then
		EnableAttributeCoreOverpower(PlayerPedId(), 0, Consumables.Items[group][index].goldInnerHealth + 0.0, true)
		playerState.innerHealthGold = 100
	end
	if	(Consumables.Items[group][index].goldOuterHealth ~= 0) then
		EnableAttributeOverpower(PlayerPedId(), 0, Consumables.Items[group][index].goldOuterHealth + 0.0, true)
		playerState.outerHealthGold = 100
	end

	if (Consumables.Items[group][index].goldInnerStamina ~= 0) then
		EnableAttributeCoreOverpower(PlayerPedId(), 1, Consumables.Items[group][index].goldInnerStamina + 0.0, true)
		playerState.innerStaminaGold = 100
	end
	if (Consumables.Items[group][index].goldOuterStamina ~= 0) then
		EnableAttributeOverpower(PlayerPedId(), 1, Consumables.Items[group][index].goldOuterStamina + 0.0, true)
		playerState.outerStaminaGold = 100
	end
	
	-- SEND TO SERVER
	TriggerServerEvent("James_meta:setStatus", playerState.hunger, playerState.thirst, playerState.innerHealth, playerState.outerHealth, playerState.innerStamina, playerState.outerStamina)

	Wait(1000)
	consuming = false
end)

RegisterNetEvent("James_meta:applyChanges")
AddEventHandler("James_meta:applyChanges", function(hunger, thirst, metabo, healthInner, healthOuter, staminaInner, staminaOuter)

	local playerPed = PlayerPedId()

	if Config.DevMode then
		print("current State:","HI:",healthInner, "HO",healthOuter, "SI:",staminaInner, "SO:",staminaOuter)
	end

	if hunger ~= nil then playerState.hunger = hunger end   
	if playerState.hunger > 100 then playerState.hunger = 100 end
          
	if thirst ~= nil then playerState.thirst = thirst end   
	if playerState.thirst > 100 then playerState.thirst = 100 end
          
	if metabo ~= nil then metabolism = metabo end

	playerState.outerHealth = healthOuter
	
	if healthInner ~= nil then playerState.innerHealth = healthInner end
	if playerState.innerHealth > 100 then playerState.innerHealth = 100 end

	if staminaInner ~= nil then playerState.innerStamina = staminaInner end
	if playerState.innerStamina > 100 then playerState.innerStamina = 100 end
	if playerState.innerStamina == false then playerState.innerStamina = 0 end

	if staminaOuter ~= nil then playerState.outerStamina = staminaOuter end
	if playerState.outerStamina > 100 then playerState.outerStamina = 100 end
	


	SetAttributeCoreValue(playerPed, 0, healthInner)
	SetEntityHealth(playerPed, playerState.outerHealth)
	SetAttributeCoreValue(playerPed, 1, staminaInner)

	-- set player stamina to 100 so its a known value & then rduce by "setStamina" to get last known stamina

	if staminaOuter == 100 then
		setStamina = 100.0	
	else
		setStamina = (100.0 - staminaOuter) * -1.0
	end

	RestorePedStamina(playerPed, 100.0)
	Wait(100)
	ChangePedStamina(playerPed, setStamina)

	metaLoaded = true
	if Config.DevMode then
		print("meta loaded")
	end
end)

RegisterNetEvent("James_meta:setMetabolismPosition")
AddEventHandler("James_meta:setMetabolismPosition", function(uiPos)

	for k,v in pairs(uiPos) do	
		SendNUIMessage({
			type = "UIposition",
			className = k,
			x = v.x,
			y = v.y,
		})
	end

end)

--------------------------- HUNGER & THIRST SYSTEM ----------------------------
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if playerState.loaded == true and metaLoaded == true then
			Citizen.Wait(0)
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			playerState.temp = math.floor(GetTemperatureAtCoords(coords))

			local hot = 0
			local cold = 0

			-- Checks if the player is wearing clothes
			local isWearingHat = IsMetaPedUsingComponent(playerPed, ClothesList[1])
			local isWearingShirt = IsMetaPedUsingComponent(playerPed, ClothesList[2])
			local isWearingPants = IsMetaPedUsingComponent(playerPed, ClothesList[3])
			local isWearingBoots = IsMetaPedUsingComponent(playerPed, ClothesList[4])
			local isWearingCoat = IsMetaPedUsingComponent(playerPed, ClothesList[5])
			local isWearingClosedCoat = IsMetaPedUsingComponent(playerPed, ClothesList[6])
			local isWearingGloves = IsMetaPedUsingComponent(playerPed, ClothesList[7])
			local isWearingVest = IsMetaPedUsingComponent(playerPed, ClothesList[8])
			local isWearingPonchoOne = IsMetaPedUsingComponent(playerPed, ClothesList[9])
			local isWearingPonchoTwo = IsMetaPedUsingComponent(playerPed, ClothesList[10])

			

			if isWearingHat then
				playerState.temp = playerState.temp + Config.HatTemp
			end

			if isWearingShirt then
				playerState.temp = playerState.temp + Config.ShirtTemp
			end

			if isWearingPants then
				playerState.temp = playerState.temp + Config.PantsTemp 
			end

			if isWearingBoots then
				playerState.temp = playerState.temp + Config.BootsTemp 
			end

			if isWearingCoat then
				playerState.temp = playerState.temp + Config.CoatTemp 
			end

			if isWearingClosedCoat then
				playerState.temp = playerState.temp + Config.ClosedCoatTemp 
			end

			if isWearingGloves then
				playerState.temp = playerState.temp + Config.GlovesTemp 
			end

			if isWearingVest then
				playerState.temp = playerState.temp + Config.VestTemp 
			end

			if isWearingPonchoOne then
				playerState.temp = playerState.temp + Config.PonchoTemp
			end

			if isWearingPonchoTwo then
				playerState.temp = playerState.temp + Config.PonchoTemp 
			end
			
			

			if (playerState.hunger < 0) then playerState.hunger = 0	end
			if (playerState.hunger > 100) then playerState.hunger = 100 end
		
			if playerState.thirst < 0 then playerState.thirst = 0 end
			if playerState.thirst > 100 then playerState.thirst = 100 end

			if Config.TemperatureSystem then

				if playerState.temp > Config.MaxTemperature then 
					hot = Config.WaterHotLoss 
				else 
					hot = 0 
				end
	
				if playerState.temp < Config.MinTemperature then
					cold = Config.FoodColdLoss 
				else 
					cold = 0	
				end

				playerState.hunger = playerState.hunger - (Config.FoodDrainIdle+ cold)
				playerState.thirst = playerState.thirst - (Config.WaterDrainIdle + hot)
			else
				playerState.hunger = playerState.hunger - (Config.FoodDrainIdle)
				playerState.thirst = playerState.thirst - (Config.WaterDrainIdle)
			end


			TriggerServerEvent("James_meta:setStatus", playerState.hunger,playerState.thirst,Config.saveStatus,playerState.innerHealth,playerState.outerHealthActual,playerState.innerStamina,playerState.outerStamina)
			Citizen.Wait(Config.NeedsTick)
		end
		Citizen.Wait(1000)
	end
end)

--------------------------- STAMINA & HEALTH SYSTEM ----------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if playerState.loaded == true and metaLoaded == true and not consuming then
			local playerPed = PlayerPedId()
			local IsRunning = IsPedSprinting(playerPed)
			local IsWalking = IsPedWalking(playerPed)
			local onHorse = IsPedOnMount(playerPed)

			
			local innerHealth = GetAttributeCoreValue(playerPed, 0)
			local innerHealthGold = GetAttributeCoreOverpowerSecondsLeft(playerPed, 0)
			

			local OuterHealth = (GetEntityHealth(playerPed)-100)/2 -- UI entry
			local OuterHealthActual = GetEntityHealth(playerPed) -- database entry
			local outerHealthGold = GetAttributeOverpowerSecondsLeft(playerPed, 0)
			
			local innerStamina = GetAttributeCoreValue(playerPed, 1)
			local innerStaminaGold = GetAttributeCoreOverpowerSecondsLeft(playerPed, 1)

			local outerStamina = GetPedStaminaNormalized(playerPed)*100
			local outerStaminaGold = GetAttributeOverpowerSecondsLeft(playerPed, 1)
			
			if innerStamina == false then 
				innerStamina = 0
			end

			if innerHealthGold == false then
				playerState.innerHealthGold = 0
			end
			if innerStaminaGold == false then
				playerState.innerStaminaGold = 0
			end

			if outerStaminaGold ~= nil or outerStaminaGold ~= false then
				outerStamina = 100
			end

			if outerHealthGold ~= nil or outerHealthGold ~= false then
				outerHealth = 300
			end

			playerState.outerHealthGold = outerHealthGold
			playerState.outerStaminaGold = outerStaminaGold

			playerState.isRunning = IsRunning
			playerState.onHorse = onHorse
			playerState.innerHealth = innerHealth
			playerState.outerHealth = OuterHealth
			playerState.outerHealthActual = OuterHealthActual
			playerState.innerStamina = innerStamina
			playerState.outerStamina = outerStamina

			if onHorse then
				local horse = GetMount(playerPed)

				local horseInnerHealth = GetAttributeCoreValue(horse, 0)
				local horseInnerHealthGold = GetAttributeCoreOverpowerSecondsLeft(horse, 0)

				local horseOuterHealth = (GetEntityHealth(horse))
				local horseOuterHealthGold = GetAttributeOverpowerSecondsLeft(horse, 0)
				

				local horseInnerStamina = GetAttributeCoreValue(horse, 1)
				local horseInnerStaminaGold = GetAttributeCoreOverpowerSecondsLeft(horse, 1)

				local horseOuterStamina = GetPedStaminaNormalized(horse)*100				
				local horseOuterStaminaGold = GetAttributeOverpowerSecondsLeft(horse, 1)

				if innerHealthGold == false then
					playerState.innerHealthGold = 0
				end
				if innerStaminaGold == false then
					playerState.innerStaminaGold = 0
				end
	
				if outerStaminaGold ~= nil or outerStaminaGold ~= false then
					outerStamina = 100
				end
	
				if outerHealthGold ~= nil or outerHealthGold ~= false then
					outerHealth = 300
				end

				playerState.horseInnerHealth = horseInnerHealth
				playerState.horseInnerHealthGold = horseInnerHealthGold

				playerState.horseOuterHealth =  horseOuterHealth
				playerState.horseOuterHealthGold =  horseOuterHealthGold

				playerState.horseInnerStamina = horseInnerStamina
				playerState.horseInnerStaminaGold = horseInnerStaminaGold

				playerState.horseOuterStamina = horseOuterStamina
				playerState.horseOuterStaminaGold = horseOuterStaminaGold

			else
				playerState.horseInnerHealth = 0
				playerState.horseOuterHealth = 0
				playerState.horseInnerStamina = 0
				playerState.horseOuterStamina = 0
			end
			
			if not onHorse then
				if IsRunning then
					if Config.TemperatureSystem then
						playerState.hunger = playerState.hunger - (Config.FoodDrainRunning + cold)
						playerState.thirst = playerState.thirst - (Config.WaterDrainRunning + hot)
					else
						playerState.hunger = playerState.hunger - (Config.FoodDrainRunning)
						playerState.thirst = playerState.thirst - (Config.WaterDrainRunning)
					end
				elseif IsWalking then
					if Config.TemperatureSystem then
						playerState.hunger = playerState.hunger - (Config.FoodDrainWalking + cold)
						playerState.thirst = playerState.thirst - (Config.WaterDrainWalking + hot)
					else
						playerState.hunger = playerState.hunger - (Config.FoodDrainWalking)
						playerState.thirst = playerState.thirst - (Config.WaterDrainWalking)
					end
				end		
			end	
		end
		Citizen.Wait(500)
	end
end)

--------------------------- HIDE NATIVE UIS ---------------------------
Citizen.CreateThread(function()
	
	Citizen.Wait(0)

	UitutorialSetRpgIconVisibility(2, 2)
	UitutorialSetRpgIconVisibility(3, 2)

	for key, value in pairs(playerCores) do
		UitutorialSetRpgIconVisibility(value, 2)
	end

	for key, value in pairs(horsecores) do
		UitutorialSetRpgIconVisibility(value, 2)
	end
end)

--------------------------- DIRT SYSTEM ----------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if playerState.loaded == true and metaLoaded == true then
			Citizen.Wait(0)
			local playerPed = PlayerPedId()
			local pedClean = GetAttributeBaseRank(playerPed,17)
			if pedClean > 0 then
				playerState.dirt = pedClean
			end
			-- print(pedClean)
		end
		Citizen.Wait(500)
	end
end)


--------------------------- SUUBSYSTEMS SYSTEM ----------------------------
if Config.VoiceSystem then
	if Config.saltyChat then
		Citizen.CreateThread(function()
			while true do
				Wait(0)
				if playerState.loaded and metaLoaded then
					new_voice_Range = exports.saltychat.GetVoiceRange()
					isTalking = export.saltychat.SaltyChat_TalkStateChanged()
					if new_voice_Range ~= playerState.voiceRange then
						if new_voice_Range == Config.WhisperRange then
							playerState.voiceRange = 5
						elseif new_voice_Range == Config.NormalRange then
							playerState.voiceRange = 15
						elseif new_voice_Range == Config.ShoutRange then
							playerState.voiceRange = 50
						elseif new_voice_Range == Config.TrailRange then
							playerState.voiceRange = 100
						end
					end

					if isTalking then 
						playerState.isTalking = true
					else
						playerState.isTalking = false
					end
		
				Citizen.Wait(1000)
				end
			end
		end)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if playerState.loaded == true and metaLoaded == true and not IsPedDeadOrDying(PlayerPedId(),true) and (playerState.hunger <= 0 or playerState.thirst <= 0) then
			ApplyDamage()
			Wait(Config.DamageTick)
		elseif not IsPedDeadOrDying(PlayerPedId(),true) and (playerState.hunger <= 0 or playerState.thirst <= 0) then
			Wait(10000)
		end
		
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if playerState.loaded and metaLoaded then
			RefreshNearby()
			if Config.cinematicHide then
				playerState.inCinematic = IsInCinematicMode()
			end
		end
		Wait(1000)
	end
end)


------------------------------ DRUNK EFFECT ------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1000)
		if drunkTimer > 0 then
			drunkTimer = drunkTimer - 1000
		else
			if drunkLevel >= 0.25 then
				SetPedDrunkness(PlayerPedId(), 1, 0.0)
				SetPedIsDrunk(playerPed, false)
				ClearPedDesiredLocoMotionType(PlayerPedId())
				drunkLevel = 0
				if blackoutDrunk then
					blackoutDrunk = false
				end
			end
		end
	end
end)

---------------------- Disable Controls While Drunk ----------------------
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if Config.DisableDrunkRun and blackoutDrunk then
          		DisableControlAction(0, 0x8FFC75D6, true)
		end
	end
end)

----------------------------- COMMANDS ----------------------------
RegisterCommand("editNeeds", function(source, args, rawCommand)	
	EditMode = true
	SetNuiFocus(true, true)
	SendNUIMessage({

		action = "notify",
		textsent = "Move the UI to your desired position and then press ESC to save.",

		type = "showAllHUD",
		show = true
	})

	SendNUIMessage({
		type = "edit",
	})

end)	


RegisterNUICallback("saveEdit", function(data, cb)
	EditMode = false
	SetNuiFocus(false, false)
	
	updateNeeds(
		playerState.isRunning,
		playerState.isTalking,
		playerState.isMuted,
		playerState.onHorse,
		playerState.innerHealth,
		playerState.outerHealth,
		playerState.innerStamina,
		playerState.outerStamina,

		playerState.horseOuterHealth,
		playerState.horseOuterHealth,
		
		playerState.horseInnerStamina,
		playerState.horseOuterStamina,
		
		playerState.thirst,
		playerState.hunger,
		playerState.temp,
		playerState.dirt,
		playerState.voiceRange,
		playerState.playerIndicator
	)

end)


RegisterNUICallback("saveUIPosition", function(data, cb)

	TriggerServerEvent("James_meta:updateMetabolismPosition", data)

end)


------------------- HUNGER AND THIRST LOW NOTIFICATION SYSTEM -----------------
-- Dont really like this system but it works for now

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if playerState.hunger <= Config.FoodNotification1 and playerState.hunger >= Config.FoodNotification2 then 
			VORPcore.NotifyRightTip(Config.FoodNotify1, 4000) 
		end
		if playerState.thirst <= Config.WaterNotification1 and playerState.thirst >= Config.WaterNotification2 then 
			VORPcore.NotifyRightTip(Config.WaterNotify1, 4000) 
		end

		if playerState.hunger <= Config.FoodNotification2 then 
			VORPcore.NotifyRightTip(Config.FoodNotify2, 4000) 
		end
		if playerState.thirst <= Config.WaterNotification2 then 
			VORPcore.NotifyRightTip(Config.WaterNotify2, 4000) 
		end
		Wait(Config.NotificationTime)
	end
end)



--------------------------- DEVELOPER SECTION ----------------------------
if Config.DevMode then
	isTalking = false
	isMuted = false
	voiceRange = 0
	print("Loading Dev Configs")
	RegisterCommand("healNeeds", function(source, args, rawCommand)
		TriggerServerEvent("James_meta:healNeeds",args[1],100,100)
		
	end)

	RegisterCommand("drainHunger", function(source, args, rawCommand)
		playerState.hunger = playerState.hunger - args[1]
	end)

	RegisterCommand("isTalking",function(source, args, rawCommand)
		isTalking = not isTalking
		print("Talking:",isTalking)
		playerState.isTalking = isTalking
		
	end)

	RegisterCommand("voiceRange",function(source, args, rawCommand)
		print(args[1])
		playerState.voiceRange = tonumber(args[1])
	end)

	RegisterCommand("isMuted",function(source, args, rawCommand)
		isMuted = not isMuted
		print("Muted:",isMuted)

		playerState.isMuted = isMuted

	end)

	RegisterCommand("testNoti",function(source, args, rawCommand)
		SendNUIMessage({
			action = "notify",
			textsent = "Move the UI to your desired position and then press ESC to save.",
		})
	end)

	RegisterCommand("cleandirt", function()
		local playerPed = PlayerPedId()
		SetAttributeBaseRank(playerPed,17,0)
		playerState.dirt = 0
	end)
	RegisterCommand("resetUI", function(source, args, rawCommand)
		TriggerServerEvent("James_meta:resetUI")
		VORPcore.NotifyRightTip("Please restart metabolism for ui reset") 

	end)

	AddEventHandler("onResourceStart",function(resourcename)
		if GetCurrentResourceName() == resourcename then
			TriggerServerEvent("James_meta:checkStatus")
			Wait(1000)
			playerState.loaded = true
			Wait(5000)
			TriggerServerEvent("James_meta:setMetabolismPosition")
			startHud()
			AnimpostfxStop("PlayerDrunk01")
			ClearPedDesiredLocoMotionType(PlayerPedId())
		end

	end)
	RegisterNetEvent("James_meta:applyChanges2")
	AddEventHandler("James_meta:applyChanges2", function(hunger, thirst)
		if hunger ~= nil then playerState.hunger = hunger end   
		if playerState.hunger > 100 then playerState.hunger = 100 end
			
		if thirst ~= nil then playerState.thirst = thirst end   
		if playerState.thirst > 100 then playerState.thirst = 100 end
				
	end)

	Wait(5000)
	print("Dev Configs Loaded")
end

