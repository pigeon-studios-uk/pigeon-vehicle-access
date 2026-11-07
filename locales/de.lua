--[[
    Pigeon Vehicle Access: German (Deutsch).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'de'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.de = {
    title = 'Fahrzeugzugang',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Du darfst dieses Fahrzeug ({vehicle}) nicht fahren.',
    denied_who = 'Du darfst dieses Fahrzeug ({vehicle}) nicht fahren. Es ist für {who}.',
    denied_help = 'Du darfst dieses Fahrzeug nicht fahren.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} im Dienst',
    who_gangs = '{gangs}',
    who_grade = '{name} (Rang {grade}+)',
    who_ace = 'Teammitglieder mit Berechtigung',
    who_whitelist = 'Fahrer auf der Whitelist',
    who_or = ' oder ',

    -- Admin command
    usage = 'Verwendung: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> ist eine Online-Server-ID, eine Citizen-ID oder discord:<ID>.',
    no_permission = 'Du hast keine Berechtigung für diesen Befehl.',
    unknown_model = '"{model}" steht nicht in Config.Vehicles.',
    not_whitelist_model = 'Hinweis: {model} hat kein whitelist = true, daher lassen Whitelist-Einträge niemanden fahren, bis du das ergänzt.',
    bad_who = '"{who}" ist keine Server-ID, Citizen-ID oder discord:<ID>.',
    player_offline = 'Kein Spieler mit Server-ID {id} ist online.',
    added = '{who} zur Whitelist für {model} hinzugefügt.',
    already = '{who} steht schon auf der Whitelist für {model}.',
    removed = '{who} von der Whitelist für {model} entfernt.',
    not_found = '{who} steht nicht auf der Whitelist für {model}.',
    list_header = 'Whitelist für {model} ({count}):',
    list_entry = '{who}{note} - hinzugefügt am {date} von {by}',
    list_empty = 'Niemand steht auf der Whitelist für {model}.',
    check_result = 'Spieler {id} {result} {model} fahren ({reason}).',
    check_can = 'darf',
    check_cannot = 'darf nicht',
    rules_header = 'Eingeschränkte Fahrzeuge ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Überwache {count} eingeschränkte Fahrzeuge mit {framework}.',
    no_framework = 'Weder qbx_core noch qb-core läuft, daher können Job- und Gang-Regeln nicht geprüft werden. ACE- und Whitelist-Regeln funktionieren weiter.',
    config_problem = 'Problem in der Config: {problem}',
    bypass_attempt = 'Spieler {id} ({name}) ist mit {model} weitergefahren, nachdem er gestoppt wurde, und wurde deshalb herausgeholt.',
}
