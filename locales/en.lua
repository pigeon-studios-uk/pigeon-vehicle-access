--[[
    Pigeon Vehicle Access: English.

    To translate, copy this file to a new one named with the language's two-letter code (such as de.lua),
    change `Locales.en` to match (Locales.de), translate the text in quotes, and set Config.Locale.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.en = {
    title = 'Vehicle access',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'You aren\'t cleared to drive this {vehicle}.',
    denied_who = 'You aren\'t cleared to drive this {vehicle}. It\'s for {who}.',
    denied_help = 'You aren\'t cleared to drive this vehicle.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = 'on-duty {jobs}',
    who_gangs = '{gangs}',
    who_grade = '{name} (grade {grade}+)',
    who_ace = 'staff with permission',
    who_whitelist = 'whitelisted drivers',
    who_or = ', or ',

    -- Admin command
    usage = 'Usage: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> is an online server ID, a citizen ID, or discord:<ID>.',
    no_permission = 'You don\'t have permission to use this command.',
    unknown_model = '"{model}" isn\'t in Config.Vehicles.',
    not_whitelist_model = 'Note: {model} doesn\'t have whitelist = true, so whitelist entries won\'t let anyone drive it until you add that.',
    bad_who = '"{who}" isn\'t a server ID, citizen ID or discord:<ID>.',
    player_offline = 'No player is online with server ID {id}.',
    added = 'Added {who} to the {model} whitelist.',
    already = '{who} is already on the {model} whitelist.',
    removed = 'Removed {who} from the {model} whitelist.',
    not_found = '{who} isn\'t on the {model} whitelist.',
    list_header = '{model} whitelist ({count}):',
    list_entry = '{who}{note} - added {date} by {by}',
    list_empty = 'Nobody is on the {model} whitelist.',
    check_result = 'Player {id} {result} drive {model} ({reason}).',
    check_can = 'can',
    check_cannot = 'can\'t',
    rules_header = 'Restricted vehicles ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Watching {count} restricted vehicles with {framework}.',
    no_framework = 'Neither qbx_core nor qb-core is running, so job and gang rules can\'t be checked. ACE and whitelist rules still work.',
    config_problem = 'Config problem: {problem}',
    bypass_attempt = 'Player {id} ({name}) kept driving {model} after being stopped, so they were taken out of it.',
}
