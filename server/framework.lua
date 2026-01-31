--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Server Framework Integration
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

Framework = {}
Framework.Core = nil

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK INITIALIZATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    if Config.Framework == 'standalone' then
        print('^3[LXR Wanted Board]^7 Running in standalone mode')
        return
    end
    
    local triggers = Config.FrameworkTriggers[Config.Framework]
    if not triggers then
        print('^1[LXR Wanted Board] ERROR: Invalid framework configured: ' .. Config.Framework .. '^7')
        return
    end
    
    -- Wait for core object
    while Framework.Core == nil do
        TriggerEvent(triggers.getObject, function(obj)
            Framework.Core = obj
        end)
        Citizen.Wait(100)
    end
    
    print('^2[LXR Wanted Board]^7 Framework initialized: ^3' .. Config.Framework .. '^7')
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ PLAYER FUNCTIONS ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

function Framework.GetPlayer(source)
    if Config.Framework == 'standalone' then
        return {
            source = source,
            identifier = GetPlayerIdentifier(source, 0),
            name = GetPlayerName(source),
            job = { name = 'unemployed', grade = 0 },
            money = 1000
        }
    end
    
    if Config.Framework == 'lxrcore' then
        return Framework.Core.Functions.GetPlayer(source)
    elseif Config.Framework == 'rsg-core' then
        return Framework.Core.Functions.GetPlayer(source)
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        return Framework.Core.Functions.GetPlayer(source)
    end
    
    return nil
end

function Framework.GetPlayerByIdentifier(identifier)
    if Config.Framework == 'standalone' then
        return nil
    end
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' or 
       Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        return Framework.Core.Functions.GetPlayerByCitizenId(identifier)
    end
    
    return nil
end

function Framework.GetPlayerJob(source)
    local Player = Framework.GetPlayer(source)
    if not Player then return nil end
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
        return Player.PlayerData.job
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        return Player.PlayerData.job
    elseif Config.Framework == 'standalone' then
        return { name = 'unemployed', grade = 0 }
    end
    
    return nil
end

function Framework.GetPlayerIdentifier(source)
    local Player = Framework.GetPlayer(source)
    if not Player then
        return GetPlayerIdentifier(source, 0)
    end
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
        return Player.PlayerData.citizenid
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        return Player.PlayerData.citizenid
    elseif Config.Framework == 'standalone' then
        return GetPlayerIdentifier(source, 0)
    end
    
    return GetPlayerIdentifier(source, 0)
end

function Framework.GetPlayerName(source)
    local Player = Framework.GetPlayer(source)
    if not Player then
        return GetPlayerName(source)
    end
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
        return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    elseif Config.Framework == 'standalone' then
        return GetPlayerName(source)
    end
    
    return GetPlayerName(source)
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ MONEY FUNCTIONS ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

function Framework.GetPlayerMoney(source, moneyType)
    local Player = Framework.GetPlayer(source)
    if not Player then return 0 end
    
    moneyType = moneyType or 'cash'
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
        return Player.PlayerData.money[moneyType] or 0
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        return Player.PlayerData.money[moneyType] or 0
    elseif Config.Framework == 'standalone' then
        return 1000
    end
    
    return 0
end

function Framework.AddMoney(source, amount, moneyType, reason)
    local Player = Framework.GetPlayer(source)
    if not Player then return false end
    
    moneyType = moneyType or 'cash'
    reason = reason or 'Bounty reward'
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
        Player.Functions.AddMoney(moneyType, amount, reason)
        return true
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        Player.Functions.AddMoney(moneyType, amount, reason)
        return true
    elseif Config.Framework == 'standalone' then
        return true
    end
    
    return false
end

function Framework.RemoveMoney(source, amount, moneyType, reason)
    local Player = Framework.GetPlayer(source)
    if not Player then return false end
    
    moneyType = moneyType or 'cash'
    reason = reason or 'Fine'
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
        Player.Functions.RemoveMoney(moneyType, amount, reason)
        return true
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        Player.Functions.RemoveMoney(moneyType, amount, reason)
        return true
    elseif Config.Framework == 'standalone' then
        return true
    end
    
    return false
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████████ JOB FUNCTIONS ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

function Framework.IsLawEnforcement(source)
    local job = Framework.GetPlayerJob(source)
    if not job then return false end
    
    for _, lawJob in ipairs(Config.LawJobs) do
        if job.name == lawJob then
            return true
        end
    end
    
    return false
end

function Framework.IsBountyHunter(source)
    local job = Framework.GetPlayerJob(source)
    if not job then return false end
    
    if not Config.BountyHunters.enabled then
        return false
    end
    
    for _, hunterJob in ipairs(Config.BountyHunters.jobs) do
        if job.name == hunterJob then
            return true
        end
    end
    
    return false
end

function Framework.HasRequiredGrade(source, requiredGrade)
    local job = Framework.GetPlayerJob(source)
    if not job then return false end
    
    return job.grade >= requiredGrade
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ ITEM FUNCTIONS ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

function Framework.HasItem(source, item, amount)
    local Player = Framework.GetPlayer(source)
    if not Player then return false end
    
    amount = amount or 1
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
        local hasItem = Player.Functions.GetItemByName(item)
        return hasItem ~= nil and hasItem.amount >= amount
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        local hasItem = Player.Functions.GetItemByName(item)
        return hasItem ~= nil and hasItem.amount >= amount
    elseif Config.Framework == 'standalone' then
        return true
    end
    
    return false
end

function Framework.AddItem(source, item, amount, info)
    local Player = Framework.GetPlayer(source)
    if not Player then return false end
    
    amount = amount or 1
    info = info or {}
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
        Player.Functions.AddItem(item, amount, false, info)
        return true
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        Player.Functions.AddItem(item, amount, false, info)
        return true
    elseif Config.Framework == 'standalone' then
        return true
    end
    
    return false
end

function Framework.RemoveItem(source, item, amount)
    local Player = Framework.GetPlayer(source)
    if not Player then return false end
    
    amount = amount or 1
    
    if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
        Player.Functions.RemoveItem(item, amount)
        return true
    elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
        Player.Functions.RemoveItem(item, amount)
        return true
    elseif Config.Framework == 'standalone' then
        return true
    end
    
    return false
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ NOTIFICATION FUNCTIONS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

function Framework.Notify(source, message, type, duration)
    type = type or 'info'
    duration = duration or Config.Notifications.duration
    
    TriggerClientEvent('lxr-wantedboard:client:notify', source, message, type, duration)
end

function Framework.NotifyAllLaw(message, type)
    for _, playerId in ipairs(GetPlayers()) do
        local playerSource = tonumber(playerId)
        if Framework.IsLawEnforcement(playerSource) then
            Framework.Notify(playerSource, message, type)
        end
    end
end

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
