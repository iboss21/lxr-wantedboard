--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Database Management
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

Database = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DATABASE INITIALIZATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    if not Config.Database.enabled or not Config.Database.autoCreateTable then
        return
    end
    
    -- Create wanted board table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `lxr_wanted_board` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `citizenid` VARCHAR(50) NOT NULL,
            `name` VARCHAR(100) NOT NULL,
            `alias` VARCHAR(100) DEFAULT NULL,
            `crimes` TEXT NOT NULL,
            `description` TEXT DEFAULT NULL,
            `reward` INT(11) NOT NULL DEFAULT 100,
            `danger_level` VARCHAR(20) NOT NULL DEFAULT 'low',
            `last_seen` VARCHAR(100) DEFAULT NULL,
            `issued_by` VARCHAR(50) NOT NULL,
            `issued_by_name` VARCHAR(100) NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `expires_at` TIMESTAMP NULL DEFAULT NULL,
            `is_active` TINYINT(1) NOT NULL DEFAULT 1,
            `sketch_data` TEXT DEFAULT NULL,
            PRIMARY KEY (`id`),
            KEY `citizenid` (`citizenid`),
            KEY `is_active` (`is_active`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])
    
    -- Create archive table (US National Archive)
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `lxr_wanted_archive` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `wanted_id` INT(11) DEFAULT NULL,
            `citizenid` VARCHAR(50) NOT NULL,
            `name` VARCHAR(100) NOT NULL,
            `alias` VARCHAR(100) DEFAULT NULL,
            `crimes` TEXT NOT NULL,
            `description` TEXT DEFAULT NULL,
            `reward` INT(11) NOT NULL,
            `danger_level` VARCHAR(20) NOT NULL,
            `issued_by` VARCHAR(50) NOT NULL,
            `issued_by_name` VARCHAR(100) NOT NULL,
            `captured_by` VARCHAR(50) DEFAULT NULL,
            `captured_by_name` VARCHAR(100) DEFAULT NULL,
            `archived_reason` VARCHAR(50) NOT NULL,
            `created_at` TIMESTAMP NOT NULL,
            `archived_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `sketch_data` TEXT DEFAULT NULL,
            PRIMARY KEY (`id`),
            KEY `citizenid` (`citizenid`),
            KEY `wanted_id` (`wanted_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])
    
    print('^2[LXR Wanted Board]^7 Database tables initialized')
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ WANTED OPERATIONS █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Create wanted poster
function Database.CreateWanted(data, callback)
    MySQL.insert('INSERT INTO `lxr_wanted_board` (citizenid, name, alias, crimes, description, reward, danger_level, last_seen, issued_by, issued_by_name, expires_at, sketch_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        data.citizenid,
        data.name,
        data.alias or '',
        json.encode(data.crimes),
        data.description or '',
        data.reward,
        data.danger_level or 'low',
        data.last_seen or '',
        data.issued_by,
        data.issued_by_name,
        data.expires_at,
        data.sketch_data or ''
    }, function(id)
        if callback then callback(id) end
    end)
end

-- Get all active wanted posters
function Database.GetAllWanted(callback)
    MySQL.query('SELECT * FROM `lxr_wanted_board` WHERE is_active = 1 ORDER BY created_at DESC', {}, function(result)
        if callback then callback(result) end
    end)
end

-- Get wanted poster by citizenid
function Database.GetWantedByCitizenId(citizenid, callback)
    MySQL.query('SELECT * FROM `lxr_wanted_board` WHERE citizenid = ? AND is_active = 1', {citizenid}, function(result)
        if callback then callback(result[1]) end
    end)
end

-- Get wanted poster by ID
function Database.GetWantedById(id, callback)
    MySQL.query('SELECT * FROM `lxr_wanted_board` WHERE id = ?', {id}, function(result)
        if callback then callback(result[1]) end
    end)
end

-- Update wanted poster
function Database.UpdateWanted(id, data, callback)
    local updateFields = {}
    local updateValues = {}
    
    if data.alias then
        table.insert(updateFields, 'alias = ?')
        table.insert(updateValues, data.alias)
    end
    if data.crimes then
        table.insert(updateFields, 'crimes = ?')
        table.insert(updateValues, json.encode(data.crimes))
    end
    if data.description then
        table.insert(updateFields, 'description = ?')
        table.insert(updateValues, data.description)
    end
    if data.reward then
        table.insert(updateFields, 'reward = ?')
        table.insert(updateValues, data.reward)
    end
    if data.danger_level then
        table.insert(updateFields, 'danger_level = ?')
        table.insert(updateValues, data.danger_level)
    end
    if data.last_seen then
        table.insert(updateFields, 'last_seen = ?')
        table.insert(updateValues, data.last_seen)
    end
    
    if #updateFields == 0 then
        if callback then callback(false) end
        return
    end
    
    table.insert(updateValues, id)
    
    local query = 'UPDATE `lxr_wanted_board` SET ' .. table.concat(updateFields, ', ') .. ' WHERE id = ?'
    
    MySQL.update(query, updateValues, function(affectedRows)
        if callback then callback(affectedRows > 0) end
    end)
end

-- Remove wanted poster (set inactive)
function Database.RemoveWanted(id, callback)
    MySQL.update('UPDATE `lxr_wanted_board` SET is_active = 0 WHERE id = ?', {id}, function(affectedRows)
        if callback then callback(affectedRows > 0) end
    end)
end

-- Delete wanted poster permanently
function Database.DeleteWanted(id, callback)
    MySQL.execute('DELETE FROM `lxr_wanted_board` WHERE id = ?', {id}, function(result)
        if callback then callback(result) end
    end)
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ ARCHIVE OPERATIONS ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Archive wanted poster
function Database.ArchiveWanted(wantedData, reason, capturedBy, capturedByName, callback)
    MySQL.insert('INSERT INTO `lxr_wanted_archive` (wanted_id, citizenid, name, alias, crimes, description, reward, danger_level, issued_by, issued_by_name, captured_by, captured_by_name, archived_reason, created_at, sketch_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        wantedData.id,
        wantedData.citizenid,
        wantedData.name,
        wantedData.alias or '',
        wantedData.crimes,
        wantedData.description or '',
        wantedData.reward,
        wantedData.danger_level,
        wantedData.issued_by,
        wantedData.issued_by_name,
        capturedBy or '',
        capturedByName or '',
        reason,
        wantedData.created_at,
        wantedData.sketch_data or ''
    }, function(id)
        if callback then callback(id) end
    end)
end

-- Get all archived records
function Database.GetAllArchived(callback)
    MySQL.query('SELECT * FROM `lxr_wanted_archive` ORDER BY archived_at DESC', {}, function(result)
        if callback then callback(result) end
    end)
end

-- Search archive
function Database.SearchArchive(searchTerm, callback)
    MySQL.query('SELECT * FROM `lxr_wanted_archive` WHERE name LIKE ? OR alias LIKE ? OR citizenid LIKE ? ORDER BY archived_at DESC', {
        '%' .. searchTerm .. '%',
        '%' .. searchTerm .. '%',
        '%' .. searchTerm .. '%'
    }, function(result)
        if callback then callback(result) end
    end)
end

-- Get archive by citizenid
function Database.GetArchiveByCitizenId(citizenid, callback)
    MySQL.query('SELECT * FROM `lxr_wanted_archive` WHERE citizenid = ? ORDER BY archived_at DESC', {citizenid}, function(result)
        if callback then callback(result) end
    end)
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ MAINTENANCE OPERATIONS ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Check for expired bounties
function Database.CheckExpiredBounties()
    MySQL.query('SELECT * FROM `lxr_wanted_board` WHERE is_active = 1 AND expires_at IS NOT NULL AND expires_at < NOW()', {}, function(result)
        if result and #result > 0 then
            for _, wanted in ipairs(result) do
                -- Archive expired bounty
                if Config.USNationalArchive.enabled and Config.USNationalArchive.archiveOnExpire then
                    Database.ArchiveWanted(wanted, 'expired', nil, nil, function()
                        Utils.Debug('Archived expired bounty for ' .. wanted.name)
                    end)
                end
                
                -- Remove from active list
                Database.RemoveWanted(wanted.id, function()
                    Utils.Debug('Removed expired bounty for ' .. wanted.name)
                    
                    -- Notify law enforcement
                    if Config.WantedPosters.notifyOnExpiration then
                        Framework.NotifyAllLaw('Wanted poster for ' .. wanted.name .. ' has expired', 'info')
                    end
                end)
            end
        end
    end)
end

-- Start expiration check thread
Citizen.CreateThread(function()
    if not Config.WantedPosters.expirationEnabled then return end
    
    while true do
        Database.CheckExpiredBounties()
        Citizen.Wait(300000) -- Check every 5 minutes
    end
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ STATISTICS OPERATIONS █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Get statistics
function Database.GetStatistics(callback)
    MySQL.query([[
        SELECT 
            (SELECT COUNT(*) FROM lxr_wanted_board WHERE is_active = 1) as active_wanted,
            (SELECT COUNT(*) FROM lxr_wanted_archive) as total_archived,
            (SELECT COUNT(*) FROM lxr_wanted_archive WHERE archived_reason = 'captured') as total_captured,
            (SELECT SUM(reward) FROM lxr_wanted_board WHERE is_active = 1) as total_active_rewards
    ]], {}, function(result)
        if callback then callback(result[1]) end
    end)
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████ PLACED POSTERS DATABASE ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Create placed poster
function Database.CreatePlacedPoster(data, callback)
    MySQL.insert('INSERT INTO lxr_placed_posters (wanted_id, poster_data, coords_x, coords_y, coords_z, heading, placed_by, placed_by_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        data.wanted_id,
        data.poster_data,
        data.coords_x,
        data.coords_y,
        data.coords_z,
        data.heading,
        data.placed_by,
        data.placed_by_name
    }, function(id)
        callback(id)
    end)
end

-- Get all placed posters
function Database.GetAllPlacedPosters(callback)
    MySQL.query('SELECT * FROM lxr_placed_posters ORDER BY placed_at DESC', {}, function(result)
        callback(result)
    end)
end

-- Get placed poster by ID
function Database.GetPlacedPosterById(id, callback)
    MySQL.single('SELECT * FROM lxr_placed_posters WHERE id = ?', { id }, function(result)
        callback(result)
    end)
end

-- Get nearby placed posters
function Database.GetNearbyPlacedPosters(x, y, z, radius, callback)
    MySQL.query([[
        SELECT *,
        SQRT(POW(coords_x - ?, 2) + POW(coords_y - ?, 2) + POW(coords_z - ?, 2)) as distance
        FROM lxr_placed_posters
        HAVING distance <= ?
        ORDER BY distance ASC
    ]], { x, y, z, radius }, function(result)
        callback(result)
    end)
end

-- Remove placed poster
function Database.RemovePlacedPoster(id, callback)
    MySQL.query('DELETE FROM lxr_placed_posters WHERE id = ?', { id }, function(result)
        local success = result and result.affectedRows and result.affectedRows > 0
        callback(success)
    end)
end

-- Remove all placed posters for a wanted ID
function Database.RemovePlacedPostersByWantedId(wantedId, callback)
    MySQL.query('DELETE FROM lxr_placed_posters WHERE wanted_id = ?', { wantedId }, function(result)
        if callback then 
            local success = result and result.affectedRows and result.affectedRows > 0
            callback(success)
        end
    end)
end

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
