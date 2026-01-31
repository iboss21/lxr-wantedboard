--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Client Main Logic
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ GLOBAL VARIABLES ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local WantedList = {}
local NearbyBoards = {}
local CurrentBoard = nil
local IsCapturing = false

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ WANTED BOARD INTERACTIONS █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Create blips for wanted boards
Citizen.CreateThread(function()
    for _, board in pairs(Config.WantedBoards) do
        if board.blip and board.blip.enabled then
            local blip = Blip.AddForCoords(board.blip.sprite, board.coords)
            SetBlipSprite(blip, GetHashKey(board.blip.sprite))
            SetBlipScale(blip, board.blip.scale)
            Blip.SetName(blip, board.name)
        end
    end
end)

-- Monitor proximity to wanted boards
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i, board in pairs(Config.WantedBoards) do
            local distance = #(playerCoords - board.boardCoords)
            
            if distance < board.interactionDistance then
                sleep = 0
                NearbyBoards[i] = board
                
                -- Draw interaction prompt
                if distance < 2.0 then
                    Utils.DrawText3D(board.boardCoords.x, board.boardCoords.y, board.boardCoords.z + 0.1, _U('press_to_interact'))
                    
                    if IsControlJustReleased(0, 0xCEFD9220) then -- E key
                        CurrentBoard = board
                        TriggerEvent('lxr-wantedboard:client:openBoard')
                    end
                end
            else
                NearbyBoards[i] = nil
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ WANTED LIST MANAGEMENT ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Request wanted list from server
function RequestWantedList()
    TriggerServerEvent('lxr-wantedboard:server:requestWantedList')
end

-- Receive wanted list from server
RegisterNetEvent('lxr-wantedboard:client:receiveWanted', function(wantedList)
    WantedList = wantedList
    Utils.Debug('Received wanted list: ' .. #wantedList .. ' entries')
end)

-- Refresh wanted list
RegisterNetEvent('lxr-wantedboard:client:refreshWanted', function()
    RequestWantedList()
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ BOARD UI MANAGEMENT ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Open wanted board
RegisterNetEvent('lxr-wantedboard:client:openBoard', function()
    if not CurrentBoard then return end
    
    -- Request fresh wanted list
    RequestWantedList()
    
    -- Wait a moment for server response
    Citizen.Wait(100)
    
    -- Open UI
    UI.OpenBoard({
        board = CurrentBoard,
        wantedList = WantedList,
        canCreate = Framework.IsLawEnforcement() and Framework.HasRequiredGrade(Config.MinimumGrades.createWanted),
        canEdit = Framework.IsLawEnforcement() and Framework.HasRequiredGrade(Config.MinimumGrades.editWanted),
        canRemove = Framework.IsLawEnforcement() and Framework.HasRequiredGrade(Config.MinimumGrades.removeWanted),
        isBountyHunter = Framework.IsBountyHunter()
    })
end)

-- Open wanted list (command)
RegisterNetEvent('lxr-wantedboard:client:openWantedList', function()
    RequestWantedList()
    Citizen.Wait(100)
    
    UI.OpenWantedList({
        wantedList = WantedList,
        isBountyHunter = Framework.IsBountyHunter()
    })
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ BOUNTY HUNTING MECHANICS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Check for nearby wanted criminals
function GetNearbyWanted(radius)
    radius = radius or Config.BountyHunters.captureRadius
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local nearbyWanted = {}
    
    for _, wanted in pairs(WantedList) do
        -- Find player by identifier
        local players = GetActivePlayers()
        for _, playerId in ipairs(players) do
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)
            
            if distance <= radius then
                local targetServerId = GetPlayerServerId(playerId)
                -- Check if this is the wanted person (would need server verification)
                table.insert(nearbyWanted, {
                    serverId = targetServerId,
                    ped = targetPed,
                    distance = distance,
                    wanted = wanted
                })
            end
        end
    end
    
    return nearbyWanted
end

-- Start capture process
RegisterNetEvent('lxr-wantedboard:client:startCaptureAnimation', function(targetId)
    if IsCapturing then return end
    
    IsCapturing = true
    local playerPed = PlayerPedId()
    
    -- Load animation
    RequestAnimDict('amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop')
    while not HasAnimDictLoaded('amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop') do
        Citizen.Wait(10)
    end
    
    -- Play capture animation
    TaskPlayAnim(playerPed, 'amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop', 'exit_front', 8.0, -8.0, 5000, 1, 0, false, false, false)
    
    -- Wait for animation
    Citizen.Wait(5000)
    
    IsCapturing = false
end)

-- Capture complete
RegisterNetEvent('lxr-wantedboard:client:captureComplete', function(success, message)
    if success then
        Framework.Notify(message, 'success')
    else
        Framework.Notify(message, 'error')
    end
end)

-- Monitor nearby wanted criminals (for bounty hunters)
Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        
        if Framework.IsBountyHunter() then
            local nearbyWanted = GetNearbyWanted(Config.BountyHunters.captureRadius + 5.0)
            
            if #nearbyWanted > 0 then
                sleep = 500
                
                for _, target in ipairs(nearbyWanted) do
                    local targetCoords = GetEntityCoords(target.ped)
                    
                    if target.distance <= 2.0 and not IsCapturing then
                        Utils.DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0, 
                            string.format('~r~WANTED~w~\n%s\n$%s', target.wanted.name, target.wanted.reward))
                        
                        if IsControlJustReleased(0, 0xCEFD9220) then -- E key
                            TriggerServerEvent('lxr-wantedboard:server:captureWanted', target.serverId, target.wanted.id)
                        end
                    end
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ COMMANDS ██████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Open wanted list command
RegisterCommand('wantedlist', function()
    TriggerEvent('lxr-wantedboard:client:openWantedList')
end, false)

-- Open wanted board command
RegisterCommand('wantedboard', function()
    TriggerEvent('lxr-wantedboard:client:openBoard')
end, false)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ INITIALIZATION ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    -- Wait for player to be loaded
    while not Framework.PlayerData or not Framework.PlayerData.citizenid do
        Citizen.Wait(100)
    end
    
    -- Request initial wanted list
    RequestWantedList()
    
    Utils.Debug('LXR Wanted Board client initialized')
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
