-- ████████████████████████████████████████████████████████████████████████████████
-- LXR Wanted Board - Discord Integration Database Tables
-- 
-- This script creates additional database tables for Discord role integration.
-- Run this script if you want to enable Discord role-based restrictions.
-- 
-- © 2026 iBoss | wolves.land | All Rights Reserved
-- ████████████████████████████████████████████████████████████████████████████████

-- ════════════════════════════════════════════════════════════════════════════════
-- DISCORD ROLE MAPPINGS TABLE
-- Stores mapping between Discord roles and in-game jobs/permissions
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_discord_role_mappings` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `discord_role_id` VARCHAR(100) NOT NULL,
    `discord_role_name` VARCHAR(200) NOT NULL,
    `job_name` VARCHAR(100) NOT NULL,
    `min_grade` INT(11) DEFAULT 0,
    `max_grade` INT(11) DEFAULT 99,
    `enabled` TINYINT(1) DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `discord_role_id` (`discord_role_id`),
    KEY `job_name` (`job_name`),
    KEY `enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- DISCORD PLAYER VERIFICATION TABLE
-- Tracks Discord verification status for players
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_discord_verification` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL UNIQUE,
    `discord_id` VARCHAR(100) NOT NULL UNIQUE,
    `discord_username` VARCHAR(200) DEFAULT NULL,
    `verified` TINYINT(1) DEFAULT 1,
    `roles_cache` TEXT DEFAULT NULL,
    `cache_expires_at` DATETIME DEFAULT NULL,
    `last_verified_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `discord_id` (`discord_id`),
    KEY `verified` (`verified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- DISCORD AUDIT LOG TABLE
-- Logs all Discord role checks and access attempts
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_discord_audit_log` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `discord_id` VARCHAR(100) DEFAULT NULL,
    `action` VARCHAR(100) NOT NULL,
    `job_name` VARCHAR(100) DEFAULT NULL,
    `required_roles` TEXT DEFAULT NULL,
    `player_roles` TEXT DEFAULT NULL,
    `access_granted` TINYINT(1) DEFAULT 0,
    `reason` VARCHAR(255) DEFAULT NULL,
    `ip_address` VARCHAR(45) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `discord_id` (`discord_id`),
    KEY `action` (`action`),
    KEY `access_granted` (`access_granted`),
    KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- WEBHOOK CONFIGURATION TABLE
-- Stores multiple webhook configurations for different events
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_webhook_config` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `webhook_name` VARCHAR(100) NOT NULL UNIQUE,
    `webhook_url` TEXT NOT NULL,
    `enabled` TINYINT(1) DEFAULT 1,
    `event_types` TEXT NOT NULL COMMENT 'JSON array of event types to log',
    `color` VARCHAR(10) DEFAULT '#FF0000',
    `avatar_url` TEXT DEFAULT NULL,
    `username` VARCHAR(100) DEFAULT 'LXR Wanted Board',
    `rate_limit_delay` INT(11) DEFAULT 1000 COMMENT 'Delay between webhooks in ms',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- DEFAULT DATA EXAMPLES (COMMENTED OUT - UNCOMMENT TO USE)
-- ════════════════════════════════════════════════════════════════════════════════

-- Example: Add Discord role mapping for Sheriff job
-- INSERT INTO `lxr_discord_role_mappings` (`discord_role_id`, `discord_role_name`, `job_name`, `min_grade`, `max_grade`, `enabled`) 
-- VALUES ('123456789012345678', 'Sheriff Role', 'sheriff', 0, 99, 1);

-- Example: Add Discord role mapping for Bounty Hunter job
-- INSERT INTO `lxr_discord_role_mappings` (`discord_role_id`, `discord_role_name`, `job_name`, `min_grade`, `max_grade`, `enabled`) 
-- VALUES ('123456789012345679', 'Bounty Hunter Role', 'bountyhunter', 0, 99, 1);

-- Example: Add webhook configuration
-- INSERT INTO `lxr_webhook_config` (`webhook_name`, `webhook_url`, `enabled`, `event_types`, `color`, `username`) 
-- VALUES ('Main Webhook', 'https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE', 1, '["poster_created","capture","reward_claimed"]', '#FF0000', 'LXR Wanted Board');

-- ════════════════════════════════════════════════════════════════════════════════
-- INSTALLATION COMPLETE
-- ════════════════════════════════════════════════════════════════════════════════

-- Discord integration tables created successfully!
-- Configure your Discord bot token and guild ID in config.lua
-- Add role mappings using the examples above or through an admin panel
