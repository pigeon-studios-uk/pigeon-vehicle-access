--[[
    Pigeon Vehicle Access: Romanian (Română).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'ro'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.ro = {
    title = 'Acces la vehicule',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Nu ai voie să conduci acest {vehicle}.',
    denied_who = 'Nu ai voie să conduci acest {vehicle}. Este pentru {who}.',
    denied_help = 'Nu ai voie să conduci acest vehicul.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} în tură',
    who_gangs = '{gangs}',
    who_grade = '{name} (grad {grade}+)',
    who_ace = 'staff cu permisiune',
    who_whitelist = 'șoferi din whitelist',
    who_or = ' sau ',

    -- Admin command
    usage = 'Utilizare: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> este un server ID online, un citizen ID sau discord:<ID>.',
    no_permission = 'Nu ai permisiunea să folosești această comandă.',
    unknown_model = '"{model}" nu este în Config.Vehicles.',
    not_whitelist_model = 'Notă: {model} nu are whitelist = true, așa că intrările din whitelist nu vor lăsa pe nimeni să-l conducă până nu adaugi asta.',
    bad_who = '"{who}" nu este un server ID, citizen ID sau discord:<ID>.',
    player_offline = 'Niciun jucător nu este online cu server ID {id}.',
    added = '{who} a fost adăugat în whitelist-ul pentru {model}.',
    already = '{who} este deja în whitelist-ul pentru {model}.',
    removed = '{who} a fost scos din whitelist-ul pentru {model}.',
    not_found = '{who} nu este în whitelist-ul pentru {model}.',
    list_header = 'Whitelist pentru {model} ({count}):',
    list_entry = '{who}{note} - adăugat pe {date} de {by}',
    list_empty = 'Nimeni nu este în whitelist-ul pentru {model}.',
    check_result = 'Jucătorul {id} {result} conduce {model} ({reason}).',
    check_can = 'poate',
    check_cannot = 'nu poate',
    rules_header = 'Vehicule restricționate ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Se urmăresc {count} vehicule restricționate cu {framework}.',
    no_framework = 'Nu rulează niciun framework (qbx_core, qb-core sau es_extended), așa că regulile pentru joburi și bande nu pot fi verificate. Regulile ACE și whitelist funcționează în continuare.',
    config_problem = 'Problemă în config: {problem}',
    bypass_attempt = 'Jucătorul {id} ({name}) a continuat să conducă {model} după ce a fost oprit, așa că a fost scos din vehicul.',
}
