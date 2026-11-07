--[[
    Pigeon Vehicle Access: Czech (Čeština).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'cs'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.cs = {
    title = 'Přístup k vozidlům',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Nemáš povolení řídit tento {vehicle}.',
    denied_who = 'Nemáš povolení řídit tento {vehicle}. Je určen pro: {who}.',
    denied_help = 'Nemáš povolení řídit toto vozidlo.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} ve službě',
    who_gangs = '{gangs}',
    who_grade = '{name} (hodnost {grade}+)',
    who_ace = 'tým s oprávněním',
    who_whitelist = 'řidiči na whitelistu',
    who_or = ' nebo ',

    -- Admin command
    usage = 'Použití: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> je online server ID, citizen ID nebo discord:<ID>.',
    no_permission = 'Na tento příkaz nemáš oprávnění.',
    unknown_model = '"{model}" není v Config.Vehicles.',
    not_whitelist_model = 'Poznámka: {model} nemá whitelist = true, takže záznamy na whitelistu nikomu řízení nepovolí, dokud to nepřidáš.',
    bad_who = '"{who}" není server ID, citizen ID ani discord:<ID>.',
    player_offline = 'Se server ID {id} není online žádný hráč.',
    added = '{who} přidán na whitelist pro {model}.',
    already = '{who} už je na whitelistu pro {model}.',
    removed = '{who} odebrán z whitelistu pro {model}.',
    not_found = '{who} není na whitelistu pro {model}.',
    list_header = 'Whitelist pro {model} ({count}):',
    list_entry = '{who}{note} - přidal {by} dne {date}',
    list_empty = 'Na whitelistu pro {model} nikdo není.',
    check_result = 'Hráč {id} {result} řídit {model} ({reason}).',
    check_can = 'může',
    check_cannot = 'nemůže',
    rules_header = 'Omezená vozidla ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Hlídám {count} omezených vozidel s {framework}.',
    no_framework = 'Neběží žádný framework (qbx_core, qb-core nebo es_extended), takže pravidla pro práce a gangy nejde ověřit. Pravidla ACE a whitelistu fungují dál.',
    config_problem = 'Problém v konfiguraci: {problem}',
    bypass_attempt = 'Hráč {id} ({name}) jel dál s {model} i poté, co byl zastaven, takže byl z vozidla vyhozen.',
}
