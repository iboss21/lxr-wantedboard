# 🚀 Quick Start Installation Guide

This guide will help you get the LXR Wanted Board up and running in minutes!

## ⚡ Quick Installation (5 Minutes)

### Step 1: Database Setup
1. Open your MySQL/MariaDB management tool (phpMyAdmin, HeidiSQL, etc.)
2. Import the `installation/installation.sql` file into your database
3. Verify 4 tables were created:
   - `lxr_wanted_board`
   - `lxr_wanted_archive`
   - `lxr_wanted_captures`
   - `lxr_bounty_licenses`

### Step 2: Resource Installation
1. Extract `lxr-wantedboard` folder to your server's `resources` directory
2. Open your `server.cfg` file
3. Add these lines (make sure oxmysql is loaded first):
```cfg
ensure oxmysql
ensure lxr-wantedboard
```

### Step 3: Configuration
1. Open `config.lua`
2. Set your framework (line 30):
```lua
Config.Framework = 'lxrcore' -- Change to your framework
```
3. Adjust law enforcement jobs if needed (line 127):
```lua
Config.LawJobs = {
    'sheriff',
    'marshal',
    'deputy',
    'lawman',
    'police'
}
```

### Step 4: Start Server
1. Start or restart your server
2. Look for the ASCII art logo in console - this confirms successful loading
3. Check for any errors in console

## ✅ Verify Installation

### Test as Law Enforcement:
1. Login as a character with a law job (sheriff, deputy, etc.)
2. Go to any wanted board location (see config for coords)
3. Type `/wantedboard` or press `E` near a board
4. Try creating a test wanted poster

### Test as Bounty Hunter:
1. Login as a character with bounty hunter job
2. Type `/wantedlist` to see active bounties
3. Look for wanted criminals nearby

### Test as Regular Player:
1. Type `/wantedlist` to view public wanted list
2. You should see wanted posters but cannot create/edit them

## 🏛️ Default Board Locations

The script comes with pre-configured locations. Check `config.lua` starting at line 183 for all locations including:
- Saint Denis Sheriff Office
- Valentine Sheriff Office  
- Rhodes Sheriff Office
- Blackwater Sheriff Office
- Strawberry Sheriff Office
- Armadillo Sheriff Office
- Tumbleweed Sheriff Office

## 🔧 Common Issues

**UI Not Opening:**
- Check console for NUI errors (F8)
- Verify `html/` folder exists with all files
- Make sure NUI focus is working (try other scripts)

**Database Errors:**
- Verify `installation/installation.sql` was imported correctly
- Check oxmysql is running and connected
- Verify table names match config

**Framework Not Loading:**
- Ensure your framework resource starts BEFORE lxr-wantedboard
- Check framework name in config matches exactly
- Look for "Framework initialized" message in console

**No Interaction Prompts:**
- Verify you're near a board location (check coords in config)
- Make sure `shared/utils.lua` has the DrawText3D function
- Check console for any Lua errors

## 📞 Need Help?

If you encounter issues:
1. Check the full README.md for detailed documentation
2. Review console for error messages
3. Verify all files are present and not corrupted
4. Check framework compatibility

## 🎉 You're Done!

Your wanted board system is now ready! Law enforcement can create bounties and bounty hunters can start capturing criminals. Enjoy!

---

**Version:** 1.0.0  
**Author:** iBoss  
**Website:** wolves.land  
© 2026 iBoss | wolves.land | All Rights Reserved
