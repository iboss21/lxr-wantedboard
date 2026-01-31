-- ████████████████████████████████████████████████████████████████████████████████
-- LXR Wanted Board - Database Installation Script
-- 
-- This script creates the necessary database tables for the wanted board system.
-- Run this script once to set up your database.
-- 
-- © 2026 iBoss | wolves.land | All Rights Reserved
-- ████████████████████████████████████████████████████████████████████████████████

-- ════════════════════════════════════════════════════════════════════════════════
-- MAIN WANTED BOARD TABLE
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_wanted_board` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `alias` VARCHAR(100) DEFAULT NULL,
    `crimes` TEXT NOT NULL,
    `description` TEXT DEFAULT NULL,
    `reward` INT(11) NOT NULL DEFAULT 0,
    `danger_level` ENUM('low', 'medium', 'high', 'extreme') DEFAULT 'low',
    `last_seen` VARCHAR(200) DEFAULT NULL,
    `issued_by` VARCHAR(50) NOT NULL,
    `issued_by_name` VARCHAR(100) NOT NULL,
    `expires_at` DATETIME DEFAULT NULL,
    `sketch_data` TEXT DEFAULT NULL,
    `status` ENUM('active', 'captured', 'expired', 'removed') DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `status` (`status`),
    KEY `expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- US NATIONAL ARCHIVE TABLE (MDT Integration)
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_wanted_archive` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `wanted_id` INT(11) NOT NULL,
    `citizenid` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `alias` VARCHAR(100) DEFAULT NULL,
    `crimes` TEXT NOT NULL,
    `description` TEXT DEFAULT NULL,
    `reward` INT(11) NOT NULL DEFAULT 0,
    `danger_level` ENUM('low', 'medium', 'high', 'extreme') DEFAULT 'low',
    `last_seen` VARCHAR(200) DEFAULT NULL,
    `issued_by` VARCHAR(50) NOT NULL,
    `issued_by_name` VARCHAR(100) NOT NULL,
    `captured_by` VARCHAR(50) DEFAULT NULL,
    `captured_by_name` VARCHAR(100) DEFAULT NULL,
    `capture_date` DATETIME DEFAULT NULL,
    `archive_reason` ENUM('captured', 'expired', 'removed', 'pardoned') NOT NULL,
    `sketch_data` TEXT DEFAULT NULL,
    `issued_at` DATETIME NOT NULL,
    `archived_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `wanted_id` (`wanted_id`),
    KEY `citizenid` (`citizenid`),
    KEY `archive_reason` (`archive_reason`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- CAPTURE TRACKING TABLE
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_wanted_captures` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `wanted_id` INT(11) NOT NULL,
    `captured_citizenid` VARCHAR(50) NOT NULL,
    `captured_name` VARCHAR(100) NOT NULL,
    `hunter_citizenid` VARCHAR(50) NOT NULL,
    `hunter_name` VARCHAR(100) NOT NULL,
    `reward_amount` INT(11) NOT NULL DEFAULT 0,
    `hunter_reward` INT(11) NOT NULL DEFAULT 0,
    `state_cut` INT(11) NOT NULL DEFAULT 0,
    `claimed` TINYINT(1) DEFAULT 0,
    `claimed_at` DATETIME DEFAULT NULL,
    `capture_location` VARCHAR(200) DEFAULT NULL,
    `captured_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `wanted_id` (`wanted_id`),
    KEY `hunter_citizenid` (`hunter_citizenid`),
    KEY `claimed` (`claimed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- BOUNTY HUNTER LICENSES TABLE
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `lxr_bounty_licenses` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL UNIQUE,
    `name` VARCHAR(100) NOT NULL,
    `license_number` VARCHAR(50) NOT NULL UNIQUE,
    `issued_by` VARCHAR(50) NOT NULL,
    `issued_by_name` VARCHAR(100) NOT NULL,
    `status` ENUM('active', 'suspended', 'revoked') DEFAULT 'active',
    `issued_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `expires_at` DATETIME DEFAULT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ════════════════════════════════════════════════════════════════════════════════
-- INSTALLATION COMPLETE
-- ════════════════════════════════════════════════════════════════════════════════

-- All tables created successfully!
-- You can now start the lxr-wantedboard resource.
