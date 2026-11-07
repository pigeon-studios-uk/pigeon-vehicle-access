--[[
    Pigeon Vehicle Access: Swedish (Svenska).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'sv'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.sv = {
    title = 'Fordonsåtkomst',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Du har inte behörighet att köra den här {vehicle}.',
    denied_who = 'Du har inte behörighet att köra den här {vehicle}. Den är för {who}.',
    denied_help = 'Du har inte behörighet att köra det här fordonet.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} i tjänst',
    who_gangs = '{gangs}',
    who_grade = '{name} (grad {grade}+)',
    who_ace = 'personal med behörighet',
    who_whitelist = 'förare på whitelisten',
    who_or = ' eller ',

    -- Admin command
    usage = 'Användning: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> är ett server-ID för en inloggad spelare, ett citizen-ID eller discord:<ID>.',
    no_permission = 'Du har inte behörighet att använda det här kommandot.',
    unknown_model = '"{model}" finns inte i Config.Vehicles.',
    not_whitelist_model = 'Obs: {model} har inte whitelist = true, så whitelist-poster låter ingen köra den förrän du lägger till det.',
    bad_who = '"{who}" är inte ett server-ID, citizen-ID eller discord:<ID>.',
    player_offline = 'Ingen spelare är inloggad med server-ID {id}.',
    added = 'Lade till {who} på whitelisten för {model}.',
    already = '{who} finns redan på whitelisten för {model}.',
    removed = 'Tog bort {who} från whitelisten för {model}.',
    not_found = '{who} finns inte på whitelisten för {model}.',
    list_header = 'Whitelist för {model} ({count}):',
    list_entry = '{who}{note} - tillagd {date} av {by}',
    list_empty = 'Ingen finns på whitelisten för {model}.',
    check_result = 'Spelare {id} {result} köra {model} ({reason}).',
    check_can = 'får',
    check_cannot = 'får inte',
    rules_header = 'Begränsade fordon ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Bevakar {count} begränsade fordon med {framework}.',
    no_framework = 'Inget ramverk körs (qbx_core, qb-core eller es_extended), så regler för jobb och gäng kan inte kontrolleras. ACE- och whitelist-regler fungerar fortfarande.',
    config_problem = 'Problem i config: {problem}',
    bypass_attempt = 'Spelare {id} ({name}) fortsatte köra {model} efter att ha stoppats, så de togs ut ur den.',
}
