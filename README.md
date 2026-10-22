<div align="center">
  <h1>Pigeon Vehicle Access</h1>

  <p><strong>Decide who can drive which vehicles, by job, grade, gang, ACE permission or whitelist, for Qbox and QBCore.</strong></p>

  <p>
    <a href="https://github.com/pigeon-studios-uk/pigeon-vehicle-access/releases/latest"><img src="https://img.shields.io/github/v/release/pigeon-studios-uk/pigeon-vehicle-access?label=release&color=2ea043" alt="Latest release" /></a>
    <a href="LICENSE.md"><img src="https://img.shields.io/badge/licence-Pigeon%20Studios%20Free-6f42c1" alt="Licence: Pigeon Studios Free Licence" /></a>
    <a href="https://discord.gg/2NFVWEUmDF"><img src="https://img.shields.io/badge/support-Discord-5865F2?logo=discord&logoColor=white" alt="Discord support" /></a>
    <img src="https://img.shields.io/badge/FiveM-resource-F40552" alt="FiveM resource" />
  </p>

  <p>
    <a href="https://github.com/pigeon-studios-uk/pigeon-vehicle-access/releases/latest"><strong>Download</strong></a> ·
    <a href="#installation">Install</a> ·
    <a href="#setting-up-vehicles">Set up vehicles</a> ·
    <a href="CHANGELOG.md">Changelog</a> ·
    <a href="https://discord.gg/2NFVWEUmDF">Support</a>
  </p>
</div>

---

## Contents

- [Overview](#overview)
- [Features](#features)
- [What players see](#what-players-see)
- [Requirements](#requirements)
- [Installation](#installation)
- [Updating](#updating)
- [Setting up vehicles](#setting-up-vehicles)
- [Whitelists](#whitelists)
- [Commands](#commands)
- [Permissions](#permissions)
- [Configuration](#configuration)
- [How it works](#how-it-works)
- [Exports](#exports)
- [Database table](#database-table)
- [Localisation](#localisation)
- [Update checker](#update-checker)
- [Performance](#performance)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Support](#support)
- [Contributing](#contributing)
- [Licence](#licence)
- [Credits](#credits)

## Overview

Pigeon Vehicle Access is a free resource by [Pigeon Studios](https://pigeonstudios.co.uk) that controls who can drive your special vehicles: unmarked cars for senior officers, gang cars for gang members, donor or event cars for the people who earned them. Anyone else can get in, but the engine won't start, and they're told who the vehicle is for.

The server, not the player's game, checks who is driving what, so it can't be switched off with a cheat menu. Whitelists are managed in game with a command; there's nothing to edit in the database.

## Features

- **Rules per vehicle.** By job and lowest grade, on duty or not, by gang and grade, by ACE permission, or by whitelist, in any combination.
- **Server-side checks.** With OneSync, the server sees who is in the driver's seat itself. Players can't hide it.
- **Can't be driven away anyway.** If a cheat keeps the vehicle moving, the server takes the driver out of it.
- **Clear messages.** "You aren't cleared to drive this Unmarked Scout. It's for on-duty police, statep (grade 4+)."
- **Passengers are never affected.** Only the driver's seat is checked.
- **In-game whitelists.** `/vehicleaccess add c3coqheat 12` whitelists the player with server ID 12. By citizen ID or Discord ID too, with a note of who added them and why.
- **Changes apply straight away.** Promotions, going on duty and whitelist changes are picked up within a second.
- **Qbox and QBCore.** Including Qbox's multiple jobs.
- **Staff bypass.** One ACE lets admins drive anything.
- **Exports** for shops and other resources to check access or manage whitelists.
- **Tested.** Rules, server and client tests, and every database query tested against real MariaDB.

## What players see

When someone who isn't allowed gets in the driver's seat:

- a notification (ox_lib if it's running, otherwise chat): *You aren't cleared to drive this Unmarked Scout. It's for on-duty police, statep (grade 4+).*
- the engine stays off and the vehicle won't move;
- a reminder in the top-left corner while they stay in the seat.

Getting out, moving to a passenger seat, or being given access (a promotion, going on duty, a whitelist entry) ends it straight away.

## Requirements

| Requirement | Version | Notes |
|---|---|---|
| FXServer | A [recommended artifact](https://runtime.fivem.net/artifacts/) | |
| OneSync | On | The server needs it to see who is driving |
| [oxmysql](https://github.com/communityox/oxmysql) | 2.0 or newer | For whitelists |
| Qbox or QBCore | [qbx_core](https://github.com/Qbox-project/qbx_core) or [qb-core](https://github.com/qbcore-framework/qb-core) | For job and gang rules. ACE and whitelist rules work without either |
| [ox_lib](https://github.com/communityox/ox_lib) | Optional | Used for notifications if it's running |

## Installation

1. **Download** `pigeon-vehicle-access.zip` from the [latest release](https://github.com/pigeon-studios-uk/pigeon-vehicle-access/releases/latest).
2. **Extract** it into your `resources` folder. The folder must be called `pigeon-vehicle-access`.
3. **Set up your vehicles** in `configuration/config.lua` (see the next section).
4. **Start it** after oxmysql and your framework:

   ```cfg
   ensure oxmysql
   ensure qbx_core
   ensure pigeon-vehicle-access
   ```

5. **Give staff the command and the bypass:**

   ```cfg
   add_ace group.admin pigeon-vehicle-access.admin allow
   add_ace group.admin pigeon-vehicle-access.bypass allow
   ```

6. **Restart.** The console confirms what it's watching:

   ```text
   [pigeon-vehicle-access] Watching 4 restricted vehicles with Qbox.
   ```

The whitelist table is created automatically. There's no SQL to import.

## Updating

1. Read the [changelog](CHANGELOG.md), especially any **Upgrade notes**.
2. Back up `configuration/config.lua`.
3. Replace the folder with the new release, copy your vehicles into the new `config.lua`, and restart.

**Replacing Vehicle Lock (`vehicle-lock`):** Pigeon Vehicle Access is its successor. Remove `vehicle-lock`, install this, and move your vehicles into the new format below. Two things work differently:

- **A job rule now means only that job can drive it.** In Vehicle Lock, players *without* the job could drive a job-restricted vehicle; only lower-ranked members of the job were stopped. Check your rules still do what you want.
- **Whitelists are in a new table, `pigeon_vehicle_access`.** Copy entries over with `/vehicleaccess add <model> <citizenid>`, or with SQL from your old table:

  ```sql
  INSERT IGNORE INTO pigeon_vehicle_access (model, identifier, added_by)
  SELECT model, citizenid, 'vehicle-lock' FROM vehicle_whitelist WHERE citizenid IS NOT NULL AND citizenid <> '';
  INSERT IGNORE INTO pigeon_vehicle_access (model, identifier, added_by)
  SELECT model, CONCAT('discord:', discord), 'vehicle-lock' FROM vehicle_whitelist WHERE discord IS NOT NULL AND discord <> '';
  ```

  Start the new resource once first, so the table exists.

## Setting up vehicles

Add each vehicle to `Config.Vehicles` by its **spawn name**: the name used to spawn it, which is also its file name. It's not the name shown on screen.

```lua
Config.Vehicles = {
    -- Police and troopers, sergeant (grade 4) and above, while on duty.
    c3ucscout = {
        label = 'Unmarked Scout',
        jobs = { police = 4, statep = 4 },
        onDuty = true,
    },

    -- Any grade of EMS.
    ambulance = { jobs = { ambulance = 0 } },

    -- Ballas, grade 2 and above.
    buffalo4 = { gangs = { ballas = 2 } },

    -- Whitelisted people, or anyone with an ACE permission.
    t20 = { label = 'T20', ace = 'vehicle.t20', whitelist = true },
}
```

| Field | What it does |
|---|---|
| `label` | The name shown to players. Defaults to the spawn name |
| `jobs` | `{ jobname = lowest grade }`. Grade `0` allows every grade of that job |
| `onDuty` | `true` to also require them to be on duty in that job |
| `gangs` | `{ gangname = lowest grade }` |
| `ace` | An ACE permission that allows driving it |
| `whitelist` | `true` to allow anyone on this vehicle's [whitelist](#whitelists) |

Someone may drive the vehicle if they match **any** of these. Vehicles not in the list aren't restricted. If an entry has a mistake, the console says what's wrong and skips that vehicle; the rest still work.

**Qbox players with several jobs:** without `onDuty`, any of their jobs counts. With `onDuty`, it must be the job they're currently clocked into.

## Whitelists

Give `whitelist = true` to any vehicle, then manage who's on it in game or from the console:

```text
/vehicleaccess add c3coqheat 12 Raffle winner      (server ID 12, with a note)
/vehicleaccess add c3coqheat ABC12345              (a citizen ID, online or not)
/vehicleaccess add c3coqheat discord:123456789     (a Discord ID, for any of their characters)
/vehicleaccess remove c3coqheat ABC12345
/vehicleaccess list c3coqheat
```

Using a server ID whitelists that player's current character by citizen ID. Each entry remembers who added it and when.

## Commands

| Command | What it does |
|---|---|
| `/vehicleaccess add <model> <who> [note]` | Adds someone to a vehicle's whitelist |
| `/vehicleaccess remove <model> <who>` | Removes them |
| `/vehicleaccess list <model>` | Lists a vehicle's whitelist (up to 100 entries) |
| `/vehicleaccess check <server ID> <model>` | Says whether a player can drive a vehicle, and why |
| `/vehicleaccess rules` | Lists every restricted vehicle and who can drive it |

`<who>` is an online server ID, a citizen ID, or `discord:<ID>`. The server console can always use the command; players need the admin ACE.

## Permissions

| ACE | What it allows |
|---|---|
| `pigeon-vehicle-access.admin` | Using `/vehicleaccess` in game |
| `pigeon-vehicle-access.bypass` | Driving every restricted vehicle |
| Anything you set as a vehicle's `ace` | Driving that vehicle |

```cfg
add_ace group.admin pigeon-vehicle-access.admin allow
add_ace group.admin pigeon-vehicle-access.bypass allow
add_ace group.vip vehicle.t20 allow
```

## Configuration

| Setting | Default | What it does |
|---|---|---|
| `Config.Locale` | `'en'` | Language file from `locales/` |
| `Config.Vehicles` | examples | Restricted vehicles and who can drive them |
| `Config.BypassAce` | `'pigeon-vehicle-access.bypass'` | ACE that can drive everything |
| `Config.Command` | `'vehicleaccess'` | The admin command |
| `Config.AdminAce` | `'pigeon-vehicle-access.admin'` | ACE needed for the command in game |
| `Config.CheckInterval` | `1000` | Milliseconds between checks (lowest 250) |
| `Config.Notifications` | `'auto'` | `'auto'`, `'ox_lib'` or `'chat'` |
| `Config.ShowWhoCanDrive` | `true` | Say who the vehicle is for in the message |
| `Config.RemoveIfDriven` | `3` | Take a driver out after this many checks moving when they aren't allowed. `false` to turn off |
| `Config.LogBypassAttempts` | `true` | Log those removals in the server console |

## How it works

Every second, the server looks at every player: are they in a vehicle's driver's seat, and is it restricted? If they aren't allowed, it tells their game to keep the engine off and shows the message. The server checks again every second, so a promotion, going on duty, a whitelist change or getting out takes effect straight away.

If a stopped vehicle keeps moving for `Config.RemoveIfDriven` checks in a row (about three seconds), the player's game is ignoring the instruction, so the server takes them out of the vehicle with `TaskLeaveVehicle`. This works because the server, not the player, decides.

Whitelist answers are remembered per player and cleared whenever that vehicle's whitelist changes or the player changes character, so the database isn't asked every second.

## Exports

For other server-side resources:

```lua
-- Can this player drive this model? Unrestricted models always return true.
-- reason is 'job', 'gang', 'ace', 'whitelist', 'bypass', 'unrestricted' or 'denied'.
local allowed, reason = exports['pigeon-vehicle-access']:CanDrive(source, 'c3ucscout')

-- Whitelist someone (by citizen ID or 'discord:ID'), for example after buying a vehicle in a shop.
-- Returns true if added. The calling resource is recorded as who added it.
exports['pigeon-vehicle-access']:AddToWhitelist('c3coqheat', citizenid, 'Bought at the dealership')

-- Remove them. Returns true if they were on it.
exports['pigeon-vehicle-access']:RemoveFromWhitelist('c3coqheat', citizenid)
```

## Database table

One table, created on start:

| Column | What's in it |
|---|---|
| `model` | Vehicle spawn name |
| `identifier` | Citizen ID, or `discord:ID` |
| `note` | Optional note |
| `added_by` | Who added it: an admin's citizen ID, `console`, or the resource that called the export |
| `added_at` | When |

## Localisation

Set `Config.Locale` to a file in `locales/`. To add a language, copy `locales/en.lua`, rename it with the two-letter code (such as `de.lua`), change `Locales.en` to `Locales.de`, and translate the text in quotes. Keep anything in `{curly brackets}` as it is.

## Update checker

When it starts, Vehicle Access checks our public [version registry](https://github.com/pigeon-studios-uk/pigeon-versions) once and prints one line in the server console. It sends nothing about your server. Control it for every Pigeon Studios resource in `server.cfg`:

```cfg
set pigeon_update_check "on"      # default
set pigeon_update_check "quiet"   # only when there's an update or a problem
set pigeon_update_check "off"     # never check
```

## Performance

The server's check takes a few native calls per player each second, and does more only for players driving a restricted vehicle. The client does nothing at all unless its player is stopped in a restricted vehicle.

## Security

- **Server-authoritative.** The server decides who is driving and whether they're allowed. Players can't send anything that changes the result; the client only receives instructions.
- **Rules stay private.** The configuration is server-only, so players can't read who has access to what.
- **Bypass-resistant.** Drivers who ignore the instruction are taken out by the server.
- **Parameterised queries only**, tested against MariaDB, including with quotes in input.

Please report security problems privately: use the **Report a vulnerability** button in this repository's **Security** tab, or follow our [Security Policy](https://github.com/pigeon-studios-uk/.github/blob/main/SECURITY.md).

## Troubleshooting

**A vehicle isn't restricted.**
Check you used the spawn name, not the display name: add-on cars often show a different name on screen. Run `/vehicleaccess rules` to see what's loaded, and check the console for "Config problem" messages.

**Officers who should be allowed are stopped.**
Run `/vehicleaccess check <their ID> <model>`. If the rule has `onDuty = true`, they must be on duty. Grades are numbers: check your job's grade numbers in your framework's shared jobs file.

**"Neither qbx_core nor qb-core is running".**
Start your framework before `pigeon-vehicle-access`. Job and gang rules need it.

**Players are taken out of vehicles while parked.**
Only vehicles moving faster than about 7 km/h count. If it still happens, raise `Config.RemoveIfDriven` or set it to `false`.

**Nothing happens at all.**
OneSync must be on: it's what lets the server see who is driving.

## FAQ

**Can someone without access sit in the vehicle?**
Yes. Passengers are never affected, and a driver who isn't allowed can sit in it; it just won't start.

**Does this lock the doors or handle keys?**
No. It works alongside any vehicle keys resource; it only decides who may drive.

**Does it work with ESX?**
Not yet. ACE and whitelist rules work on any server; job and gang rules need Qbox or QBCore.

## Support

Read [Troubleshooting](#troubleshooting) first, then ask in the support channels of our [Discord](https://discord.gg/2NFVWEUmDF). See [Getting help](https://github.com/pigeon-studios-uk/.github/blob/main/SUPPORT.md).

## Contributing

Fixes and improvements are welcome. Please read the [contributing guide](https://github.com/pigeon-studios-uk/.github/blob/main/CONTRIBUTING.md) first.

```bash
lua tests/rules.test.lua
lua tests/resource.test.lua
```

See the top of `tests/sql.test.mjs` for running the SQL tests against a throwaway database.

## Licence

Pigeon Vehicle Access is free to use under the **[Pigeon Studios Free Licence](LICENSE.md)**.

- ✅ Use it on any number of servers, including monetised ones
- ✅ Change it for your own servers
- ❌ Don't reupload, share or mirror the files; link to this repository instead
- ❌ Don't sell it, bundle it in packs, or put it behind escrow
- ❌ Don't remove the credits

This summary isn't the licence; [LICENSE.md](LICENSE.md) is. Third-party notices are in [NOTICE.md](NOTICE.md).

## Credits

Made by [Pigeon Studios](https://pigeonstudios.co.uk).

<sub>Not affiliated with or endorsed by Rockstar Games, Take-Two Interactive, Cfx.re, the Qbox Project or QBCore.</sub>
