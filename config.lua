--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - SUPREME CONFIGURATION FILE
   
   This is the SUPREME CONFIGURATION FILE that controls all aspects of the wanted board system.
   All settings are consolidated here for enterprise-grade control.
   
   Minimal edits needed to server.lua and client.lua - everything is configured here!
   
   Version: 1.0.0
   Author: iBoss
   Website: wolves.land - The Land of Wolves
   Performance Target: 0.01ms server overhead, Minimal FPS impact client-side
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ███████████████████████ FRAMEWORK CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Framework = 'lxrcore' -- Options: 'lxrcore', 'rsg-core', 'qbcore', 'qbr-core', 'standalone'
Config.CoreName = 'lxr-core' -- Core resource name for LXRCore

Config.FrameworkTriggers = {
    lxrcore = {
        resource = 'lxr-core',
        getObject = 'lxr-core:getSharedObject',
        playerLoaded = 'LXR:Client:OnPlayerLoaded',
        playerUnloaded = 'LXR:Client:OnPlayerUnload',
        jobUpdate = 'LXR:Client:OnJobUpdate'
    },
    ['rsg-core'] = {
        resource = 'rsg-core',
        getObject = 'rsg-core:getSharedObject',
        playerLoaded = 'RSGCore:Client:OnPlayerLoaded',
        playerUnloaded = 'RSGCore:Client:OnPlayerUnload',
        jobUpdate = 'RSGCore:Client:OnJobUpdate'
    },
    qbcore = {
        resource = 'qb-core',
        getObject = 'qb-core:getSharedObject',
        playerLoaded = 'QBCore:Client:OnPlayerLoaded',
        playerUnloaded = 'QBCore:Client:OnPlayerUnload',
        jobUpdate = 'QBCore:Client:OnJobUpdate'
    },
    ['qbr-core'] = {
        resource = 'qbr-core',
        getObject = 'qbr-core:getSharedObject',
        playerLoaded = 'QBRCore:Client:OnPlayerLoaded',
        playerUnloaded = 'QBRCore:Client:OnPlayerUnload',
        jobUpdate = 'QBRCore:Client:OnJobUpdate'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DATABASE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Database = {
    enabled = true,
    resource = 'oxmysql', -- Options: 'oxmysql', 'mysql-async', 'ghmattimysql'
    tableName = 'lxr_wanted_board',
    archiveTableName = 'lxr_wanted_archive', -- US National Archive integration
    autoCreateTable = true -- Automatically create table if it doesn't exist
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████ US NATIONAL ARCHIVE (MDT) INTEGRATION █████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.USNationalArchive = {
    enabled = true, -- Enable integration with US National Archive
    resource = 'lxr-mdt', -- MDT resource name (leave as lxr-mdt, included in package)
    
    -- Automatic record keeping
    autoArchive = true, -- Automatically archive wanted posters
    archiveOnCapture = true, -- Archive when bounty is captured
    archiveOnExpire = true, -- Archive when bounty expires
    
    -- MDT access
    mdtJobs = { -- Jobs that can access MDT
        'sheriff',
        'marshal',
        'deputy',
        'lawman'
    },
    
    -- Search and records
    searchByName = true,
    searchByCitizenship = true,
    searchByAlias = true,
    searchByReward = true,
    
    -- Sharing between jurisdictions
    shareAcrossStates = true, -- Share wanted posters across all sheriff offices
    notifyOnNewWanted = true, -- Notify all law enforcement when new wanted poster added
    notificationRadius = 0 -- 0 = notify all lawmen regardless of distance
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SYSTEM SETTINGS ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = false -- Enable debug mode for testing
Config.UseSketchDrawing = true -- Use automatically generated sketch drawings of fugitives
Config.UsePhotography = false -- Use photographs instead of sketches (if available)

Config.Notifications = {
    type = 'native', -- Options: 'native', 'mythic_notify', 'ox_lib', 'custom'
    position = 'top-right',
    duration = 5000
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ███████████████████████ LAW ENFORCEMENT JOBS SETTINGS ██████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.LawJobs = {
    'sheriff',
    'marshal',
    'deputy',
    'lawman',
    'police'
}

-- Minimum grade required for certain actions
Config.MinimumGrades = {
    createWanted = 1, -- Create wanted poster (Deputy+)
    editWanted = 2, -- Edit wanted poster (Sheriff+)
    removeWanted = 3, -- Remove wanted poster (Marshal+)
    viewArchive = 0, -- View archive (All law enforcement)
    searchRecords = 0 -- Search records (All law enforcement)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████ BOUNTY HUNTER SETTINGS ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.BountyHunters = {
    enabled = true, -- Enable bounty hunting system
    
    -- Jobs that are bounty hunters
    jobs = {
        'bountyhunter',
        'hunter'
    },
    
    -- License requirement
    requireLicense = true,
    licenseItem = 'bounty_license', -- Item required to be bounty hunter
    licenseCost = 500, -- Cost to purchase bounty hunter license
    
    -- Bounty collection
    captureRadius = 5.0, -- Distance to capture wanted person
    requireHandcuffs = true, -- Require handcuffs to capture
    handcuffItem = 'handcuffs',
    
    -- Rewards
    rewardPercentage = 0.9, -- 90% of bounty goes to hunter
    stateCut = 0.1, -- 10% goes to state/sheriff
    
    -- Restrictions
    canCaptureInTown = false, -- Cannot capture in safe zones
    requireWitness = false, -- Require law enforcement witness
    captureAnimation = true, -- Play capture animation
    
    -- Cooldowns
    captureCooldown = 300000, -- 5 minutes between captures (same hunter)
    claimCooldown = 60000 -- 1 minute to claim reward after capture
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████ WANTED BOARD LOCATIONS ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.WantedBoards = {
    -- Saint Denis Sheriff Office
    {
        name = 'Saint Denis Sheriff Office',
        location = 'Saint Denis',
        coords = vector3(2515.29, -1306.27, 48.96),
        heading = 180.0,
        blip = {
            enabled = true,
            sprite = 'blip_ambient_sheriff',
            scale = 0.6,
            color = 'BLIP_MODIFIER_MP_COLOR_2'
        },
        
        -- Board interaction point
        boardCoords = vector3(2516.12, -1308.45, 49.45),
        boardHeading = 0.0,
        
        -- Claim reward point (Sheriff desk)
        claimCoords = vector3(2513.67, -1305.89, 48.96),
        
        -- Interaction radius
        interactionRadius = 2.5,
        
        -- Available services
        services = {
            viewWanted = true,
            createWanted = true,
            editWanted = true,
            removeWanted = true,
            claimReward = true,
            searchArchive = true
        }
    },
    
    -- Valentine Sheriff Office
    {
        name = 'Valentine Sheriff Office',
        location = 'Valentine',
        coords = vector3(-275.65, 805.12, 119.38),
        heading = 90.0,
        blip = {
            enabled = true,
            sprite = 'blip_ambient_sheriff',
            scale = 0.6,
            color = 'BLIP_MODIFIER_MP_COLOR_2'
        },
        
        boardCoords = vector3(-274.23, 806.78, 119.88),
        boardHeading = 270.0,
        claimCoords = vector3(-277.89, 803.45, 119.38),
        interactionRadius = 2.5,
        
        services = {
            viewWanted = true,
            createWanted = true,
            editWanted = true,
            removeWanted = true,
            claimReward = true,
            searchArchive = true
        }
    },
    
    -- Rhodes Sheriff Office
    {
        name = 'Rhodes Sheriff Office',
        location = 'Rhodes',
        coords = vector3(1360.35, -1301.28, 77.77),
        heading = 270.0,
        blip = {
            enabled = true,
            sprite = 'blip_ambient_sheriff',
            scale = 0.6,
            color = 'BLIP_MODIFIER_MP_COLOR_2'
        },
        
        boardCoords = vector3(1361.89, -1300.12, 78.27),
        boardHeading = 90.0,
        claimCoords = vector3(1358.45, -1302.67, 77.77),
        interactionRadius = 2.5,
        
        services = {
            viewWanted = true,
            createWanted = true,
            editWanted = true,
            removeWanted = true,
            claimReward = true,
            searchArchive = true
        }
    },
    
    -- Blackwater Sheriff Office
    {
        name = 'Blackwater Sheriff Office',
        location = 'Blackwater',
        coords = vector3(-762.12, -1268.45, 43.88),
        heading = 0.0,
        blip = {
            enabled = true,
            sprite = 'blip_ambient_sheriff',
            scale = 0.6,
            color = 'BLIP_MODIFIER_MP_COLOR_2'
        },
        
        boardCoords = vector3(-761.23, -1270.89, 44.38),
        boardHeading = 180.0,
        claimCoords = vector3(-763.78, -1266.12, 43.88),
        interactionRadius = 2.5,
        
        services = {
            viewWanted = true,
            createWanted = true,
            editWanted = true,
            removeWanted = true,
            claimReward = true,
            searchArchive = true
        }
    },
    
    -- Strawberry Sheriff Office
    {
        name = 'Strawberry Sheriff Office',
        location = 'Strawberry',
        coords = vector3(-1810.32, -353.78, 164.65),
        heading = 180.0,
        blip = {
            enabled = true,
            sprite = 'blip_ambient_sheriff',
            scale = 0.6,
            color = 'BLIP_MODIFIER_MP_COLOR_2'
        },
        
        boardCoords = vector3(-1809.45, -355.23, 165.15),
        boardHeading = 0.0,
        claimCoords = vector3(-1811.89, -351.67, 164.65),
        interactionRadius = 2.5,
        
        services = {
            viewWanted = true,
            createWanted = true,
            editWanted = true,
            removeWanted = true,
            claimReward = true,
            searchArchive = true
        }
    },
    
    -- Armadillo Sheriff Office
    {
        name = 'Armadillo Sheriff Office',
        location = 'Armadillo',
        coords = vector3(-3619.52, -2602.89, -13.35),
        heading = 90.0,
        blip = {
            enabled = true,
            sprite = 'blip_ambient_sheriff',
            scale = 0.6,
            color = 'BLIP_MODIFIER_MP_COLOR_2'
        },
        
        boardCoords = vector3(-3618.23, -2601.45, -12.85),
        boardHeading = 270.0,
        claimCoords = vector3(-3621.67, -2604.78, -13.35),
        interactionRadius = 2.5,
        
        services = {
            viewWanted = true,
            createWanted = true,
            editWanted = true,
            removeWanted = true,
            claimReward = true,
            searchArchive = true
        }
    },
    
    -- Tumbleweed Sheriff Office
    {
        name = 'Tumbleweed Sheriff Office',
        location = 'Tumbleweed',
        coords = vector3(-5533.89, -2947.23, -1.39),
        heading = 270.0,
        blip = {
            enabled = true,
            sprite = 'blip_ambient_sheriff',
            scale = 0.6,
            color = 'BLIP_MODIFIER_MP_COLOR_2'
        },
        
        boardCoords = vector3(-5532.45, -2946.78, -0.89),
        boardHeading = 90.0,
        claimCoords = vector3(-5536.12, -2948.67, -1.39),
        interactionRadius = 2.5,
        
        services = {
            viewWanted = true,
            createWanted = true,
            editWanted = true,
            removeWanted = true,
            claimReward = true,
            searchArchive = true
        }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ WANTED POSTER SETTINGS ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.WantedPosters = {
    -- Poster appearance
    useRealisticSketch = true, -- Use realistic sketch drawing
    sketchQuality = 'high', -- Options: 'low', 'medium', 'high', 'ultra'
    showAlias = true, -- Show criminal's known alias
    showCrimes = true, -- Show list of crimes
    showReward = true, -- Show cash reward
    showDeadOrAlive = true, -- Show "DEAD OR ALIVE" text
    
    -- Poster information
    includeDescription = true, -- Include physical description
    includeLastSeen = true, -- Include last known location
    includeWarning = true, -- Include danger warning
    
    -- Reward settings
    minReward = 10, -- Minimum bounty reward ($10)
    maxReward = 5000, -- Maximum bounty reward ($5000)
    defaultReward = 100, -- Default reward if not specified
    
    -- Expiration
    expirationEnabled = true,
    defaultExpiration = 604800, -- 7 days in seconds
    maxExpiration = 2592000, -- 30 days maximum
    notifyOnExpiration = true,
    
    -- Crime categories
    crimes = {
        { value = 'murder', label = 'Murder', severity = 5, baseReward = 500 },
        { value = 'attempted_murder', label = 'Attempted Murder', severity = 4, baseReward = 300 },
        { value = 'manslaughter', label = 'Manslaughter', severity = 4, baseReward = 250 },
        { value = 'assault', label = 'Assault', severity = 3, baseReward = 100 },
        { value = 'armed_robbery', label = 'Armed Robbery', severity = 4, baseReward = 300 },
        { value = 'robbery', label = 'Robbery', severity = 3, baseReward = 150 },
        { value = 'theft', label = 'Theft', severity = 2, baseReward = 50 },
        { value = 'horse_theft', label = 'Horse Theft', severity = 3, baseReward = 200 },
        { value = 'cattle_rustling', label = 'Cattle Rustling', severity = 3, baseReward = 150 },
        { value = 'arson', label = 'Arson', severity = 4, baseReward = 250 },
        { value = 'kidnapping', label = 'Kidnapping', severity = 5, baseReward = 400 },
        { value = 'train_robbery', label = 'Train Robbery', severity = 5, baseReward = 500 },
        { value = 'bank_robbery', label = 'Bank Robbery', severity = 5, baseReward = 600 },
        { value = 'jailbreak', label = 'Jailbreak', severity = 4, baseReward = 300 },
        { value = 'resisting_arrest', label = 'Resisting Arrest', severity = 2, baseReward = 75 },
        { value = 'unlawful_possession', label = 'Unlawful Possession', severity = 2, baseReward = 50 },
        { value = 'trespassing', label = 'Trespassing', severity = 1, baseReward = 25 },
        { value = 'fraud', label = 'Fraud', severity = 3, baseReward = 100 },
        { value = 'forgery', label = 'Forgery', severity = 3, baseReward = 100 },
        { value = 'conspiracy', label = 'Conspiracy', severity = 3, baseReward = 150 }
    },
    
    -- Danger levels
    dangerLevels = {
        { value = 'low', label = 'Low Threat', color = '#4CAF50' },
        { value = 'medium', label = 'Moderate Threat', color = '#FF9800' },
        { value = 'high', label = 'High Threat', color = '#F44336' },
        { value = 'extreme', label = 'Extremely Dangerous', color = '#9C27B0' }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CAPTURE & REWARD SETTINGS █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Capture = {
    -- Capture methods
    requiresHandcuffs = true,
    requiresRope = false, -- Alternative to handcuffs
    ropeItem = 'rope',
    
    -- Capture mechanics
    captureDistance = 3.0, -- Distance to initiate capture
    captureTime = 5000, -- Time to capture (ms)
    canResist = true, -- Target can resist capture
    resistChance = 0.3, -- 30% chance to resist
    
    -- Capture animations
    animations = {
        hunter = {
            dict = 'script_rc@cldn@ig@rsc2_ig1_questionshopkeeper',
            anim = 'shop_owner_idle',
            flag = 1
        },
        target = {
            dict = 'script_rc@mob3@ig@ig1_kidnap',
            anim = 'player_hanging_on_loop',
            flag = 1
        }
    },
    
    -- Dead or alive
    acceptDead = true, -- Accept dead bounties
    deadRewardPercent = 0.5, -- 50% reward if brought in dead
    
    -- Delivery
    deliveryRequired = true, -- Must deliver to sheriff office
    deliveryLocations = { -- Can deliver to these locations
        'Saint Denis Sheriff Office',
        'Valentine Sheriff Office',
        'Rhodes Sheriff Office',
        'Blackwater Sheriff Office',
        'Strawberry Sheriff Office',
        'Armadillo Sheriff Office',
        'Tumbleweed Sheriff Office'
    },
    deliveryTime = 600, -- 10 minutes to deliver after capture
    
    -- Verification
    requiresWitness = false, -- Requires law enforcement witness
    requiresEvidence = false, -- Requires evidence of crimes
    
    -- Rewards
    instantReward = true, -- Pay immediately upon delivery
    rewardMethod = 'cash', -- Options: 'cash', 'bank', 'both'
    bonusForAlive = 100, -- Bonus for bringing in alive
    bonusForMultiple = 0.1, -- 10% bonus per additional crime
    
    -- Notifications
    notifyTarget = true, -- Notify target they're being captured
    notifyLawmen = true, -- Notify law enforcement of capture
    notifyRadius = 500.0 -- Notification radius
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ ITEMS CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Items = {
    -- Bounty hunter equipment
    bounty_license = {
        label = 'Bounty Hunter License',
        description = 'Official license to hunt wanted criminals',
        weight = 50,
        canUse = false,
        unique = true
    },
    handcuffs = {
        label = 'Handcuffs',
        description = 'Used to restrain criminals',
        weight = 500,
        canUse = true,
        usable = true,
        requiresTarget = true
    },
    rope = {
        label = 'Rope',
        description = 'Can be used to tie up criminals',
        weight = 300,
        canUse = true,
        usable = true,
        requiresTarget = true
    },
    wanted_poster = {
        label = 'Wanted Poster',
        description = 'Official wanted poster',
        weight = 10,
        canUse = true,
        usable = true
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████████ COMMANDS SETTINGS ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Commands = {
    -- Open wanted board (law enforcement)
    openBoardCommand = {
        enabled = true,
        command = 'wantedboard',
        lawOnly = true,
        description = 'Open the wanted board'
    },
    
    -- View wanted list (anyone)
    viewWantedCommand = {
        enabled = true,
        command = 'wanted',
        description = 'View all wanted criminals'
    },
    
    -- Capture criminal (bounty hunter)
    captureCommand = {
        enabled = true,
        command = 'capture',
        bountyHunterOnly = true,
        description = 'Capture a wanted criminal'
    },
    
    -- Claim reward (bounty hunter)
    claimRewardCommand = {
        enabled = true,
        command = 'claimreward',
        description = 'Claim bounty reward'
    },
    
    -- Admin commands
    addWantedCommand = {
        enabled = true,
        command = 'addwanted',
        lawOnly = true,
        description = 'Add someone to wanted list'
    },
    removeWantedCommand = {
        enabled = true,
        command = 'removewanted',
        lawOnly = true,
        description = 'Remove someone from wanted list'
    },
    clearWantedCommand = {
        enabled = true,
        command = 'clearwanted',
        adminOnly = true,
        requiredGroup = 'admin',
        description = 'Clear all wanted posters'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ANIMATIONS CONFIGURATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Animations = {
    -- Creating wanted poster
    createPoster = {
        dict = 'amb_work@world_human_write_notebook@male_a@base',
        anim = 'base',
        duration = 5000,
        flag = 1
    },
    
    -- Viewing wanted board
    viewBoard = {
        dict = 'amb_work@world_human_write_notebook@male_a@idle_b',
        anim = 'idle_e',
        duration = 3000,
        flag = 1
    },
    
    -- Capturing criminal
    capture = {
        hunter = {
            dict = 'script_rc@cldn@ig@rsc2_ig1_questionshopkeeper',
            anim = 'shop_owner_idle',
            duration = 5000,
            flag = 1
        },
        target = {
            dict = 'script_rc@mob3@ig@ig1_kidnap',
            anim = 'player_hanging_on_loop',
            duration = 5000,
            flag = 1
        }
    },
    
    -- Claiming reward
    claimReward = {
        dict = 'mp_lobby@mp_missionpopup@1h@treasure_map',
        anim = 'take_map',
        duration = 3000,
        flag = 1
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ PERFORMANCE SETTINGS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Performance = {
    updateInterval = 1000, -- Main thread update interval (ms)
    boardCheckDistance = 50.0, -- Distance to check for wanted boards
    interactionDistance = 2.5, -- Distance for interactions
    saveInterval = 300000, -- Save records every 5 minutes
    blipUpdateInterval = 5000, -- Update blips every 5 seconds
    captureCheckInterval = 500, -- Check for nearby wanted criminals
    maxVisiblePosters = 20 -- Maximum posters to show at once
}

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████ BILLING SETTINGS █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Billing = {
    enabled = true,
    
    -- Payment methods
    paymentMethods = {
        cash = true, -- Accept cash payments
        bank = true -- Accept bank payments
    },
    
    -- Bounty hunter gets percentage of bounty
    hunterCut = 0.9, -- 90% goes to bounty hunter
    sheriffCut = 0.1, -- 10% goes to sheriff office
    
    -- Society account (for frameworks that support it)
    societyAccount = 'society_sheriff',
    
    -- Bounty creation cost
    posterCreationCost = 0, -- Free to create wanted posters (law enforcement)
    posterEditCost = 0 -- Free to edit posters
}

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████████ LOGGING SETTINGS █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Logging = {
    enabled = true,
    logCreation = true, -- Log wanted poster creation
    logEdits = true, -- Log wanted poster edits
    logRemoval = true, -- Log wanted poster removal
    logCaptures = true, -- Log captures
    logRewards = true, -- Log reward claims
    logArchive = true, -- Log archive access
    
    -- Webhook for Discord logging (optional)
    webhook = {
        enabled = false,
        url = '', -- Your Discord webhook URL
        color = 15158332, -- Red color for wanted events
        footer = 'LXR Wanted Board | wolves.land',
        title = '🎯 Wanted Board Event'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████ TRANSLATIONS ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Locale = 'en' -- Default language

Config.Translations = {
    en = {
        -- General
        ['wanted_board'] = 'Wanted Board',
        ['sheriff'] = 'Sheriff',
        ['bounty_hunter'] = 'Bounty Hunter',
        ['wanted_criminal'] = 'Wanted Criminal',
        ['dead_or_alive'] = 'DEAD OR ALIVE',
        ['reward'] = 'Reward',
        
        -- Actions
        ['press_to_interact'] = 'Press [E] to view Wanted Board',
        ['press_to_create'] = 'Press [E] to create Wanted Poster',
        ['press_to_claim'] = 'Press [E] to claim Bounty Reward',
        ['creating_poster'] = 'Creating wanted poster...',
        ['capturing_criminal'] = 'Capturing criminal...',
        ['claiming_reward'] = 'Claiming reward...',
        
        -- Poster information
        ['alias'] = 'Known Alias',
        ['crimes'] = 'Crimes',
        ['last_seen'] = 'Last Seen',
        ['description'] = 'Description',
        ['danger_level'] = 'Danger Level',
        ['issued_by'] = 'Issued By',
        ['expiration'] = 'Expires',
        
        -- Notifications
        ['not_law_enforcement'] = 'You are not law enforcement',
        ['not_bounty_hunter'] = 'You are not a bounty hunter',
        ['no_license'] = 'You need a bounty hunter license',
        ['no_wanted_nearby'] = 'No wanted criminals nearby',
        ['criminal_too_far'] = 'Criminal is too far away',
        ['capture_successful'] = 'Criminal captured successfully',
        ['capture_failed'] = 'Failed to capture criminal',
        ['criminal_resisted'] = 'Criminal resisted capture',
        ['reward_claimed'] = 'Bounty reward claimed: $%s',
        ['poster_created'] = 'Wanted poster created',
        ['poster_updated'] = 'Wanted poster updated',
        ['poster_removed'] = 'Wanted poster removed',
        ['already_wanted'] = 'This person is already wanted',
        ['not_wanted'] = 'This person is not wanted',
        ['bounty_expired'] = 'Bounty has expired',
        ['must_deliver'] = 'You must deliver the criminal to a sheriff office',
        ['delivery_complete'] = 'Criminal delivered successfully',
        ['you_are_wanted'] = 'You are now wanted for: %s',
        ['you_are_captured'] = 'You have been captured by a bounty hunter',
        
        -- Capture
        ['capture_started'] = 'Capturing wanted criminal...',
        ['capture_success'] = 'Criminal captured! Deliver to sheriff office.',
        ['capture_failed'] = 'Capture failed! Criminal resisted.',
        ['capture_requires_handcuffs'] = 'You need handcuffs to capture criminals',
        ['capture_no_license'] = 'You need a bounty hunter license',
        ['capture_already_capturing'] = 'Already capturing someone',
        ['not_close_enough'] = 'Get closer to the target',
        ['deliver_bounty'] = 'Press [E] to deliver bounty',
        ['bounty_delivered'] = 'Bounty delivered! Reward: $%s',
        ['delivery_expired'] = 'Bounty delivery expired',
        
        -- Posters
        ['poster_placement_disabled'] = 'Poster placement is disabled',
        ['poster_placement_mode'] = 'Poster placement mode activated',
        ['poster_placement_instructions'] = 'Aim at a wall and press [E] to place, [G] to cancel',
        ['press_to_place'] = 'Press [E] to place poster',
        ['poster_placement_cancelled'] = 'Poster placement cancelled',
        ['poster_placed'] = 'Poster placed on wall',
        ['press_to_view_poster'] = 'Press [E] to view poster',
        ['hold_to_remove'] = 'Hold [E] to remove poster',
        ['poster_removed'] = 'Poster removed',
        ['poster_destroyed'] = 'Poster destroyed',
        ['poster_picked_up'] = 'Poster picked up',
        ['cannot_remove_poster'] = 'You cannot remove this poster',
        ['error_invalid_poster'] = 'Invalid poster data',
        ['poster_too_close'] = 'Too close to another poster',
        ['poster_must_target_wall'] = 'You must target a wall',
        ['poster_received'] = 'You received a wanted poster',
        
        -- Errors
        ['error_no_handcuffs'] = 'You need handcuffs to capture criminals',
        ['error_no_target'] = 'No valid target found',
        ['error_insufficient_grade'] = 'Your rank is too low for this action',
        ['error_invalid_amount'] = 'Invalid bounty amount',
        ['error_database'] = 'Database error occurred',
        
        -- Success
        ['success_poster_created'] = 'Wanted poster created successfully',
        ['success_poster_updated'] = 'Wanted poster updated successfully',
        ['success_capture'] = 'Criminal captured and delivered',
        ['success_reward'] = 'Reward claimed successfully',
        
        -- UI
        ['ui_create_poster'] = 'Create Wanted Poster',
        ['ui_edit_poster'] = 'Edit Wanted Poster',
        ['ui_view_wanted'] = 'View Wanted List',
        ['ui_search_archive'] = 'Search Archive',
        ['ui_target_name'] = 'Target Name',
        ['ui_target_citizenship'] = 'Citizenship ID',
        ['ui_alias'] = 'Known Alias',
        ['ui_crimes_select'] = 'Select Crimes',
        ['ui_reward_amount'] = 'Reward Amount',
        ['ui_danger_level'] = 'Danger Level',
        ['ui_description'] = 'Description',
        ['ui_submit'] = 'Submit',
        ['ui_cancel'] = 'Cancel',
        ['ui_confirm'] = 'Confirm',
        
        -- Archive
        ['archive_title'] = 'US National Archive',
        ['archive_search'] = 'Search Records',
        ['archive_no_results'] = 'No records found',
        ['archive_total'] = 'Total Records: %s',
        
        -- Commands
        ['cmd_wantedboard'] = 'Open the wanted board',
        ['cmd_wanted'] = 'View all wanted criminals',
        ['cmd_capture'] = 'Capture a wanted criminal',
        ['cmd_claimreward'] = 'Claim bounty reward'
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ POSTER PLACEMENT SYSTEM ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.PosterPlacement = {
    enabled = true, -- Enable poster placement system
    
    -- Placement settings
    placementDistance = 3.0, -- Maximum distance to place poster
    interactionDistance = 2.0, -- Distance to interact with placed poster
    raycastDistance = 10.0, -- Raycast distance for wall detection
    
    -- Placement restrictions
    requireWall = true, -- Must target a wall to place
    allowMultiplePlayers = true, -- Multiple players can place on same wall
    minDistanceBetweenPosters = 1.5, -- Minimum distance between placed posters
    
    -- Interactions
    canViewPosters = true, -- Anyone can view placed posters
    canRemoveOwn = true, -- Players can remove their own posters
    canRemoveLaw = true, -- Law enforcement can remove any poster
    canRemoveCriminal = true, -- Criminals can remove posters about them
    canDestroy = true, -- Allow destroying posters
    canPickup = true, -- Allow picking up posters to inventory
    
    -- Permissions
    lawJobsCanRemoveAll = { -- Jobs that can remove any poster
        'sheriff',
        'marshal',
        'deputy',
        'lawman'
    },
    
    -- Visual settings
    posterScale = 0.5, -- Scale of placed poster objects
    posterModel = nil, -- Custom prop model (nil = use default)
    useMarker = true, -- Show marker at placed poster location
    markerType = 1, -- Marker type
    markerScale = { x = 0.3, y = 0.3, z = 0.3 },
    markerColor = { r = 255, g = 200, b = 100, a = 100 },
    
    -- Persistence
    loadOnStartup = true, -- Load all placed posters on resource start
    loadRadius = 100.0, -- Radius to load placed posters around player
    syncInterval = 30000, -- Sync placed posters every 30 seconds
    
    -- Keybinds (RedM control codes)
    keys = {
        interact = 0xCEFD9220, -- E key
        cancel = 0x760A9C6F, -- G key
        alternative = 0xD9D0E1C0 -- SPACEBAR
    },
    
    -- Hold duration
    holdDuration = 2000, -- Milliseconds to hold E to remove poster
    
    -- Notifications
    notifyOnPlace = true,
    notifyOnRemove = true,
    notifyOnDestroy = true,
    notifyRadius = 50.0 -- Notify players within radius
}

-- ████████████████████████████████████████████████████████████████████████████████
-- █████████████████████████ END OF CONFIGURATION FILE ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

print('^2[LXR Wanted Board]^7 Configuration loaded successfully | ^3wolves.land^7')
