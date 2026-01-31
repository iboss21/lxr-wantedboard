# Changelog

All notable changes to LXR Wanted Board will be documented in this file.

## [1.0.0] - 2026-01-31

### ✨ Initial Release - Complete Working Script

#### Added
- **Client-side Implementation**
  - `client/main.lua` - Core client logic with all event handlers
  - `client/ui.lua` - NUI management and callback system
  - Board interaction system with proximity detection
  - Wanted criminal monitoring for bounty hunters
  - 3D text prompts for player interactions
  - Commands: `/wantedboard`, `/wantedlist`

- **User Interface**
  - `html/index.html` - Complete NUI structure
  - `html/style.css` - Western/vintage themed styling
  - `html/script.js` - Full JavaScript functionality
  - Wanted poster grid view
  - Detailed poster display
  - Create/Edit poster forms
  - Responsive design for various screen sizes

- **Utilities & Helpers**
  - `Utils.DrawText3D()` - 3D text rendering for prompts
  - Enhanced crime validation (accepts both string and table formats)
  - Placeholder images and fonts directories

- **Documentation**
  - Comprehensive README.md with full feature list
  - Quick start [INSTALLATION.md](INSTALLATION.md) guide
  - SQL installation script with all tables
  - .gitignore for clean repository management

#### Features
- Law enforcement can create, edit, and remove wanted posters
- Bounty hunters can view and capture wanted criminals
- Beautiful Western-themed UI matching RedM aesthetics
- Multi-framework support (LXRCore, RSG-Core, QBCore, QBR-Core, Standalone)
- Grade-based permission system
- Danger level classifications (Low, Medium, High, Extreme)
- Configurable reward system with automatic payouts
- US National Archive integration for historical records
- Multiple wanted board locations across the map
- Real-time updates for all players
- Capture animations and mechanics

#### Server-side
- Already implemented (pre-existing):
  - Full database integration with oxmysql
  - Wanted poster management system
  - Capture tracking and rewards
  - Archive system for records
  - Framework abstraction layer
  - All server-side events and callbacks

#### Database
- `lxr_wanted_board` - Active wanted posters
- `lxr_wanted_archive` - Historical archive (MDT)
- `lxr_wanted_captures` - Capture records
- `lxr_bounty_licenses` - Bounty hunter licenses

### 🐛 Bug Fixes
- Fixed missing `DrawText3D` function causing interaction prompt errors
- Fixed crime validation to properly handle comma-separated strings from UI
- Ensured all referenced files in fxmanifest.lua exist

### 📝 Configuration
- Pre-configured with sensible defaults
- 7 default wanted board locations
- Extensive crime list with 20+ categories
- Configurable danger levels with visual indicators
- Flexible reward system ($10 - $5000 range)
- Customizable capture mechanics

### 🎯 Production Ready
- All files present and functional
- No missing dependencies
- Complete documentation
- Ready for deployment

---

**Version:** 1.0.0  
**Release Date:** January 31, 2026  
**Author:** iBoss  
**Website:** wolves.land

© 2026 iBoss | wolves.land | All Rights Reserved
