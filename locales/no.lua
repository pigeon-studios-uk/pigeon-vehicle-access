--[[
    Pigeon Vehicle Access: Norwegian (Norsk).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'no'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.no = {
    title = 'Kjøretøytilgang',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Du har ikke tillatelse til å kjøre denne {vehicle}.',
    denied_who = 'Du har ikke tillatelse til å kjøre denne {vehicle}. Den er for {who}.',
    denied_help = 'Du har ikke tillatelse til å kjøre dette kjøretøyet.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} på vakt',
    who_gangs = '{gangs}',
    who_grade = '{name} (grad {grade}+)',
    who_ace = 'stab med tillatelse',
    who_whitelist = 'sjåfører på whitelisten',
    who_or = ' eller ',

    -- Admin command
    usage = 'Bruk: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> er en server-ID for en pålogget spiller, en citizen-ID eller discord:<ID>.',
    no_permission = 'Du har ikke tillatelse til å bruke denne kommandoen.',
    unknown_model = '"{model}" er ikke i Config.Vehicles.',
    not_whitelist_model = 'Merk: {model} har ikke whitelist = true, så whitelist-oppføringer lar ingen kjøre den før du legger det til.',
    bad_who = '"{who}" er ikke en server-ID, citizen-ID eller discord:<ID>.',
    player_offline = 'Ingen spiller er pålogget med server-ID {id}.',
    added = 'La til {who} på whitelisten for {model}.',
    already = '{who} er allerede på whitelisten for {model}.',
    removed = 'Fjernet {who} fra whitelisten for {model}.',
    not_found = '{who} er ikke på whitelisten for {model}.',
    list_header = 'Whitelist for {model} ({count}):',
    list_entry = '{who}{note} - lagt til {date} av {by}',
    list_empty = 'Ingen er på whitelisten for {model}.',
    check_result = 'Spiller {id} {result} kjøre {model} ({reason}).',
    check_can = 'kan',
    check_cannot = 'kan ikke',
    rules_header = 'Begrensede kjøretøy ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Overvåker {count} begrensede kjøretøy med {framework}.',
    no_framework = 'Verken qbx_core eller qb-core kjører, så regler for jobber og gjenger kan ikke sjekkes. ACE- og whitelist-regler virker fortsatt.',
    config_problem = 'Problem i config: {problem}',
    bypass_attempt = 'Spiller {id} ({name}) fortsatte å kjøre {model} etter å ha blitt stoppet, så de ble tatt ut av den.',
}
