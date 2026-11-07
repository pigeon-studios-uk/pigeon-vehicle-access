--[[
    Pigeon Vehicle Access: Dutch (Nederlands).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'nl'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.nl = {
    title = 'Voertuigtoegang',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Je mag deze {vehicle} niet besturen.',
    denied_who = 'Je mag deze {vehicle} niet besturen. Hij is voor {who}.',
    denied_help = 'Je mag dit voertuig niet besturen.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} in dienst',
    who_gangs = '{gangs}',
    who_grade = '{name} (rang {grade}+)',
    who_ace = 'staf met toestemming',
    who_whitelist = 'bestuurders op de whitelist',
    who_or = ' of ',

    -- Admin command
    usage = 'Gebruik: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> is een online server-ID, een citizen-ID of discord:<ID>.',
    no_permission = 'Je hebt geen toestemming om dit commando te gebruiken.',
    unknown_model = '"{model}" staat niet in Config.Vehicles.',
    not_whitelist_model = 'Let op: {model} heeft geen whitelist = true, dus whitelist-items laten niemand ermee rijden tot je dat toevoegt.',
    bad_who = '"{who}" is geen server-ID, citizen-ID of discord:<ID>.',
    player_offline = 'Er is geen speler online met server-ID {id}.',
    added = '{who} toegevoegd aan de whitelist van {model}.',
    already = '{who} staat al op de whitelist van {model}.',
    removed = '{who} verwijderd van de whitelist van {model}.',
    not_found = '{who} staat niet op de whitelist van {model}.',
    list_header = 'Whitelist van {model} ({count}):',
    list_entry = '{who}{note} - toegevoegd op {date} door {by}',
    list_empty = 'Niemand staat op de whitelist van {model}.',
    check_result = 'Speler {id} {result} {model} besturen ({reason}).',
    check_can = 'mag',
    check_cannot = 'mag niet',
    rules_header = 'Beperkte voertuigen ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = '{count} beperkte voertuigen worden gevolgd met {framework}.',
    no_framework = 'Er draait geen framework (qbx_core, qb-core of es_extended), dus regels voor banen en gangs kunnen niet worden gecontroleerd. ACE- en whitelistregels werken nog wel.',
    config_problem = 'Probleem in de config: {problem}',
    bypass_attempt = 'Speler {id} ({name}) bleef met {model} rijden nadat hij was gestopt, dus is hij eruit gehaald.',
}
