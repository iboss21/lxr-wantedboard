--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Enyo Wanted Board System for RedM
   
   A comprehensive wanted board system for sheriffs to post bounties on fugitives.
   Features integration with US National Archive (MDT) for record keeping.
   Supports multiple frameworks: LXRCore, RSG-Core, QBCore, QBR-Core
   
   Version: 1.0.0
   Author: iBoss
   Website: wolves.land - The Land of Wolves
   Performance Target: 0.01ms server overhead, Minimal FPS impact client-side
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'lxr-wantedboard'
description 'Enyo Wanted Board System - Bounty Hunting with US National Archive (MDT) Integration'
author 'iBoss - wolves.land'
version '1.0.0'

lua54 'yes'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ SHARED FILES ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'shared/utils.lua'
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ CLIENT FILES ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

client_scripts {
    'client/framework.lua',
    'client/main.lua',
    'client/ui.lua'
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ SERVER FILES ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/framework.lua',
    'server/database.lua',
    'server/main.lua'
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████████ UI FILES ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/fonts/*.ttf',
    'html/images/*.png',
    'html/images/*.jpg'
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ DEPENDENCIES ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

dependencies {
    'oxmysql' -- Required for database operations
    -- Optional: 'lxr-core', 'rsg-core', 'qb-core', 'qbr-core'
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
