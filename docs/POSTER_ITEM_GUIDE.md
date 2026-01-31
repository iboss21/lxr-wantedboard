# 📌 Wanted Poster Item System - User Guide

## Overview

The LXR Wanted Board now includes a comprehensive poster item system that allows players to:
- **Use poster items** from their inventory to view wanted criminal details
- **Place posters on walls** throughout the world for public viewing
- **Interact with placed posters** to view, remove, or pick them up
- **Share posters** between players through the inventory system
- **Help or hinder criminals** by placing or removing evidence

## Features

### 1. Usable Poster Items

Wanted posters are now usable items in your inventory with full metadata:

- **View Information**: See all details about the wanted criminal
- **Place on Walls**: Mount posters on building walls
- **Give to Others**: Share posters with other players
- **Portable Evidence**: Carry physical proof of bounties

### 2. Wall Placement System

Place posters on any wall surface using an advanced raycast system:

- **Aim and Place**: Look at a wall and aim where you want to place the poster
- **Visual Preview**: See a green marker showing where the poster will be placed
- **Distance Control**: Configurable placement distance (default: 3m)
- **Wall Detection**: Automatically finds valid wall surfaces
- **Multi-Player**: Multiple players can place posters on the same wall (configurable spacing)

### 3. World Persistence

All placed posters persist in the world:

- **Database Saved**: Every placed poster is saved to the database
- **Server Restart Safe**: Posters remain after server restarts
- **Proximity Loading**: Posters load based on player proximity
- **Real-Time Sync**: New placements sync to nearby players

### 4. Interactive Placed Posters

Players can interact with posters placed in the world:

- **View**: Press [E] to open and read the poster
- **Remove**: Hold [E] for 2 seconds to remove the poster
- **Permission System**: Configurable who can remove posters
- **Pick Up**: Optionally add removed posters back to inventory

## How to Use

### Creating Poster Items

Law enforcement can create poster items from the wanted board:

1. Open the wanted board at any sheriff office
2. View an active wanted poster
3. Click "Create Poster Item" button *(Coming Soon)*
4. The poster item will be added to your inventory

### Using a Poster Item

When you use a wanted poster from your inventory:

1. **Options Menu**: You'll see two options:
   - 📄 **View Poster**: Read the details
   - 📌 **Place on Wall**: Enter placement mode

2. **Viewing**: Shows full wanted criminal details including:
   - Name and alias
   - List of crimes
   - Physical description
   - Reward amount
   - Danger level
   - Last seen location
   - Issuer information

3. **Placing**: Enters placement mode where you can:
   - Aim at any wall surface
   - See a green preview marker
   - Press [E] to place the poster
   - Press [G] to cancel placement

### Interacting with Placed Posters

When you approach a placed poster:

1. **View**: 
   - Get close (within 2m by default)
   - Press [E] to view the poster details
   
2. **Remove**:
   - Stand near the poster
   - Hold [E] for 2 seconds
   - Poster is removed based on permissions

### Permission System

Who can remove placed posters:

- **Poster Owner**: The player who placed it (configurable)
- **Law Enforcement**: Sheriff, Marshal, Deputy, Lawman (configurable)
- **The Criminal**: Person featured on the poster can remove it (configurable)
- **Anyone**: Can be set to allow anyone to remove posters

## Configuration

All poster placement settings are in `config.lua` under `Config.PosterPlacement`:

### Basic Settings

```lua
Config.PosterPlacement = {
    enabled = true, -- Enable/disable the entire system
    placementDistance = 3.0, -- Max distance to place poster
    interactionDistance = 2.0, -- Distance to interact with placed poster
    raycastDistance = 10.0, -- How far the raycast searches for walls
}
```

### Placement Restrictions

```lua
requireWall = true, -- Must target a wall to place
allowMultiplePlayers = true, -- Multiple players can place on same wall
minDistanceBetweenPosters = 1.5, -- Minimum spacing between posters
```

### Interaction Permissions

```lua
canViewPosters = true, -- Anyone can view placed posters
canRemoveOwn = true, -- Players can remove their own posters
canRemoveLaw = true, -- Law enforcement can remove any poster
canRemoveCriminal = true, -- Criminals can remove posters about them
canDestroy = true, -- Allow destroying posters
canPickup = true, -- Allow picking up posters to inventory
```

### Keybinds

```lua
keys = {
    interact = 0xCEFD9220, -- E key
    cancel = 0x760A9C6F, -- G key
    alternative = 0xD9D0E1C0 -- SPACEBAR
},
holdDuration = 2000, -- Milliseconds to hold E to remove poster
```

### Visual Settings

```lua
useMarker = true, -- Show marker at placed poster location
markerType = 1, -- Marker type
markerScale = { x = 0.3, y = 0.3, z = 0.3 },
markerColor = { r = 255, g = 200, b = 100, a = 100 },
```

## Gameplay Scenarios

### For Law Enforcement

**Spreading the Word**:
1. Create wanted posters at the sheriff office
2. Take poster items from inventory
3. Place them around high-traffic areas:
   - Saloon entrances
   - General stores
   - Train stations
   - Town centers
4. Increase public awareness of criminals

**Information Control**:
- Remove outdated posters
- Update with new information
- Track where posters are placed

### For Bounty Hunters

**Intelligence Gathering**:
1. Check placed posters around town
2. Note criminal details and rewards
3. Plan your hunting strategy
4. Give posters to other hunters

**Network Building**:
- Share poster items with allies
- Coordinate multi-hunter operations
- Distribute information about high-value targets

### For Criminals

**Evidence Removal**:
1. Look for posters about yourself
2. Remove them to reduce visibility
3. Destroy evidence of your crimes
4. Hinder law enforcement efforts

**Counter-Intelligence**:
- Remove posters strategically
- Monitor law enforcement activity
- Stay one step ahead

**Risk Management**:
- Higher danger level = more posters placed
- More posters = more attention from bounty hunters
- Remove posters to reduce heat

## Roleplay Opportunities

### Poster Distributor

- Specialize in distributing wanted posters
- Work with law enforcement
- Get paid for placement service

### Information Broker

- Collect and sell poster information
- Know who's wanted and where
- Trade in bounty intelligence

### Vigilante Justice

- Place posters on criminals not yet wanted
- Create your own justice system
- Post warnings about dangerous players

### Criminal Network

- Coordinate poster removal
- Protect fellow gang members
- Control information flow

## Technical Details

### Database Structure

Placed posters are stored in `lxr_placed_posters` table:

- `id`: Unique identifier
- `wanted_id`: Reference to wanted board entry
- `poster_data`: JSON snapshot of poster information
- `coords_x/y/z`: World position
- `heading`: Rotation
- `placed_by`: Player who placed it
- `placed_by_name`: Player name
- `placed_at`: Timestamp

### Performance

- **Client-Side**: Minimal FPS impact with proximity loading
- **Server-Side**: Efficient database queries with spatial indexing
- **Network**: Only syncs nearby posters to reduce bandwidth
- **Load Radius**: Configurable (default: 100m)

### Sync Interval

Placed posters sync every 30 seconds (configurable) to ensure:
- New placements are visible to joining players
- Removed posters are cleaned up
- Database consistency is maintained

## Troubleshooting

### Posters Not Showing

1. Check if placement is enabled in config
2. Verify you're within loading radius
3. Try requesting manual sync (rejoin area)
4. Check database for placed poster entries

### Cannot Place Poster

1. Ensure you're targeting a valid wall surface
2. Check placement distance (default: 3m)
3. Verify not too close to another poster
4. Confirm you have the poster item in inventory

### Cannot Remove Poster

1. Check your permissions in config
2. Verify you're within interaction distance
3. Hold [E] for full duration (2 seconds)
4. Ensure you have required job/role

### Posters Not Persisting

1. Verify database table exists
2. Check MySQL connection
3. Review server console for errors
4. Ensure auto-save is enabled in config

## Best Practices

### For Server Admins

1. **Balance Placement**:
   - Set reasonable placement distance
   - Control minimum spacing
   - Limit placement frequency if needed

2. **Manage Permissions**:
   - Decide who can remove posters
   - Balance law vs criminal gameplay
   - Consider pickup vs destroy options

3. **Performance Tuning**:
   - Adjust load radius based on server size
   - Set appropriate sync interval
   - Monitor database size

4. **Roleplay Enhancement**:
   - Encourage poster placement RP
   - Create poster-related events
   - Reward creative poster use

### For Players

1. **Strategic Placement**:
   - Place in high-traffic areas
   - Consider visibility and safety
   - Think about your character's motivation

2. **Respect the System**:
   - Don't spam posters
   - Remove outdated information
   - Follow server rules for poster use

3. **Roleplay Appropriately**:
   - Stay in character when placing/removing
   - Consider your character's knowledge
   - Create interesting scenarios

## Support

For issues, questions, or suggestions:
- **Website**: [wolves.land](https://wolves.land)
- **Version**: 1.0.0
- **Author**: iBoss

---

© 2026 iBoss | wolves.land | All Rights Reserved

**Made with ❤️ for the RedM community**
