--[[
    Pigeon Vehicle Access: Danish (Dansk).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'da'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.da = {
    title = 'Køretøjsadgang',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Du har ikke tilladelse til at køre denne {vehicle}.',
    denied_who = 'Du har ikke tilladelse til at køre denne {vehicle}. Den er til {who}.',
    denied_help = 'Du har ikke tilladelse til at køre dette køretøj.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} på vagt',
    who_gangs = '{gangs}',
    who_grade = '{name} (rang {grade}+)',
    who_ace = 'staff med tilladelse',
    who_whitelist = 'whitelistede chauffører',
    who_or = ' eller ',

    -- Admin command
    usage = 'Brug: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> er et online server-ID, et citizen-ID eller discord:<ID>.',
    no_permission = 'Du har ikke tilladelse til at bruge denne kommando.',
    unknown_model = '"{model}" er ikke i Config.Vehicles.',
    not_whitelist_model = 'Bemærk: {model} har ikke whitelist = true, så whitelist-poster lader ingen køre den, før du tilføjer det.',
    bad_who = '"{who}" er ikke et server-ID, citizen-ID eller discord:<ID>.',
    player_offline = 'Ingen spiller er online med server-ID {id}.',
    added = 'Tilføjede {who} til whitelisten for {model}.',
    already = '{who} er allerede på whitelisten for {model}.',
    removed = 'Fjernede {who} fra whitelisten for {model}.',
    not_found = '{who} er ikke på whitelisten for {model}.',
    list_header = 'Whitelist for {model} ({count}):',
    list_entry = '{who}{note} - tilføjet {date} af {by}',
    list_empty = 'Ingen er på whitelisten for {model}.',
    check_result = 'Spiller {id} {result} køre {model} ({reason}).',
    check_can = 'må',
    check_cannot = 'må ikke',
    rules_header = 'Begrænsede køretøjer ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Overvåger {count} begrænsede køretøjer med {framework}.',
    no_framework = 'Hverken qbx_core eller qb-core kører, så job- og bande-regler kan ikke tjekkes. ACE- og whitelist-regler virker stadig.',
    config_problem = 'Problem i config: {problem}',
    bypass_attempt = 'Spiller {id} ({name}) blev ved med at køre {model} efter at være stoppet, så de blev taget ud af den.',
}
