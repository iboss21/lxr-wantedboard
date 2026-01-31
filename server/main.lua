--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Main Server Logic
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

print([[
^3
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Enyo Wanted Board System
   Version: 1.0.0 | Author: iBoss | Website: wolves.land
^7]])

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ GLOBAL VARIABLES ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

local ActiveCaptures = {} -- Track active captures to prevent duplicates

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ WANTED POSTER MANAGEMENT ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Create wanted poster
RegisterNetEvent('lxr-wantedboard:server:createWanted', function(data)
    local src = source
    
    -- Validate permissions
    if not Framework.IsLawEnforcement(src) then
        Framework.Notify(src, _U('not_law_enforcement'), 'error')
        return
    end
    
    if not Framework.HasRequiredGrade(src, Config.MinimumGrades.createWanted) then
        Framework.Notify(src, _U('error_insufficient_grade'), 'error')
        return
    end
    
    -- Validate data
    if not data.citizenid or not data.name or not data.crimes or not Utils.ValidateCrimes(data.crimes) then
        Framework.Notify(src, _U('error_invalid_data'), 'error')
        return
    end
    
    if not Utils.ValidateBountyAmount(data.reward) then
        Framework.Notify(src, _U('error_invalid_amount'), 'error')
        return
    end
    
    -- Check if already wanted
    Database.GetWantedByCitizenId(data.citizenid, function(existing)
        if existing then
            Framework.Notify(src, _U('already_wanted'), 'error')
            return
        end
        
        -- Get issuer info
        local issuerCid = Framework.GetPlayerIdentifier(src)
        local issuerName = Framework.GetPlayerName(src)
        
        -- Calculate expiration
        local expiresAt = nil
        if Config.WantedPosters.expirationEnabled then
            expiresAt = os.date('%Y-%m-%d %H:%M:%S', os.time() + (data.expiration or Config.WantedPosters.defaultExpiration))
        end
        
        -- Create wanted poster
        local wantedData = {
            citizenid = data.citizenid,
            name = data.name,
            alias = data.alias,
            crimes = data.crimes,
            description = data.description,
            reward = data.reward,
            danger_level = data.danger_level or 'low',
            last_seen = data.last_seen,
            issued_by = issuerCid,
            issued_by_name = issuerName,
            expires_at = expiresAt,
            sketch_data = data.sketch_data
        }
        
        Database.CreateWanted(wantedData, function(id)
            if id then
                Framework.Notify(src, _U('poster_created'), 'success')
                
                -- Notify all law enforcement
                if Config.USNationalArchive.notifyOnNewWanted then
                    Framework.NotifyAllLaw('New wanted poster created for ' .. data.name, 'info')
                end
                
                -- Notify target player if online
                for _, playerId in ipairs(GetPlayers()) do
                    local targetSrc = tonumber(playerId)
                    local targetCid = Framework.GetPlayerIdentifier(targetSrc)
                    if targetCid == data.citizenid then
                        local crimesText = table.concat(data.crimes, ', ')
                        Framework.Notify(targetSrc, _U('you_are_wanted', crimesText), 'error')
                        break
                    end
                end
                
                -- Refresh wanted list for all clients
                TriggerClientEvent('lxr-wantedboard:client:refreshWanted', -1)
                
                -- Log
                if Config.Logging.enabled and Config.Logging.logCreation then
                    Utils.Debug('Wanted poster created for ' .. data.name .. ' by ' .. issuerName)
                end
            else
                Framework.Notify(src, _U('error_database'), 'error')
            end
        end)
    end)
end)

-- Update wanted poster
RegisterNetEvent('lxr-wantedboard:server:updateWanted', function(id, data)
    local src = source
    
    -- Validate permissions
    if not Framework.IsLawEnforcement(src) then
        Framework.Notify(src, _U('not_law_enforcement'), 'error')
        return
    end
    
    if not Framework.HasRequiredGrade(src, Config.MinimumGrades.editWanted) then
        Framework.Notify(src, _U('error_insufficient_grade'), 'error')
        return
    end
    
    -- Update poster
    Database.UpdateWanted(id, data, function(success)
        if success then
            Framework.Notify(src, _U('poster_updated'), 'success')
            TriggerClientEvent('lxr-wantedboard:client:refreshWanted', -1)
            
            if Config.Logging.enabled and Config.Logging.logEdits then
                Utils.Debug('Wanted poster #' .. id .. ' updated by ' .. Framework.GetPlayerName(src))
            end
        else
            Framework.Notify(src, _U('error_database'), 'error')
        end
    end)
end)

-- Remove wanted poster
RegisterNetEvent('lxr-wantedboard:server:removeWanted', function(id, reason)
    local src = source
    
    -- Validate permissions
    if not Framework.IsLawEnforcement(src) then
        Framework.Notify(src, _U('not_law_enforcement'), 'error')
        return
    end
    
    if not Framework.HasRequiredGrade(src, Config.MinimumGrades.removeWanted) then
        Framework.Notify(src, _U('error_insufficient_grade'), 'error')
        return
    end
    
    -- Get wanted data before removing
    Database.GetWantedById(id, function(wantedData)
        if not wantedData then
            Framework.Notify(src, _U('not_wanted'), 'error')
            return
        end
        
        -- Archive if enabled
        if Config.USNationalArchive.enabled and Config.USNationalArchive.autoArchive then
            Database.ArchiveWanted(wantedData, reason or 'removed', nil, nil)
        end
        
        -- Remove from active list
        Database.RemoveWanted(id, function(success)
            if success then
                Framework.Notify(src, _U('poster_removed'), 'success')
                TriggerClientEvent('lxr-wantedboard:client:refreshWanted', -1)
                
                if Config.Logging.enabled and Config.Logging.logRemoval then
                    Utils.Debug('Wanted poster #' .. id .. ' removed by ' .. Framework.GetPlayerName(src))
                end
            else
                Framework.Notify(src, _U('error_database'), 'error')
            end
        end)
    end)
end)

-- Get all wanted posters
RegisterNetEvent('lxr-wantedboard:server:getWanted', function()
    local src = source
    
    Database.GetAllWanted(function(result)
        local wantedList = {}
        if result then
            for _, wanted in ipairs(result) do
                table.insert(wantedList, {
                    id = wanted.id,
                    citizenid = wanted.citizenid,
                    name = wanted.name,
                    alias = wanted.alias,
                    crimes = json.decode(wanted.crimes),
                    description = wanted.description,
                    reward = wanted.reward,
                    danger_level = wanted.danger_level,
                    last_seen = wanted.last_seen,
                    issued_by_name = wanted.issued_by_name,
                    created_at = wanted.created_at,
                    expires_at = wanted.expires_at,
                    sketch_data = wanted.sketch_data
                })
            end
        end
        
        TriggerClientEvent('lxr-wantedboard:client:receiveWanted', src, wantedList)
    end)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ BOUNTY HUNTING ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Capture wanted criminal
RegisterNetEvent('lxr-wantedboard:server:captureCriminal', function(targetSource)
    local src = source
    local targetSrc = tonumber(targetSource)
    
    -- Validate bounty hunter
    if not Framework.IsBountyHunter(src) and not Framework.IsLawEnforcement(src) then
        Framework.Notify(src, _U('not_bounty_hunter'), 'error')
        return
    end
    
    -- Check for license if required
    if Config.BountyHunters.requireLicense and Framework.IsBountyHunter(src) then
        if not Framework.HasItem(src, Config.BountyHunters.licenseItem) then
            Framework.Notify(src, _U('no_license'), 'error')
            return
        end
    end
    
    -- Check for handcuffs if required
    if Config.BountyHunters.requireHandcuffs then
        if not Framework.HasItem(src, Config.BountyHunters.handcuffItem) then
            Framework.Notify(src, _U('error_no_handcuffs'), 'error')
            return
        end
    end
    
    -- Check if target is wanted
    local targetCid = Framework.GetPlayerIdentifier(targetSrc)
    Database.GetWantedByCitizenId(targetCid, function(wanted)
        if not wanted then
            Framework.Notify(src, _U('not_wanted'), 'error')
            return
        end
        
        -- Check for active capture cooldown
        if ActiveCaptures[targetCid] then
            Framework.Notify(src, _U('capture_in_progress'), 'error')
            return
        end
        
        -- Mark as being captured
        ActiveCaptures[targetCid] = {
            hunter = src,
            target = targetSrc,
            wantedId = wanted.id,
            timestamp = os.time()
        }
        
        -- Notify target
        Framework.Notify(targetSrc, _U('you_are_captured'), 'error')
        
        -- Trigger capture animation
        TriggerClientEvent('lxr-wantedboard:client:startCaptureAnimation', src, targetSrc)
        
        -- Wait for capture to complete
        Citizen.SetTimeout(Config.Capture.captureTime, function()
            -- Check if capture is still active
            if ActiveCaptures[targetCid] and ActiveCaptures[targetCid].hunter == src then
                -- Check resist chance
                if Config.Capture.canResist and math.random() < Config.Capture.resistChance then
                    Framework.Notify(src, _U('criminal_resisted'), 'error')
                    Framework.Notify(targetSrc, 'You resisted capture!', 'success')
                    ActiveCaptures[targetCid] = nil
                    return
                end
                
                -- Capture successful
                Framework.Notify(src, _U('capture_successful'), 'success')
                
                -- Notify law enforcement
                if Config.Capture.notifyLawmen then
                    Framework.NotifyAllLaw(Framework.GetPlayerName(src) .. ' captured ' .. wanted.name, 'info')
                end
                
                -- Allow hunter to claim reward
                TriggerClientEvent('lxr-wantedboard:client:captureComplete', src, wanted)
            end
        end)
    end)
end)

-- Claim bounty reward
RegisterNetEvent('lxr-wantedboard:server:claimReward', function(wantedId, isDead)
    local src = source
    
    -- Get wanted poster
    Database.GetWantedById(wantedId, function(wanted)
        if not wanted or wanted.is_active == 0 then
            Framework.Notify(src, _U('not_wanted'), 'error')
            return
        end
        
        -- Calculate reward
        local reward = wanted.reward
        if isDead and Config.Capture.acceptDead then
            reward = math.floor(reward * Config.Capture.deadRewardPercent)
        elseif isDead and not Config.Capture.acceptDead then
            Framework.Notify(src, 'Dead bounties not accepted', 'error')
            return
        end
        
        -- Add bonus for alive
        if not isDead and Config.Capture.bonusForAlive > 0 then
            reward = reward + Config.Capture.bonusForAlive
        end
        
        -- Calculate splits
        local hunterReward = math.floor(reward * Config.BountyHunters.rewardPercentage)
        local stateCut = reward - hunterReward
        
        -- Pay hunter
        Framework.AddMoney(src, hunterReward, 'cash', 'Bounty reward')
        Framework.Notify(src, _U('reward_claimed', Utils.FormatCurrency(hunterReward)), 'success')
        
        -- Archive wanted poster
        if Config.USNationalArchive.enabled and Config.USNationalArchive.archiveOnCapture then
            local hunterCid = Framework.GetPlayerIdentifier(src)
            local hunterName = Framework.GetPlayerName(src)
            Database.ArchiveWanted(wanted, 'captured', hunterCid, hunterName)
        end
        
        -- Remove from active wanted list
        Database.RemoveWanted(wantedId)
        
        -- Clear capture data
        ActiveCaptures[wanted.citizenid] = nil
        
        -- Refresh wanted list
        TriggerClientEvent('lxr-wantedboard:client:refreshWanted', -1)
        
        -- Log
        if Config.Logging.enabled and Config.Logging.logRewards then
            Utils.Debug(Framework.GetPlayerName(src) .. ' claimed reward for ' .. wanted.name .. ': $' .. hunterReward)
        end
    end)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ ARCHIVE MANAGEMENT ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Get archive
RegisterNetEvent('lxr-wantedboard:server:getArchive', function()
    local src = source
    
    -- Validate permissions
    if not Framework.IsLawEnforcement(src) then
        Framework.Notify(src, _U('not_law_enforcement'), 'error')
        return
    end
    
    if not Framework.HasRequiredGrade(src, Config.MinimumGrades.viewArchive) then
        Framework.Notify(src, _U('error_insufficient_grade'), 'error')
        return
    end
    
    Database.GetAllArchived(function(result)
        TriggerClientEvent('lxr-wantedboard:client:receiveArchive', src, result or {})
    end)
end)

-- Search archive
RegisterNetEvent('lxr-wantedboard:server:searchArchive', function(searchTerm)
    local src = source
    
    -- Validate permissions
    if not Framework.IsLawEnforcement(src) then
        Framework.Notify(src, _U('not_law_enforcement'), 'error')
        return
    end
    
    Database.SearchArchive(searchTerm, function(result)
        TriggerClientEvent('lxr-wantedboard:client:receiveSearchResults', src, result or {})
    end)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████████ COMMANDS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- View wanted list
if Config.Commands.viewWantedCommand.enabled then
    RegisterCommand(Config.Commands.viewWantedCommand.command, function(source, args, rawCommand)
        TriggerClientEvent('lxr-wantedboard:client:openWantedList', source)
    end, false)
end

-- Open wanted board (law enforcement)
if Config.Commands.openBoardCommand.enabled then
    RegisterCommand(Config.Commands.openBoardCommand.command, function(source, args, rawCommand)
        local src = source
        if not Framework.IsLawEnforcement(src) then
            Framework.Notify(src, _U('not_law_enforcement'), 'error')
            return
        end
        TriggerClientEvent('lxr-wantedboard:client:openBoard', src)
    end, false)
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ CALLBACKS & EVENTS ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Get player wanted status
RegisterNetEvent('lxr-wantedboard:server:checkWantedStatus', function(targetSource)
    local src = source
    local targetSrc = tonumber(targetSource or src)
    
    local targetCid = Framework.GetPlayerIdentifier(targetSrc)
    Database.GetWantedByCitizenId(targetCid, function(wanted)
        TriggerClientEvent('lxr-wantedboard:client:receiveWantedStatus', src, wanted ~= nil, wanted)
    end)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ INITIALIZATION ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('^2[LXR Wanted Board]^7 Server started successfully')
    print('^2[LXR Wanted Board]^7 Framework: ^3' .. Config.Framework .. '^7')
    print('^2[LXR Wanted Board]^7 Database: ^3' .. Config.Database.resource .. '^7')
    
    -- Get statistics
    Database.GetStatistics(function(stats)
        if stats then
            print('^2[LXR Wanted Board]^7 Active Wanted: ^3' .. (stats.active_wanted or 0) .. '^7')
            print('^2[LXR Wanted Board]^7 Total Archived: ^3' .. (stats.total_archived or 0) .. '^7')
            print('^2[LXR Wanted Board]^7 Total Captured: ^3' .. (stats.total_captured or 0) .. '^7')
        end
    end)
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
