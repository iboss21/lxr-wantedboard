--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Client UI Management
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

UI = {}
UI.IsOpen = false

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ NUI MANAGEMENT ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Send NUI message
function UI.SendNUI(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

-- Open UI
function UI.Open(data)
    if UI.IsOpen then return end
    
    UI.IsOpen = true
    SetNuiFocus(true, true)
    UI.SendNUI('open', data)
end

-- Close UI
function UI.Close()
    if not UI.IsOpen then return end
    
    UI.IsOpen = false
    SetNuiFocus(false, false)
    UI.SendNUI('close', {})
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ WANTED BOARD UI FUNCTIONS █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Open wanted board
function UI.OpenBoard(data)
    UI.Open({
        type = 'board',
        board = data.board,
        wantedList = data.wantedList,
        permissions = {
            canCreate = data.canCreate,
            canEdit = data.canEdit,
            canRemove = data.canRemove
        },
        isBountyHunter = data.isBountyHunter
    })
end

-- Open wanted list
function UI.OpenWantedList(data)
    UI.Open({
        type = 'list',
        wantedList = data.wantedList,
        isBountyHunter = data.isBountyHunter
    })
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ NUI CALLBACKS █████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Close UI callback
RegisterNUICallback('close', function(data, cb)
    UI.Close()
    cb('ok')
end)

-- Create wanted poster callback
RegisterNUICallback('createWanted', function(data, cb)
    TriggerServerEvent('lxr-wantedboard:server:createWanted', data)
    cb('ok')
end)

-- Update wanted poster callback
RegisterNUICallback('updateWanted', function(data, cb)
    TriggerServerEvent('lxr-wantedboard:server:updateWanted', data.id, data)
    cb('ok')
end)

-- Remove wanted poster callback
RegisterNUICallback('removeWanted', function(data, cb)
    TriggerServerEvent('lxr-wantedboard:server:removeWanted', data.id)
    cb('ok')
end)

-- Get wanted details callback
RegisterNUICallback('getWantedDetails', function(data, cb)
    TriggerServerEvent('lxr-wantedboard:server:getWantedDetails', data.id)
    cb('ok')
end)

-- Search wanted callback
RegisterNUICallback('searchWanted', function(data, cb)
    TriggerServerEvent('lxr-wantedboard:server:searchWanted', data.query)
    cb('ok')
end)

-- Capture wanted callback
RegisterNUICallback('captureWanted', function(data, cb)
    -- Find nearby wanted criminal
    local nearbyWanted = GetNearbyWanted(Config.BountyHunters.captureRadius)
    
    for _, target in ipairs(nearbyWanted) do
        if target.wanted.id == data.id then
            TriggerServerEvent('lxr-wantedboard:server:captureWanted', target.serverId, data.id)
            UI.Close()
            cb('ok')
            return
        end
    end
    
    Framework.Notify(_U('no_wanted_nearby'), 'error')
    cb('error')
end)

-- Claim reward callback
RegisterNUICallback('claimReward', function(data, cb)
    TriggerServerEvent('lxr-wantedboard:server:claimReward', data.captureId)
    cb('ok')
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ KEYBOARD CONTROLS █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- ESC key to close UI
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if UI.IsOpen then
            -- Disable controls while UI is open
            DisableAllControlActions(0)
            EnableControlAction(0, 0xD9D0E1C0, true) -- MOUSE CURSOR
            EnableControlAction(0, 0x8CC9CD42, true) -- MOUSE LEFT CLICK
            EnableControlAction(0, 0x4CC0E2FE, true) -- MOUSE RIGHT CLICK
            
            -- ESC to close
            if IsControlJustReleased(0, 0x156F7119) then -- ESC
                UI.Close()
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
