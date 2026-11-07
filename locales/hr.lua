--[[
    Pigeon Vehicle Access: Croatian (Hrvatski).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'hr'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.hr = {
    title = 'Pristup vozilima',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Nemaš dopuštenje voziti ovo vozilo ({vehicle}).',
    denied_who = 'Nemaš dopuštenje voziti ovo vozilo ({vehicle}). Namijenjeno je za: {who}.',
    denied_help = 'Nemaš dopuštenje voziti ovo vozilo.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} na dužnosti',
    who_gangs = '{gangs}',
    who_grade = '{name} (čin {grade}+)',
    who_ace = 'osoblje s dopuštenjem',
    who_whitelist = 'vozači na whitelisti',
    who_or = ' ili ',

    -- Admin command
    usage = 'Upotreba: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> je server ID igrača na mreži, citizen ID ili discord:<ID>.',
    no_permission = 'Nemaš dopuštenje za ovu naredbu.',
    unknown_model = '"{model}" nije u Config.Vehicles.',
    not_whitelist_model = 'Napomena: {model} nema whitelist = true, pa unosi na whitelisti nikome ne dopuštaju vožnju dok to ne dodaš.',
    bad_who = '"{who}" nije server ID, citizen ID ni discord:<ID>.',
    player_offline = 'Nijedan igrač sa server ID-jem {id} nije na mreži.',
    added = '{who} dodan na whitelistu za {model}.',
    already = '{who} je već na whitelisti za {model}.',
    removed = '{who} uklonjen s whitelisti za {model}.',
    not_found = '{who} nije na whitelisti za {model}.',
    list_header = 'Whitelista za {model} ({count}):',
    list_entry = '{who}{note} - dodao {by}, {date}',
    list_empty = 'Nitko nije na whitelisti za {model}.',
    check_result = 'Igrač {id} {result} voziti {model} ({reason}).',
    check_can = 'smije',
    check_cannot = 'ne smije',
    rules_header = 'Ograničena vozila ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Pratim {count} ograničenih vozila uz {framework}.',
    no_framework = 'Ne radi ni qbx_core ni qb-core, pa se pravila za poslove i bande ne mogu provjeriti. ACE i whitelist pravila i dalje rade.',
    config_problem = 'Problem u configu: {problem}',
    bypass_attempt = 'Igrač {id} ({name}) nastavio je voziti {model} nakon što je zaustavljen, pa je izbačen iz vozila.',
}
