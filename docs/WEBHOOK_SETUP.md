# 📡 Webhook Setup Guide

**LXR Wanted Board - Discord Webhook Integration**

This guide will help you set up Discord webhooks to receive real-time notifications for wanted board events.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Creating Discord Webhooks](#creating-discord-webhooks)
3. [Configuration](#configuration)
4. [Event Types](#event-types)
5. [Customization](#customization)
6. [Testing](#testing)
7. [Troubleshooting](#troubleshooting)
8. [Advanced Setup](#advanced-setup)

---

## 🎯 Overview

The webhook system sends beautiful Discord embeds whenever important events occur in the wanted board system:

- 🎯 **Wanted Poster Created** - New criminal added to the board
- ✏️ **Wanted Poster Edited** - Poster information updated
- 🗑️ **Wanted Poster Removed** - Poster removed from board
- ⚔️ **Criminal Captured** - Bounty hunter captures wanted criminal
- 💵 **Reward Claimed** - Bounty reward paid out
- 📚 **Archive Accessed** - Someone searches the archive

### Features:
- ✅ Rich Discord embeds with color coding
- ✅ Automatic rate limiting to prevent spam
- ✅ Queue system for reliable delivery
- ✅ Configurable event filtering
- ✅ Retry logic for failed requests
- ✅ Custom avatars and branding

---

## 🔗 Creating Discord Webhooks

### Step 1: Create a Webhook Channel

1. In your Discord server, create or select a channel for notifications
   - Recommended: `#wanted-board-logs` or `#law-enforcement-logs`

### Step 2: Create the Webhook

1. Right-click the channel
2. Click "Edit Channel"
3. Go to "Integrations" tab
4. Click "Create Webhook" or "New Webhook"
5. Give it a name (e.g., "LXR Wanted Board")
6. (Optional) Upload a custom avatar image
7. Click "Copy Webhook URL"
8. Save this URL securely

### Example Webhook URL Format:
```
https://discord.com/api/webhooks/1234567890123456789/abcdefghijklmnopqrstuvwxyz123456789
```

---

## ⚙️ Configuration

### Step 1: Edit `config.lua`

Open `config.lua` and find the logging section:

```lua
Config.Logging = {
    enabled = true, -- Enable logging system
    logCreation = true, -- Log wanted poster creation
    logEdits = true, -- Log wanted poster edits
    logRemoval = true, -- Log wanted poster removal
    logCaptures = true, -- Log captures
    logRewards = true, -- Log reward claims
    logArchive = true, -- Log archive access
    
    -- Webhook for Discord logging
    webhook = {
        enabled = true, -- Enable webhook notifications
        url = 'YOUR_WEBHOOK_URL_HERE', -- Paste your webhook URL here
        color = 15158332, -- Default red color (decimal format)
        footer = 'LXR Wanted Board | wolves.land',
        title = '🎯 Wanted Board Event'
    }
}
```

### Step 2: Configure Your Webhook

Replace `'YOUR_WEBHOOK_URL_HERE'` with your actual webhook URL:

```lua
webhook = {
    enabled = true,
    url = 'https://discord.com/api/webhooks/1234567890/abcdefghijk...',
    color = 15158332,
    footer = 'LXR Wanted Board | wolves.land',
    title = '🎯 Wanted Board Event'
}
```

### Step 3: Enable Specific Event Types

Choose which events to log:

```lua
logCreation = true,  -- ✅ Log new wanted posters
logEdits = true,     -- ✅ Log poster edits
logRemoval = true,   -- ✅ Log poster removals
logCaptures = true,  -- ✅ Log bounty captures
logRewards = true,   -- ✅ Log reward claims
logArchive = false,  -- ❌ Don't log archive access (can be spammy)
```

### Step 4: Save and Restart

1. Save `config.lua`
2. Restart the resource:
   ```
   restart lxr-wantedboard
   ```

---

## 📊 Event Types

### 🎯 Poster Created

**Trigger:** Law enforcement creates a new wanted poster

**Embed Color:** Red (#E74C3C / 15158332)

**Information Included:**
- Target Name
- Citizen ID
- Reward Amount
- Danger Level
- Issuer Name
- Crimes List
- Alias (if provided)

**Example Notification:**
```
🎯 New Wanted Poster Created

A new criminal has been added to the wanted board

👤 Target: John "Black Jack" Morgan
🆔 Citizen ID: ABC12345
💰 Reward: $500
⚠️ Danger Level: EXTREME
👮 Issued By: Sheriff Williams
📜 Crimes: Murder, Armed Robbery, Horse Theft
```

---

### ✏️ Poster Edited

**Trigger:** Law enforcement updates an existing poster

**Embed Color:** Yellow (#F1C40F / 15844367)

**Information Included:**
- Target Name
- Citizen ID
- New Reward Amount
- Editor Name

---

### 🗑️ Poster Removed

**Trigger:** Law enforcement removes a poster

**Embed Color:** Gray (#95A5A6 / 9807270)

**Information Included:**
- Target Name
- Citizen ID
- Remover Name
- Reason (if provided)

---

### ⚔️ Criminal Captured

**Trigger:** Bounty hunter captures a wanted criminal

**Embed Color:** Blue (#3498DB / 3447003)

**Information Included:**
- Criminal Name
- Bounty Hunter Name
- Reward Amount
- Capture Location

**Example Notification:**
```
⚔️ Criminal Captured

A wanted criminal has been captured by a bounty hunter

🎯 Criminal: John "Black Jack" Morgan
👤 Bounty Hunter: Wild Bill Carter
💰 Reward: $500
📍 Location: Valentine
```

---

### 💵 Reward Claimed

**Trigger:** Bounty hunter claims their reward

**Embed Color:** Green (#2ECC71 / 3066993)

**Information Included:**
- Bounty Hunter Name
- Total Reward
- Bounty Name
- Hunter's Cut
- State's Cut

---

### 📚 Archive Accessed

**Trigger:** Someone searches the US National Archive

**Embed Color:** Purple (#9B59B6 / 10181046)

**Information Included:**
- Accessor Name
- Search Query

⚠️ **Note:** This can be spammy if many players search the archive. Consider disabling:
```lua
logArchive = false,
```

---

## 🎨 Customization

### Change Webhook Colors

Colors are in decimal format. Here are some common colors:

```lua
-- Red (Danger)
color = 15158332

-- Green (Success)
color = 3066993

-- Blue (Info)
color = 3447003

-- Yellow (Warning)
color = 16776960

-- Purple
color = 10181046

-- Orange
color = 16098851
```

To convert hex to decimal: `0xHEXCODE` or use an online converter.

### Custom Footer Text

```lua
footer = 'Your Server Name | your-website.com',
```

### Custom Title

```lua
title = '⚡ Law Enforcement Alert',
```

### Custom Avatar (Optional)

Edit `modules/webhooks/server.lua` to add a custom avatar:

```lua
QueueWebhook(webhookUrl, {
    username = 'LXR Wanted Board',
    avatar_url = 'https://your-domain.com/avatar.png', -- Add your image URL
    embeds = { embed }
})
```

---

## 🧪 Testing

### Method 1: Create a Test Poster

1. Join your server
2. Go to a wanted board
3. Create a wanted poster
4. Check your Discord channel for the notification

### Method 2: Use Debug Mode

Enable debug mode to see webhook activity in console:

```lua
Config.Debug = true
```

Console output will show:
```
[LXR Webhook] Webhook module loaded successfully
[LXR Webhook] Adding webhook to queue...
[LXR Webhook] Processing webhook queue...
```

### Method 3: Test Webhook URL

Use a tool like [Discord Webhook Tester](https://discohook.org/) to verify your webhook URL works.

---

## 🔧 Troubleshooting

### Issue: No notifications appearing

**Checklist:**
1. ✅ Webhook enabled in config: `webhook.enabled = true`
2. ✅ Logging enabled: `Config.Logging.enabled = true`
3. ✅ Specific event logging enabled: `logCreation = true`, etc.
4. ✅ Webhook URL is correct and complete
5. ✅ Channel still exists in Discord
6. ✅ Webhook hasn't been deleted

### Issue: "Failed to send webhook: 404"

**Cause:** Webhook URL is invalid or webhook was deleted

**Solution:**
1. Verify webhook still exists in Discord channel settings
2. Create a new webhook if necessary
3. Update config with new webhook URL

### Issue: "Failed to send webhook: 401"

**Cause:** Webhook URL is incomplete or corrupted

**Solution:**
1. Double-check you copied the entire webhook URL
2. Make sure there are no extra spaces or characters
3. Re-copy the webhook URL from Discord

### Issue: Webhooks being rate limited

**Symptom:** Some notifications not appearing

**Solution:** Increase rate limit delay in `modules/webhooks/server.lua`:

```lua
local rateLimitDelay = 2000 -- Increase from 1000 to 2000ms
```

### Issue: Duplicate notifications

**Cause:** Resource restarted while webhooks in queue

**Solution:** This is normal and will resolve itself. Queue is cleared on restart.

---

## 🚀 Advanced Setup

### Multiple Webhooks for Different Events

You can create multiple webhook channels and modify the code to send different events to different webhooks:

#### Example: Separate Channels

1. Create channels:
   - `#poster-alerts` - For poster creation/editing/removal
   - `#capture-logs` - For captures and rewards

2. Create webhooks for each channel

3. Modify config:

```lua
webhook = {
    enabled = true,
    urls = {
        posters = 'https://discord.com/api/webhooks/...', -- Poster events
        captures = 'https://discord.com/api/webhooks/...' -- Capture events
    },
    ...
}
```

4. Update `modules/webhooks/server.lua` to route events appropriately

### Webhook Security

For added security, consider:

1. **IP Whitelisting**: Configure Discord webhook to only accept requests from your server IP
2. **Rotating Webhooks**: Periodically delete and recreate webhooks
3. **Separate Webhooks**: Use different webhooks for different event types
4. **Private Channels**: Keep webhook channels private to staff only

### Database Logging

Enable database logging for webhook events:

Run the optional table from `installation/installation_discord.sql`:

```sql
CREATE TABLE IF NOT EXISTS `lxr_webhook_config` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `webhook_name` VARCHAR(100) NOT NULL UNIQUE,
    `webhook_url` TEXT NOT NULL,
    `enabled` TINYINT(1) DEFAULT 1,
    `event_types` TEXT NOT NULL,
    ...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 📊 Performance Notes

The webhook system is optimized for **0.00ms server overhead**:

- ✅ Queue system prevents server blocking
- ✅ Rate limiting prevents Discord API throttling  
- ✅ Async HTTP requests don't impact game performance
- ✅ Failed webhooks retry automatically
- ✅ No impact on database performance

### Webhook Queue

- Webhooks are queued and processed sequentially
- Default 1000ms delay between webhooks (1 per second)
- Queue processes in background thread
- No impact on player experience

---

## 📞 Support

For webhook integration help:

- 🌐 Website: [wolves.land](https://wolves.land)
- 💬 Discord: Join our community server
- 📚 Documentation: Check other guides in the repository

---

## 🎨 Webhook Examples

### Example 1: Minimal Setup

```lua
webhook = {
    enabled = true,
    url = 'https://discord.com/api/webhooks/YOUR_WEBHOOK',
    color = 15158332,
    footer = 'Wanted Board',
    title = '📋 Event'
}
```

### Example 2: Full Branding

```lua
webhook = {
    enabled = true,
    url = 'https://discord.com/api/webhooks/YOUR_WEBHOOK',
    color = 15158332,
    footer = 'RedM Wild West RP | play.yourserver.com',
    title = '⭐ Law Enforcement System - Wanted Board'
}
```

### Example 3: Captures Only

```lua
Config.Logging = {
    enabled = true,
    logCreation = false,  -- Disable poster logs
    logEdits = false,
    logRemoval = false,
    logCaptures = true,   -- Enable capture logs
    logRewards = true,
    logArchive = false,
    
    webhook = {
        enabled = true,
        url = 'YOUR_WEBHOOK_URL',
        ...
    }
}
```

---

**© 2026 iBoss | wolves.land | All Rights Reserved**
