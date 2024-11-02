-- Fix for most natives that need to be called using Citizen.InvokeNative() 

-- may not be required for all natives but this is here to ensure they will work regardless

-- all function names are per https://rdr3natives.com

function SetPedDrunkness(player,enabled,amount)
    return Citizen.InvokeNative(0x406CCF555B04FAD3,player,enabled,amount)
end

function EnableAttributeCoreOverpower(player,core,value,sound)
    return Citizen.InvokeNative(0x4AF5A4C7B9157D14,player,core,value,sound)
end

function EnableAttributeOverpower(player,core,value,sound)
    return Citizen.InvokeNative(0xF6A7C08DF2E28B28,player,core,value,sound)
end

function IsMetaPedUsingComponent(player,comp)
    return Citizen.InvokeNative(0xFB4891BD7578CDC1,player,comp)
end

function GetAttributeCoreOverpowerSecondsLeft(player,core)
    return Citizen.InvokeNative(0xB429F58803D285B1,player,core)
end

function GetAttributeCoreValue(player,core)
    return Citizen.InvokeNative(0x36731AC041289BB1,player,core)
end

function UitutorialSetRpgIconVisibility(ui,enabled)
    return Citizen.InvokeNative(0xC116E6DF68DCE667,ui,enabled)
end

function SetAttributeCoreValue(player,core,value)
    return Citizen.InvokeNative(0xC6258F41D86676E0,player,core,value)
end

function RestorePedStamina(player,amount)
    return Citizen.InvokeNative(0x675680D089BFA21F,player,amount)
end

function SetPedDesiredLocoForModel(player,locotype)
    return Citizen.InvokeNative(0x923583741DC87BCE,player,locotype)
end

function SetPedDesiredLocoMotionType(player,locotype)
    return Citizen.InvokeNative(0x89F5E7ADECCCB49C,player,locotype)
end

function ChangePedStamina(player,amount)
    return Citizen.InvokeNative(0xC3D4B754C0E86B9E,player,amount)
end

function HidePedWeapons(player,int,enabled)
    return Citizen.InvokeNative(0xFCCC886EDE3C63EC,player,int,enabled)
end