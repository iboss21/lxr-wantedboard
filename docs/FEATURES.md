# 🎯 LXR Wanted Board - Feature Overview

## 📋 Complete Feature List

### 👮 Law Enforcement Features
- **Create Wanted Posters**
  - Input criminal's citizen ID and name
  - Add known aliases
  - List multiple crimes
  - Add physical descriptions
  - Set reward amounts ($10 - $5000)
  - Choose danger levels (Low/Medium/High/Extreme)
  - Record last seen location
  - Automatic expiration dates

- **Manage Wanted Posters**
  - View all active wanted criminals
  - Edit existing posters (Sheriff+ grade)
  - Remove posters (Marshal+ grade)
  - Search by name, alias, or crime
  - View detailed poster information

- **Permission System**
  - Grade-based access control
  - Deputy+ can create posters
  - Sheriff+ can edit posters
  - Marshal+ can remove posters
  - All law enforcement can view archives

### 🎯 Bounty Hunter Features
- **Hunt Wanted Criminals**
  - View public wanted list
  - See nearby wanted criminals with visual indicators
  - Capture wanted persons within 5m radius
  - Animated capture sequences
  - Deliver captures to sheriff offices

- **License System**
  - Optional bounty hunter license requirement
  - License tracking in database
  - License validation on capture attempts

- **Reward System**
  - Earn 90% of posted bounty
  - 10% goes to state/sheriff office
  - Automatic payout upon delivery
  - Dead bounties accepted at 50% reward (configurable)
  - 10-minute delivery window after capture

### 🎨 User Interface
- **Western Theme**
  - Vintage poster aesthetics
  - Period-appropriate color palette (#f5e6d3, #3e2415)
  - Serif fonts for authentic look
  - "WANTED - DEAD OR ALIVE" styling

- **Board View**
  - Grid layout of wanted poster cards
  - Danger level badges with color coding
  - Reward amounts prominently displayed
  - Click to view full details

- **Detail View**
  - Large poster display
  - Complete criminal information
  - Crime list
  - Physical description
  - Last seen location
  - Danger level indicator
  - Issue date and issuer name
  - Action buttons (Capture/Edit/Remove)

- **Create/Edit Form**
  - Clean, organized input fields
  - Dropdown for danger levels
  - Text areas for crimes and descriptions
  - Number input for rewards
  - Form validation
  - Cancel functionality

### 🗺️ Board Locations
Pre-configured locations at:
- Saint Denis Sheriff Office
- Valentine Sheriff Office
- Rhodes Sheriff Office
- Blackwater Sheriff Office
- Strawberry Sheriff Office
- Armadillo Sheriff Office
- Tumbleweed Sheriff Office

Each location features:
- Interactive board with proximity detection
- Blip on map (configurable)
- Press E to interact prompt
- Distance-based activation

### 📊 Database System
Four integrated tables:
1. **lxr_wanted_board** - Active wanted posters
2. **lxr_wanted_archive** - Historical records (MDT)
3. **lxr_wanted_captures** - Capture tracking
4. **lxr_bounty_licenses** - License management

### 🔧 Technical Features
- **Multi-Framework Support**
  - LXRCore
  - RSG-Core
  - QBCore
  - QBR-Core
  - Standalone mode

- **Performance**
  - 0.01ms server overhead target
  - Minimal client-side FPS impact
  - Optimized proximity checks
  - Efficient database queries

- **Integration**
  - OxMySQL for database operations
  - Native RedM notifications
  - Support for mythic_notify
  - Support for ox_lib notifications

### 📝 Commands
- `/wantedboard` - Open wanted board interface
- `/wantedlist` - View active wanted criminals

### 🎮 Gameplay Mechanics
- **Capture System**
  - Requires handcuffs (configurable)
  - 5-second capture animation
  - 30% resistance chance
  - Can accept dead bounties
  - Must deliver to sheriff office

- **Expiration System**
  - Default 7-day expiration
  - Maximum 30-day duration
  - Automatic archiving on expiration
  - Notifications to law enforcement

- **Reward Calculation**
  - Crime-based reward suggestions
  - Severity multipliers
  - Hunter/State split (90/10)
  - Dead bounty reduction (50%)

### 🔐 Security
- Permission validation on all actions
- Server-side data validation
- SQL injection protection via OxMySQL
- Grade requirement checks
- Citizen ID verification

### 📱 Notifications
- Poster created confirmation
- Criminal capture alerts
- Reward payment notifications
- Expiration warnings
- Error messages for invalid actions

### 🎨 Customization
Everything is configurable:
- Color schemes (CSS)
- Crime categories (config.lua)
- Danger levels (config.lua)
- Reward ranges (config.lua)
- Capture mechanics (config.lua)
- Expiration times (config.lua)
- Job permissions (config.lua)
- Board locations (config.lua)

### 📚 Documentation
- README.md - Full documentation
- [INSTALLATION.md](INSTALLATION.md) - Quick setup guide
- [CHANGELOG.md](CHANGELOG.md) - Version history
- installation/installation.sql - Database setup
- Inline code comments

## 🚀 Ready for Production
All features are complete, tested, and ready for deployment. The script is production-ready with comprehensive functionality for bounty hunting and law enforcement gameplay in RedM.

---

**Version:** 1.0.0  
**Author:** iBoss  
**Website:** wolves.land  
© 2026 iBoss | wolves.land | All Rights Reserved
