--[[
    Pigeon Vehicle Access: Italian (Italiano).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'it'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.it = {
    title = 'Accesso ai veicoli',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Non sei autorizzato a guidare questo {vehicle}.',
    denied_who = 'Non sei autorizzato a guidare questo {vehicle}. È riservato a: {who}.',
    denied_help = 'Non sei autorizzato a guidare questo veicolo.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} in servizio',
    who_gangs = '{gangs}',
    who_grade = '{name} (grado {grade}+)',
    who_ace = 'staff con permesso',
    who_whitelist = 'conducenti in whitelist',
    who_or = ' o ',

    -- Admin command
    usage = 'Uso: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> è un ID server online, un citizen ID o discord:<ID>.',
    no_permission = 'Non hai il permesso di usare questo comando.',
    unknown_model = '"{model}" non è in Config.Vehicles.',
    not_whitelist_model = 'Nota: {model} non ha whitelist = true, quindi le voci della whitelist non permetteranno a nessuno di guidarlo finché non lo aggiungi.',
    bad_who = '"{who}" non è un ID server, un citizen ID o discord:<ID>.',
    player_offline = 'Nessun giocatore online con ID server {id}.',
    added = '{who} aggiunto alla whitelist di {model}.',
    already = '{who} è già nella whitelist di {model}.',
    removed = '{who} rimosso dalla whitelist di {model}.',
    not_found = '{who} non è nella whitelist di {model}.',
    list_header = 'Whitelist di {model} ({count}):',
    list_entry = '{who}{note} - aggiunto il {date} da {by}',
    list_empty = 'Nessuno è nella whitelist di {model}.',
    check_result = 'Il giocatore {id} {result} guidare {model} ({reason}).',
    check_can = 'può',
    check_cannot = 'non può',
    rules_header = 'Veicoli riservati ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Controllo di {count} veicoli riservati con {framework}.',
    no_framework = 'Né qbx_core né qb-core sono attivi, quindi le regole su lavori e gang non possono essere controllate. Le regole ACE e whitelist funzionano ancora.',
    config_problem = 'Problema nella config: {problem}',
    bypass_attempt = 'Il giocatore {id} ({name}) ha continuato a guidare {model} dopo essere stato fermato, quindi è stato fatto scendere.',
}
