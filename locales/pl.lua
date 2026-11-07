--[[
    Pigeon Vehicle Access: Polish (Polski).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'pl'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.pl = {
    title = 'Dostęp do pojazdów',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Nie masz uprawnień do prowadzenia tego pojazdu ({vehicle}).',
    denied_who = 'Nie masz uprawnień do prowadzenia tego pojazdu ({vehicle}). Jest przeznaczony dla: {who}.',
    denied_help = 'Nie masz uprawnień do prowadzenia tego pojazdu.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} na służbie',
    who_gangs = '{gangs}',
    who_grade = '{name} (stopień {grade}+)',
    who_ace = 'administracja z uprawnieniami',
    who_whitelist = 'kierowcy z whitelisty',
    who_or = ' lub ',

    -- Admin command
    usage = 'Użycie: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> to server ID gracza online, citizen ID lub discord:<ID>.',
    no_permission = 'Nie masz uprawnień do tej komendy.',
    unknown_model = '"{model}" nie ma w Config.Vehicles.',
    not_whitelist_model = 'Uwaga: {model} nie ma whitelist = true, więc wpisy na whiteliście nie pozwolą nikomu go prowadzić, dopóki tego nie dodasz.',
    bad_who = '"{who}" to nie jest server ID, citizen ID ani discord:<ID>.',
    player_offline = 'Żaden gracz z server ID {id} nie jest online.',
    added = 'Dodano {who} do whitelisty {model}.',
    already = '{who} jest już na whiteliście {model}.',
    removed = 'Usunięto {who} z whitelisty {model}.',
    not_found = '{who} nie ma na whiteliście {model}.',
    list_header = 'Whitelista {model} ({count}):',
    list_entry = '{who}{note} - dodane {date} przez {by}',
    list_empty = 'Nikogo nie ma na whiteliście {model}.',
    check_result = 'Gracz {id} {result} prowadzić {model} ({reason}).',
    check_can = 'może',
    check_cannot = 'nie może',
    rules_header = 'Pojazdy z ograniczeniami ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Pilnuję {count} pojazdów z ograniczeniami przez {framework}.',
    no_framework = 'Nie działa ani qbx_core, ani qb-core, więc zasad dla prac i gangów nie da się sprawdzić. Zasady ACE i whitelisty nadal działają.',
    config_problem = 'Problem w configu: {problem}',
    bypass_attempt = 'Gracz {id} ({name}) jechał dalej pojazdem {model} po zatrzymaniu, więc został z niego wyciągnięty.',
}
