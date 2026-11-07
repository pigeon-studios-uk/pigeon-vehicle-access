--[[
    Pigeon Vehicle Access: Slovenian (Slovenščina).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'sl'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.sl = {
    title = 'Dostop do vozil',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Nimaš dovoljenja za vožnjo tega vozila ({vehicle}).',
    denied_who = 'Nimaš dovoljenja za vožnjo tega vozila ({vehicle}). Namenjeno je za: {who}.',
    denied_help = 'Nimaš dovoljenja za vožnjo tega vozila.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} v službi',
    who_gangs = '{gangs}',
    who_grade = '{name} (čin {grade}+)',
    who_ace = 'osebje z dovoljenjem',
    who_whitelist = 'vozniki na whitelisti',
    who_or = ' ali ',

    -- Admin command
    usage = 'Uporaba: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> je server ID igralca na spletu, citizen ID ali discord:<ID>.',
    no_permission = 'Nimaš dovoljenja za uporabo tega ukaza.',
    unknown_model = '"{model}" ni v Config.Vehicles.',
    not_whitelist_model = 'Opomba: {model} nima whitelist = true, zato vnosi na whitelisti nikomur ne dovolijo vožnje, dokler tega ne dodaš.',
    bad_who = '"{who}" ni server ID, citizen ID ali discord:<ID>.',
    player_offline = 'Noben igralec s server ID {id} ni na spletu.',
    added = '{who} dodan na whitelisto za {model}.',
    already = '{who} je že na whitelisti za {model}.',
    removed = '{who} odstranjen z whitelisti za {model}.',
    not_found = '{who} ni na whitelisti za {model}.',
    list_header = 'Whitelista za {model} ({count}):',
    list_entry = '{who}{note} - dodal {by}, {date}',
    list_empty = 'Na whitelisti za {model} ni nikogar.',
    check_result = 'Igralec {id} {result} voziti {model} ({reason}).',
    check_can = 'lahko',
    check_cannot = 'ne sme',
    rules_header = 'Omejena vozila ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Spremljam {count} omejenih vozil z {framework}.',
    no_framework = 'Ne teče noben framework (qbx_core, qb-core ali es_extended), zato pravil za službe in tolpe ni mogoče preveriti. Pravila ACE in whitelist še vedno delujejo.',
    config_problem = 'Težava v configu: {problem}',
    bypass_attempt = 'Igralec {id} ({name}) je po ustavitvi še naprej vozil {model}, zato je bil odstranjen iz vozila.',
}
