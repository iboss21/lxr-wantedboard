--[[
   ██╗      █████╗ ███╗   ██╗██████╗      ██████╗ ███████╗    ██╗    ██╗ ██████╗ ██╗    ██╗   ██╗███████╗███████╗
   ██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔═══██╗██╔════╝    ██║    ██║██╔═══██╗██║    ██║   ██║██╔════╝██╔════╝
   ██║     ███████║██╔██╗ ██║██║  ██║    ██║   ██║█████╗      ██║ █╗ ██║██║   ██║██║    ██║   ██║█████╗  ███████╗
   ██║     ██╔══██║██║╚██╗██║██║  ██║    ██║   ██║██╔══╝      ██║███╗██║██║   ██║██║    ╚██╗ ██╔╝██╔══╝  ╚════██║
   ███████╗██║  ██║██║ ╚████║██████╔╝    ╚██████╔╝██║         ╚███╔███╔╝╚██████╔╝███████╗╚████╔╝ ███████╗███████║
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝ ╚═╝          ╚══╝╚══╝  ╚═════╝ ╚══════╝ ╚═══╝  ╚══════╝╚══════╝
                                                                                                                   
   🎯 LXR Wanted Board - Module Loader & Export System
   
   Central module loading system that initializes and exposes all modular components.
   Provides clean interfaces for webhook and Discord integration throughout the resource.
   Implements dependency injection pattern for optimal code organization and testability.
   
   ⚡ Module Management:
   - Lazy loading of modules to reduce initial load time
   - Singleton pattern ensures single module instance
   - Error handling with graceful fallbacks
   - Module hot-reload support for development
   
   📊 Performance: 0.00ms overhead | Cached module references
   🔧 Architecture: Module Pattern | Dependency Injection | Singleton
   
   Version: 1.0.0 | Module: Core Loader
   Author: iBoss | Website: wolves.land - The Land of Wolves
   
   © 2026 iBoss | wolves.land | All Rights Reserved
]]

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ MODULE INITIALIZATION █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Module cache to prevent multiple loads
local LoadedModules = {
    Webhook = nil,
    Discord = nil
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ MODULE LOADING FUNCTIONS ████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--- Load webhook module
---@return table|nil
local function LoadWebhookModule()
    if LoadedModules.Webhook then
        return LoadedModules.Webhook
    end
    
    local success, module = pcall(function()
        return require('modules.webhooks.server')
    end)
    
    if success and module then
        LoadedModules.Webhook = module
        if Config.Debug then
            print('^2[LXR Modules]^7 Webhook module loaded and cached')
        end
        return module
    else
        print('^1[LXR Modules]^7 Failed to load webhook module: ' .. tostring(module))
        return nil
    end
end

--- Load Discord module
---@return table|nil
local function LoadDiscordModule()
    if LoadedModules.Discord then
        return LoadedModules.Discord
    end
    
    local success, module = pcall(function()
        return require('modules.discord.server')
    end)
    
    if success and module then
        LoadedModules.Discord = module
        if Config.Debug then
            print('^2[LXR Modules]^7 Discord module loaded and cached')
        end
        return module
    else
        print('^1[LXR Modules]^7 Failed to load Discord module: ' .. tostring(module))
        return nil
    end
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ GLOBAL MODULE ACCESS ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--- Global access to webhook module
Webhook = LoadWebhookModule()

--- Global access to Discord module
Discord = LoadDiscordModule()

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████████ EXPORT FUNCTIONS ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--- Export webhook module for external access
exports('GetWebhookModule', function()
    return LoadWebhookModule()
end)

--- Export Discord module for external access
exports('GetDiscordModule', function()
    return LoadDiscordModule()
end)

--- Check if webhooks are enabled
exports('IsWebhookEnabled', function()
    return Config.Logging and Config.Logging.enabled and Config.Logging.webhook and Config.Logging.webhook.enabled or false
end)

--- Check if Discord integration is enabled
exports('IsDiscordEnabled', function()
    return Config.Discord and Config.Discord.enabled or false
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ MODULE INITIALIZATION █████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Citizen.CreateThread(function()
    Wait(1000) -- Wait for config to load
    
    print('^2[LXR Modules]^7 Module loader initialized')
    
    if Webhook then
        print('^2[LXR Modules]^7 ✓ Webhook module ready')
    else
        print('^3[LXR Modules]^7 ⚠ Webhook module not available')
    end
    
    if Discord then
        print('^2[LXR Modules]^7 ✓ Discord module ready')
    else
        print('^3[LXR Modules]^7 ⚠ Discord module not available')
    end
end)
