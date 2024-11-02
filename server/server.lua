local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)
VORP = exports.vorp_core:vorpAPI()
VorpInv = exports.vorp_inventory:vorp_inventoryApi()


function round(number, decimal)
	local multiplier = 10 ^ ( decimal or 0)
	if number == nil then return 25.0000 end
	return math.floor(number * multiplier + 0.5) / multiplier
end

--REGISTER USABLES--   

Citizen.CreateThread(function()    
    for group, info in pairs(Consumables.Items) do
        for index,item in pairs(info) do
            if Config.DevMode then
                print("Registering - ", item.name)
            end

            VorpInv.RegisterUsableItem(item.name, function(data)
                local itemName = exports.vorp_inventory:getItemDB(item.name)
                local baseLabel = itemName.label
                TriggerClientEvent("James_meta:useItem", data.source, group, index)
                TriggerClientEvent("vorp:TipRight", data.source, Config.MSG .. baseLabel)
                VorpInv.subItem(data.source, item.name, 1)
            end)
        end
    end
end)

if Config.DevMode then
    RegisterServerEvent("James_meta:resetUI")
    AddEventHandler("James_meta:resetUI", function()
        print("hi")
        local _source = source
        local User = VorpCore.getUser(_source)
        
        local Character = User.getUsedCharacter
        local u_identifier = Character.identifier
        local u_charid = Character.charIdentifier
        
        uiPos = '{}'
        
        local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid , ['UIposition'] = uiPos}

        exports.ghmattimysql:execute("UPDATE characters SET UIposition=@UIposition WHERE identifier=@identifier AND charidentifier = @charidentifier", Parameters)
        
    end)
end

-- APPLIES CHANGES TO DB.
RegisterServerEvent("James_meta:setStatus")
AddEventHandler("James_meta:setStatus", function(hunger, thirst, saveHealth, healthInner, healthOuter, staminaInner, staminaOuter)
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    local Hunger = hunger
    local Thirst = thirst

    if saveHealth == true then

        exports.ghmattimysql:execute('SELECT meta FROM characters WHERE identifier=@identifier AND charidentifier = @charidentifier', {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)

            if result[1] ~= nil then 
                for i = 1, #result do        
                local meta 		= json.decode(result[i].meta)			
                meta.Hunger 	= round(hunger, 4)
                meta.Thirst		= round(thirst, 4)
                meta 			= json.encode(meta)

                local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid , ['meta'] = meta, ['outerstamina'] = staminaOuter, ['innerstamina'] = staminaInner, ['outerhealth'] = healthOuter, ['innerhealth'] = healthInner}

                exports.ghmattimysql:execute("UPDATE characters SET meta=@meta, staminaouter=@outerstamina, staminainner=@innerstamina, healthouter=@outerhealth, healthinner=@innerhealth WHERE identifier=@identifier AND charidentifier = @charidentifier", Parameters)
                end 
            end
        end)
    else
        exports.ghmattimysql:execute('SELECT meta FROM characters WHERE identifier=@identifier AND charidentifier = @charidentifier', {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)

            if result[1] ~= nil then 
                for i = 1, #result do        
                local meta 		= json.decode(result[i].meta)			
                meta.Hunger 	= round(hunger, 4)
                meta.Thirst		= round(thirst, 4)
                meta 			= json.encode(meta)

                local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid , ['meta'] = meta}

                exports.ghmattimysql:execute("UPDATE characters SET meta=@meta WHERE identifier=@identifier AND charidentifier = @charidentifier", Parameters)
                end 
            end
        end)
    end
end)

RegisterServerEvent("James_meta:updateMetabolismPosition")
AddEventHandler("James_meta:updateMetabolismPosition", function(position)
    local User = VorpCore.getUser(source)
    local _source = source
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    
    exports.ghmattimysql:execute('SELECT UIposition FROM characters WHERE identifier=@identifier AND charidentifier = @charidentifier', {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)

        if result[1] ~= nil then 
            for i = 1, #result do        
            local uiPos = json.decode(result[i].UIposition)			
                
            if uiPos[position.className] == nil then
                uiPos[position.className] = {}
            end

            uiPos[position.className].x = position.x
            uiPos[position.className].y = position.y

            uiPos = json.encode(uiPos)

            local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid , ['UIposition'] = uiPos}

            exports.ghmattimysql:execute("UPDATE characters SET UIposition=@UIposition WHERE identifier=@identifier AND charidentifier = @charidentifier", Parameters)
            end 
        end
    end)
end)

RegisterServerEvent("James_meta:setMetabolismPosition")
AddEventHandler("James_meta:setMetabolismPosition", function()
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    
    exports.ghmattimysql:execute('SELECT UIposition FROM characters WHERE identifier=@identifier AND charidentifier = @charidentifier', {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)

        if result[1] ~= nil then 
            for i = 1, #result do        
                local uiPos = json.decode(result[i].UIposition)                           
                
                TriggerClientEvent("James_meta:setMetabolismPosition", _source, uiPos)
            end 
        end
    end)
end)

RegisterServerEvent("James_meta:healNeeds")
AddEventHandler("James_meta:healNeeds", function(id,hunger, thirst)
   
    local User = VorpCore.getUser(id)
    local Character = User.getUsedCharacter
    local u_identifier = Character.identifier
    local u_charid = Character.charIdentifier
    local Hunger = hunger
    local Thirst = thirst
    local Metabolism = metabolism

    exports.ghmattimysql:execute('SELECT meta FROM characters WHERE identifier=@identifier AND charidentifier = @charidentifier', {['identifier'] = u_identifier, ['charidentifier'] = u_charid}, function(result)

        if result[1] ~= nil then 
            for i = 1, #result do
            local meta 		= json.decode(result[i].meta)			
            meta.Hunger 	= round(hunger, 4)
            meta.Thirst		= round(thirst, 4)
            meta 			= json.encode(meta)

            local Parameters = { ['identifier'] = u_identifier, ['charidentifier'] = u_charid , ['meta'] = meta}

            exports.ghmattimysql:execute("UPDATE characters SET meta=@meta WHERE identifier=@identifier AND charidentifier = @charidentifier", Parameters)
            end 
        end
    end)

    TriggerClientEvent("James_meta:applyChanges2", id, hunger, thirst)
    
end)

RegisterServerEvent("James_meta:checkStatus")
AddEventHandler("James_meta:checkStatus", function()
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local identifier= Character.identifier
    local charidentifier= Character.charIdentifier
    exports.ghmattimysql:execute('SELECT healthouter,healthinner,staminaouter,staminainner,meta FROM characters WHERE identifier=@identifier AND charidentifier = @charidentifier', {['identifier'] = identifier, ['charidentifier'] = charidentifier}, function(result)
        if result[1] ~= nil then 
            for i = 1, #result do
                local meta = json.decode(result[i].meta)
                local healthinner = result[i].healthinner
                local healthouter = result[i].healthouter
                local staminainner = result[i].staminainner
                local staminaouter = result[i].staminaouter
                hunger = meta.Hunger
                thirst = meta.Thirst
                metabolism = meta.Metabolism
                TriggerClientEvent("James_meta:applyChanges", _source, hunger, thirst, metabolism, healthinner, healthouter, staminainner, staminaouter)
            end
        end
    end)
end)

RegisterNetEvent("James:playerSpawnEvent")
AddEventHandler("James:playerSpawnEvent", function(playerId)
    local User 		 	 = VorpCore.getUser(playerId) 
    local Character  	 = VorpCore.getUser(playerId).getUsedCharacter
    local identifier   	 = Character.identifier
    local charidentifier = Character.charIdentifier
    
    exports.ghmattimysql:execute('SELECT meta FROM characters WHERE identifier = @identifier AND charidentifier = @charidentifier', {['identifier'] = identifier, ['charidentifier'] = charidentifier}, function(result)
        if result[1] ~= nil then 
            for i = 1, #result do
                local meta = json.decode(result[i].meta)

                hunger = meta.Hunger
                thirst = meta.Thirst
                metabolism = meta.Metabolism
                
                local Parameters = { ['identifier'] = identifier, ['charidentifier'] = charidentifier , ['meta'] = json.encode(meta)}
                exports.ghmattimysql:execute("UPDATE characters SET meta = @meta WHERE identifier = @identifier AND charidentifier = @charidentifier", Parameters)
                
                print("[META] Loaded user " .. identifier .. " (" .. playerId .. ") [H: ~" .. round(hunger, 2) .. " | T: ~" .. round(thirst, 2) .. "]")
                TriggerClientEvent("James_meta:applyChanges", playerId, hunger, thirst, metabolism)
                TriggerClientEvent("James:setMetaLoaded", playerId)
            end
        end
    end)
end)



