--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Poster Placement & Interaction System
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ GLOBAL VARIABLES ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local PlacedPosters = {} -- Table of all placed posters in world
local NearbyPosters = {} -- Posters currently near the player
local IsPlacingPoster = false -- Flag for placement mode
local CurrentPosterData = nil -- Data for poster being placed

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ POSTER ITEM USAGE ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Use wanted poster item
RegisterNetEvent('lxr-wantedboard:client:usePoster', function(posterData)
    if not posterData then
        Utils.Notify(_U('error_invalid_poster'), 'error')
        return
    end
    
    -- Show poster UI with two options: View or Place
    SendNUIMessage({
        action = 'showPosterOptions',
        data = posterData
    })
    SetNuiFocus(true, true)
end)

-- Handle poster option selection from UI
RegisterNUICallback('posterOption', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
    
    if data.option == 'view' then
        -- Just view the poster
        ViewPoster(CurrentPosterData or data.posterData)
    elseif data.option == 'place' then
        -- Enter placement mode
        EnterPlacementMode(CurrentPosterData or data.posterData)
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ POSTER VIEWING SYSTEM █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- View a poster
function ViewPoster(posterData)
    if not posterData then return end
    
    SendNUIMessage({
        action = 'showPoster',
        data = posterData
    })
    SetNuiFocus(true, true)
end

-- Close poster view
RegisterNUICallback('closePoster', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ POSTER PLACEMENT SYSTEM ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Enter placement mode
function EnterPlacementMode(posterData)
    if not Config.PosterPlacement.enabled then
        Utils.Notify(_U('poster_placement_disabled'), 'error')
        return
    end
    
    IsPlacingPoster = true
    CurrentPosterData = posterData
    
    Utils.Notify(_U('poster_placement_mode'), 'info')
    Utils.Notify(_U('poster_placement_instructions'), 'info')
    
    -- Start placement thread
    Citizen.CreateThread(function()
        while IsPlacingPoster do
            local sleep = 0
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            -- Raycast to find wall
            local hit, coords, surfaceNormal, entity = RaycastFromCamera(Config.PosterPlacement.raycastDistance)
            
            if hit then
                -- Draw placement preview
                DrawMarker(
                    28, -- Marker type
                    coords.x, coords.y, coords.z,
                    0, 0, 0,
                    0, 0, 0,
                    0.3, 0.3, 0.3,
                    100, 200, 100, 100,
                    false, false, 2, false, nil, nil, false
                )
                
                -- Show instructions
                Utils.DrawText3D(coords.x, coords.y, coords.z + 0.3, _U('press_to_place'))
                
                -- Place poster on E press
                if IsControlJustReleased(0, Config.PosterPlacement.keys.interact) then
                    PlacePoster(coords, surfaceNormal)
                end
            end
            
            -- Cancel on G press
            if IsControlJustReleased(0, Config.PosterPlacement.keys.cancel) then
                ExitPlacementMode()
            end
            
            Citizen.Wait(sleep)
        end
    end)
end

-- Exit placement mode
function ExitPlacementMode()
    IsPlacingPoster = false
    CurrentPosterData = nil
    Utils.Notify(_U('poster_placement_cancelled'), 'info')
end

-- Place poster at location
function PlacePoster(coords, surfaceNormal)
    if not CurrentPosterData then return end
    
    -- Calculate heading from surface normal
    local heading = GetHeadingFromVector_2d(surfaceNormal.x, surfaceNormal.y)
    
    -- Send to server to save
    TriggerServerEvent('lxr-wantedboard:server:placePoster', {
        posterData = CurrentPosterData,
        coords = coords,
        heading = heading
    })
    
    ExitPlacementMode()
end

-- Raycast from camera
function RaycastFromCamera(distance)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoords = GetGameplayCamCoord()
    
    local direction = RotationToDirection(cameraRotation)
    local destination = vector3(
        cameraCoords.x + direction.x * distance,
        cameraCoords.y + direction.y * distance,
        cameraCoords.z + direction.z * distance
    )
    
    local ray = StartShapeTestRay(cameraCoords.x, cameraCoords.y, cameraCoords.z, destination.x, destination.y, destination.z, -1, playerPed, 0)
    local _, hit, endCoords, surfaceNormal, entity = GetShapeTestResult(ray)
    
    return hit == 1, endCoords, surfaceNormal, entity
end

-- Convert rotation to direction
function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████ PLACED POSTER MANAGEMENT ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Load placed posters from server
RegisterNetEvent('lxr-wantedboard:client:loadPlacedPosters', function(posters)
    PlacedPosters = posters
    Utils.Debug('Loaded ' .. #posters .. ' placed posters')
end)

-- Add a placed poster
RegisterNetEvent('lxr-wantedboard:client:addPlacedPoster', function(poster)
    table.insert(PlacedPosters, poster)
    Utils.Notify(_U('poster_placed'), 'success')
end)

-- Remove a placed poster
RegisterNetEvent('lxr-wantedboard:client:removePlacedPoster', function(posterId)
    for i, poster in ipairs(PlacedPosters) do
        if poster.id == posterId then
            table.remove(PlacedPosters, i)
            break
        end
    end
end)

-- Request placed posters on spawn
AddEventHandler('lxr-wantedboard:client:playerLoaded', function()
    TriggerServerEvent('lxr-wantedboard:server:requestPlacedPosters')
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████ PLACED POSTER INTERACTIONS ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Monitor proximity to placed posters
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        
        if Config.PosterPlacement.enabled and #PlacedPosters > 0 then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            NearbyPosters = {}
            
            for _, poster in ipairs(PlacedPosters) do
                local posterCoords = vector3(poster.coords_x, poster.coords_y, poster.coords_z)
                local distance = #(playerCoords - posterCoords)
                
                if distance < Config.PosterPlacement.interactionDistance then
                    sleep = 0
                    table.insert(NearbyPosters, poster)
                    
                    -- Draw marker
                    if Config.PosterPlacement.useMarker then
                        DrawMarker(
                            Config.PosterPlacement.markerType,
                            posterCoords.x, posterCoords.y, posterCoords.z,
                            0, 0, 0,
                            0, 0, 0,
                            Config.PosterPlacement.markerScale.x,
                            Config.PosterPlacement.markerScale.y,
                            Config.PosterPlacement.markerScale.z,
                            Config.PosterPlacement.markerColor.r,
                            Config.PosterPlacement.markerColor.g,
                            Config.PosterPlacement.markerColor.b,
                            Config.PosterPlacement.markerColor.a,
                            false, false, 2, false, nil, nil, false
                        )
                    end
                    
                    -- Show interaction prompt
                    Utils.DrawText3D(posterCoords.x, posterCoords.y, posterCoords.z + 0.2, _U('press_to_view_poster'))
                    
                    -- View poster on E press
                    if IsControlJustReleased(0, Config.PosterPlacement.keys.interact) then
                        TriggerServerEvent('lxr-wantedboard:server:viewPlacedPoster', poster.id)
                    end
                    
                    -- Remove poster on hold E
                    if IsControlPressed(0, Config.PosterPlacement.keys.interact) then
                        Utils.DrawText3D(posterCoords.x, posterCoords.y, posterCoords.z + 0.4, _U('hold_to_remove'))
                        
                        -- Check if held for configured duration
                        local holdStart = GetGameTimer()
                        while IsControlPressed(0, Config.PosterPlacement.keys.interact) and (GetGameTimer() - holdStart) < Config.PosterPlacement.holdDuration do
                            Citizen.Wait(0)
                        end
                        
                        if IsControlPressed(0, Config.PosterPlacement.keys.interact) and (GetGameTimer() - holdStart) >= Config.PosterPlacement.holdDuration then
                            TriggerServerEvent('lxr-wantedboard:server:removePlacedPoster', poster.id)
                        end
                    end
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- View placed poster (receive data from server)
RegisterNetEvent('lxr-wantedboard:client:viewPlacedPosterData', function(posterData)
    ViewPoster(posterData)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
