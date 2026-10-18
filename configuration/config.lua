--[[
    Pigeon Vehicle Access: settings.

    This file only runs on the server, so players can't read your rules.
]]

Config = {}

-- Language file from locales/ to use, such as 'en'.
Config.Locale = 'en'

---------------------------------------------------------------------------
-- Restricted vehicles
--
-- Each entry is a vehicle's spawn name (the name you'd use to spawn it, not the name on screen) and who may
-- drive it. Anyone who matches at least one of these may drive; everyone else can't start it.
--
--   label     = name shown to players, such as 'Unmarked Scout' (optional)
--   jobs      = { jobname = lowest grade }. Grade 0 means every grade of that job.
--   onDuty    = true to also require them to be on duty in that job
--   gangs     = { gangname = lowest grade }
--   ace       = an ACE permission that allows it, such as 'vehicle.heat'
--   whitelist = true to allow anyone on this vehicle's whitelist (managed with /vehicleaccess add)
--
-- Vehicles not listed here aren't restricted at all. Passengers are never restricted.

Config.Vehicles = {
    -- Police and state troopers, sergeant (grade 4) and above, on duty.
    c3ucscout = {
        label = 'Unmarked Scout',
        jobs = { police = 4, statep = 4 },
        onDuty = true,
    },

    -- Only people on the whitelist.
    c3coqheat = { label = 'Heat', whitelist = true },
    c3kgwb = { whitelist = true },
    c3agcoupe = { whitelist = true },

    -- More examples:
    -- police3 = { label = 'Police Interceptor', jobs = { police = 0 }, onDuty = true },
    -- ambulance = { jobs = { ambulance = 0 } },
    -- buffalo4 = { gangs = { ballas = 2 } },
    -- t20 = { ace = 'vehicle.t20', whitelist = true },
}

---------------------------------------------------------------------------
-- Staff

-- Players with this ACE can drive every restricted vehicle.
--     add_ace group.admin pigeon-vehicle-access.bypass allow
Config.BypassAce = 'pigeon-vehicle-access.bypass'

-- Command for managing whitelists: /vehicleaccess add | remove | list | check | rules
Config.Command = 'vehicleaccess'

-- Players need this ACE to use the command in game. The server console can always use it.
--     add_ace group.admin pigeon-vehicle-access.admin allow
Config.AdminAce = 'pigeon-vehicle-access.admin'

---------------------------------------------------------------------------
-- Checking and enforcing

-- How often the server checks who is driving what, in milliseconds. 1000 is a good balance.
Config.CheckInterval = 1000

-- How the player is told: 'auto' (ox_lib notifications if ox_lib is running, otherwise chat), 'ox_lib' or 'chat'.
Config.Notifications = 'auto'

-- Say who can drive the vehicle in the message, such as "It's for on-duty police (grade 4+)".
Config.ShowWhoCanDrive = true

-- If a player who isn't allowed manages to drive a restricted vehicle anyway (for example with a cheat),
-- take them out of it after this many checks in a row with it moving. false to turn off.
Config.RemoveIfDriven = 3

-- Print attempts to drive a restricted vehicle after being stopped in the server console.
Config.LogBypassAttempts = true
