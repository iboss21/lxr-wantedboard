--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Shared Utilities
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

Utils = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ GENERAL UTILITIES █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Round number to decimal places
function Utils.Round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Format currency
function Utils.FormatCurrency(amount)
    return '$' .. Utils.FormatNumber(amount)
end

-- Format number with commas
function Utils.FormatNumber(amount)
    local formatted = tostring(amount)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

-- Get distance between two coords
function Utils.GetDistance(coords1, coords2)
    if not coords1 or not coords2 then return 0 end
    return #(vector3(coords1.x, coords1.y, coords1.z) - vector3(coords2.x, coords2.y, coords2.z))
end

-- Check if player is in range of coords
function Utils.IsInRange(playerCoords, targetCoords, range)
    return Utils.GetDistance(playerCoords, targetCoords) <= range
end

-- Trim string
function Utils.Trim(str)
    if not str then return '' end
    return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

-- Deep copy table
function Utils.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Utils.DeepCopy(orig_key)] = Utils.DeepCopy(orig_value)
        end
        setmetatable(copy, Utils.DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ TIME & DATE UTILITIES ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Get current timestamp
function Utils.GetTimestamp()
    return os.time()
end

-- Format timestamp to date string
function Utils.FormatDate(timestamp)
    return os.date('%Y-%m-%d %H:%M:%S', timestamp)
end

-- Get time difference in readable format
function Utils.GetTimeDifference(timestamp)
    local diff = os.time() - timestamp
    if diff < 60 then
        return diff .. ' seconds ago'
    elseif diff < 3600 then
        return math.floor(diff / 60) .. ' minutes ago'
    elseif diff < 86400 then
        return math.floor(diff / 3600) .. ' hours ago'
    else
        return math.floor(diff / 86400) .. ' days ago'
    end
end

-- Check if bounty is expired
function Utils.IsBountyExpired(expirationTime)
    return os.time() >= expirationTime
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ STRING UTILITIES ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Capitalize first letter
function Utils.Capitalize(str)
    if not str or str == '' then return '' end
    return str:sub(1,1):upper() .. str:sub(2):lower()
end

-- Title case (capitalize each word)
function Utils.TitleCase(str)
    if not str or str == '' then return '' end
    return str:gsub('(%a)([%w_]*)', function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

-- Generate random string
function Utils.RandomString(length)
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    local str = ''
    for i = 1, length do
        local rand = math.random(1, #chars)
        str = str .. chars:sub(rand, rand)
    end
    return str
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ BOUNTY UTILITIES ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Calculate bounty reward based on crimes
function Utils.CalculateBountyReward(crimes)
    local total = 0
    if not crimes or #crimes == 0 then
        return Config.WantedPosters.defaultReward
    end
    
    for _, crimeValue in ipairs(crimes) do
        for _, crime in ipairs(Config.WantedPosters.crimes) do
            if crime.value == crimeValue then
                total = total + crime.baseReward
                break
            end
        end
    end
    
    -- Apply bonus for multiple crimes
    if #crimes > 1 then
        total = total * (1 + (#crimes - 1) * Config.Capture.bonusForMultiple)
    end
    
    -- Clamp to min/max
    total = math.max(Config.WantedPosters.minReward, math.min(Config.WantedPosters.maxReward, total))
    
    return Utils.Round(total, 0)
end

-- Get crime label by value
function Utils.GetCrimeLabel(crimeValue)
    for _, crime in ipairs(Config.WantedPosters.crimes) do
        if crime.value == crimeValue then
            return crime.label
        end
    end
    return 'Unknown Crime'
end

-- Get danger level label
function Utils.GetDangerLevelLabel(dangerValue)
    for _, level in ipairs(Config.WantedPosters.dangerLevels) do
        if level.value == dangerValue then
            return level.label
        end
    end
    return 'Unknown'
end

-- Get danger level color
function Utils.GetDangerLevelColor(dangerValue)
    for _, level in ipairs(Config.WantedPosters.dangerLevels) do
        if level.value == dangerValue then
            return level.color
        end
    end
    return '#FFFFFF'
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ VALIDATION UTILITIES ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Validate bounty amount
function Utils.ValidateBountyAmount(amount)
    if type(amount) ~= 'number' then return false end
    return amount >= Config.WantedPosters.minReward and amount <= Config.WantedPosters.maxReward
end

-- Validate crimes list
function Utils.ValidateCrimes(crimes)
    if not crimes or type(crimes) ~= 'table' or #crimes == 0 then return false end
    
    for _, crimeValue in ipairs(crimes) do
        local found = false
        for _, crime in ipairs(Config.WantedPosters.crimes) do
            if crime.value == crimeValue then
                found = true
                break
            end
        end
        if not found then return false end
    end
    
    return true
end

-- Validate danger level
function Utils.ValidateDangerLevel(dangerValue)
    for _, level in ipairs(Config.WantedPosters.dangerLevels) do
        if level.value == dangerValue then
            return true
        end
    end
    return false
end

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████ DEBUG UTILITIES ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Debug print
function Utils.Debug(...)
    if Config.Debug then
        print('^3[LXR Wanted Board - DEBUG]^7', ...)
    end
end

-- Print table
function Utils.PrintTable(tbl, indent)
    if not Config.Debug then return end
    indent = indent or 0
    for k, v in pairs(tbl) do
        local formatting = string.rep('  ', indent) .. k .. ': '
        if type(v) == 'table' then
            print(formatting)
            Utils.PrintTable(v, indent + 1)
        else
            print(formatting .. tostring(v))
        end
    end
end

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
