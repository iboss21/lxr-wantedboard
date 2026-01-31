# 🎯 LXR Wanted Board

**A comprehensive wanted board system for RedM** featuring bounty hunting mechanics, law enforcement tools, and US National Archive (MDT) integration.

## 📋 Features

- **Wanted Poster Management**: Law enforcement can create, edit, and remove wanted posters
- **Bounty Hunting System**: Licensed bounty hunters can capture wanted criminals for rewards
- **US National Archive Integration**: Automatic archiving of all wanted posters and captures
- **Multi-Framework Support**: LXRCore, RSG-Core, QBCore, QBR-Core, and Standalone
- **Beautiful Western-Themed UI**: Vintage poster-style interface matching RedM aesthetics
- **Danger Levels**: Low, Medium, High, and Extreme classifications
- **Reward System**: Configurable bounty amounts with automatic payout splitting
- **Permission System**: Grade-based permissions for law enforcement
- **Multiple Wanted Board Locations**: Place boards at sheriff offices across the map

## 📦 Installation

### 1. Database Setup

Run the `installation.sql` file in your database to create the required tables:

```sql
-- Import the installation.sql file or run it manually
```

The script creates:
- `lxr_wanted_board` - Active wanted posters
- `lxr_wanted_archive` - Historical archive (MDT integration)
- `lxr_wanted_captures` - Capture records
- `lxr_bounty_licenses` - Bounty hunter licenses

### 2. Resource Installation

1. Download and extract `lxr-wantedboard` to your resources folder
2. Add to your `server.cfg`:

```cfg
ensure oxmysql
ensure lxr-wantedboard
```

### 3. Configuration

Edit `config.lua` to customize:

- **Framework**: Set your framework (lxrcore, rsg-core, qbcore, qbr-core, standalone)
- **Law Jobs**: Configure which jobs can use the system
- **Bounty Hunters**: Set up bounty hunter jobs and requirements
- **Board Locations**: Add/edit wanted board locations
- **Rewards**: Configure reward percentages and minimums
- **Permissions**: Set minimum grades for different actions

## 🎮 Usage

### For Law Enforcement

**Commands:**
- `/wantedboard` - Open the wanted board interface
- `/wantedlist` - View active wanted criminals

**Creating a Wanted Poster:**
1. Approach any wanted board at a sheriff office
2. Press `E` to interact
3. Click "Create New Wanted Poster"
4. Fill in the criminal's information:
   - Citizen ID (required)
   - Full Name (required)
   - Known Alias (optional)
   - Crimes committed (required)
   - Physical description
   - Reward amount
   - Danger level
   - Last seen location
5. Submit the poster

**Managing Posters:**
- View poster details by clicking on them
- Edit posters (requires Sheriff+ grade)
- Remove posters (requires Marshal+ grade)

### For Bounty Hunters

**Requirements:**
- Bounty Hunter job
- Bounty Hunter License (if configured)
- Handcuffs (if configured)

**Capturing Wanted Criminals:**
1. Find a wanted criminal (they'll be marked nearby)
2. Get close to them (within capture radius)
3. Press `E` to initiate capture
4. Wait for capture animation to complete
5. Deliver to sheriff office to claim reward

**Commands:**
- `/wantedlist` - View active wanted criminals and their bounties

### For Criminals

If you're wanted:
- You'll receive a notification when a poster is created for you
- Other players can see your wanted status
- Bounty hunters can capture you for the reward
- Law enforcement will be alerted to your location

## ⚙️ Configuration Examples

### Adding a Wanted Board Location

```lua
Config.WantedBoards = {
    {
        name = 'Valentine Sheriff Office',
        location = 'Valentine',
        coords = vector3(-275.62, 805.03, 118.39),
        heading = 180.0,
        blip = {
            enabled = true,
            sprite = 'blip_ambient_sheriff',
            scale = 0.6,
            color = 'BLIP_MODIFIER_MP_COLOR_2'
        },
        boardCoords = vector3(-275.62, 806.45, 119.0),
        interactionDistance = 10.0
    }
}
```

### Configuring Law Jobs

```lua
Config.LawJobs = {
    'sheriff',
    'marshal',
    'deputy',
    'lawman'
}
```

### Setting Up Bounty Hunters

```lua
Config.BountyHunters = {
    enabled = true,
    jobs = { 'bountyhunter', 'hunter' },
    requireLicense = true,
    captureRadius = 5.0,
    rewardPercentage = 0.9, -- 90% to hunter
    stateCut = 0.1 -- 10% to state
}
```

## 🔧 Dependencies

**Required:**
- `oxmysql` - Database operations

**Optional:**
- Your chosen framework (lxr-core, rsg-core, qb-core, qbr-core)
- `mythic_notify` or `ox_lib` - For enhanced notifications

## 📝 Commands

| Command | Description | Permission |
|---------|-------------|------------|
| `/wantedboard` | Open wanted board | All players |
| `/wantedlist` | View wanted list | All players |

## 🎨 Customization

The UI is fully customizable via `html/style.css`. The theme follows a Western/vintage aesthetic perfect for RedM.

**Customizable Elements:**
- Colors and fonts
- Layout and spacing
- Button styles
- Poster card design
- Form styling

## 🐛 Troubleshooting

**UI not showing:**
- Check browser console (F8) for errors
- Verify all HTML files are present
- Check NUI focus is enabled

**Database errors:**
- Ensure `installation.sql` was run
- Verify oxmysql is running
- Check database connection

**Framework not loading:**
- Verify framework name in config matches your setup
- Ensure core resource is started before lxr-wantedboard
- Check console for initialization messages

## 📄 License

© 2026 iBoss | wolves.land | All Rights Reserved

## 🌐 Support

- Website: [wolves.land](https://wolves.land)
- Version: 1.0.0
- Author: iBoss

---

**Made with ❤️ for the RedM community** 
