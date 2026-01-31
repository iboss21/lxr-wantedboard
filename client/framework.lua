--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Client Framework Integration
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

Framework = {}
Framework.Core = nil
Framework.PlayerData = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK INITIALIZATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    if Config.Framework == 'standalone' then
        Framework.PlayerData = {
            job = { name = 'unemployed', grade = 0 },
            citizenid = 'STANDALONE'
        }
        return
    end
    
    local triggers = Config.FrameworkTriggers[Config.Framework]
    if not triggers then
        print('^1[LXR Wanted Board] ERROR: Invalid framework configured^7')
        return
    end
    
    -- Wait for core object
    while Framework.Core == nil do
        TriggerEvent(triggers.getObject, function(obj)
            Framework.Core = obj
        end)
        Citizen.Wait(100)
    end
    
    -- Get player data
    while not Framework.PlayerData or not Framework.PlayerData.citizenid do
        if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
            Framework.PlayerData = Framework.Core.Functions.GetPlayerData()
        elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
            Framework.PlayerData = Framework.Core.Functions.GetPlayerData()
        end
        Citizen.Wait(100)
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ PLAYER EVENTS █████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

if Config.Framework ~= 'standalone' then
    local triggers = Config.FrameworkTriggers[Config.Framework]
    
    -- Player loaded
    RegisterNetEvent(triggers.playerLoaded, function()
        if Config.Framework == 'lxrcore' or Config.Framework == 'rsg-core' then
            Framework.PlayerData = Framework.Core.Functions.GetPlayerData()
        elseif Config.Framework == 'qbcore' or Config.Framework == 'qbr-core' then
            Framework.PlayerData = Framework.Core.Functions.GetPlayerData()
        end
        Utils.Debug('Player loaded')
    end)
    
    -- Player unloaded
    RegisterNetEvent(triggers.playerUnloaded, function()
        Framework.PlayerData = {}
        Utils.Debug('Player unloaded')
    end)
    
    -- Job update
    RegisterNetEvent(triggers.jobUpdate, function(job)
        Framework.PlayerData.job = job
        Utils.Debug('Job updated: ' .. job.name)
    end)
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ PLAYER FUNCTIONS ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

function Framework.GetPlayerData()
    return Framework.PlayerData
end

function Framework.GetPlayerJob()
    if Framework.PlayerData and Framework.PlayerData.job then
        return Framework.PlayerData.job
    end
    return { name = 'unemployed', grade = 0 }
end

function Framework.IsLawEnforcement()
    local job = Framework.GetPlayerJob()
    for _, lawJob in ipairs(Config.LawJobs) do
        if job.name == lawJob then
            return true
        end
    end
    return false
end

function Framework.IsBountyHunter()
    if not Config.BountyHunters.enabled then
        return false
    end
    
    local job = Framework.GetPlayerJob()
    for _, hunterJob in ipairs(Config.BountyHunters.jobs) do
        if job.name == hunterJob then
            return true
        end
    end
    return false
end

function Framework.HasRequiredGrade(requiredGrade)
    local job = Framework.GetPlayerJob()
    return job.grade >= requiredGrade
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ NOTIFICATION FUNCTIONS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

function Framework.Notify(message, type, duration)
    type = type or 'info'
    duration = duration or Config.Notifications.duration
    
    if Config.Notifications.type == 'native' then
        -- RedM native notification
        local dict = 'HUD_TOASTS'
        local texture = 'toast_log_blips'
        
        if type == 'error' then
            texture = 'toast_wanted_poster'
        elseif type == 'success' then
            texture = 'toast_info'
        end
        
        exports['redem_roleplay']:ShowNotification(message, type)
    elseif Config.Notifications.type == 'mythic_notify' then
        exports['mythic_notify']:SendAlert(type, message, duration)
    elseif Config.Notifications.type == 'ox_lib' then
        exports['ox_lib']:notify({
            title = 'Wanted Board',
            description = message,
            type = type,
            duration = duration
        })
    else
        -- Fallback to basic notification
        print(message)
    end
end

RegisterNetEvent('lxr-wantedboard:client:notify', function(message, type, duration)
    Framework.Notify(message, type, duration)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
