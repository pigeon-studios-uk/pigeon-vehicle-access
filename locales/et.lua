--[[
    Pigeon Vehicle Access: Estonian (Eesti).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'et'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.et = {
    title = 'Sõidukite ligipääs',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Sul pole luba seda sõidukit ({vehicle}) juhtida.',
    denied_who = 'Sul pole luba seda sõidukit ({vehicle}) juhtida. See on mõeldud: {who}.',
    denied_help = 'Sul pole luba seda sõidukit juhtida.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = 'tööl olevad {jobs}',
    who_gangs = '{gangs}',
    who_grade = '{name} (aste {grade}+)',
    who_ace = 'õigustega meeskond',
    who_whitelist = 'valges nimekirjas juhid',
    who_or = ' või ',

    -- Admin command
    usage = 'Kasutus: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> on võrgus oleva mängija server ID, citizen ID või discord:<ID>.',
    no_permission = 'Sul pole õigust seda käsku kasutada.',
    unknown_model = '"{model}" pole Config.Vehicles all.',
    not_whitelist_model = 'Märkus: mudelil {model} pole whitelist = true, seega valge nimekirja kirjed ei luba kellelgi seda juhtida, kuni sa selle lisad.',
    bad_who = '"{who}" pole server ID, citizen ID ega discord:<ID>.',
    player_offline = 'Server ID-ga {id} pole ükski mängija võrgus.',
    added = '{who} lisati mudeli {model} valgesse nimekirja.',
    already = '{who} on juba mudeli {model} valges nimekirjas.',
    removed = '{who} eemaldati mudeli {model} valgest nimekirjast.',
    not_found = '{who} pole mudeli {model} valges nimekirjas.',
    list_header = 'Mudeli {model} valge nimekiri ({count}):',
    list_entry = '{who}{note} - lisas {by}, {date}',
    list_empty = 'Mudeli {model} valges nimekirjas pole kedagi.',
    check_result = 'Mängija {id} {result} juhtida sõidukit {model} ({reason}).',
    check_can = 'võib',
    check_cannot = 'ei või',
    rules_header = 'Piiratud sõidukid ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Jälgin {count} piiratud sõidukit raamistikuga {framework}.',
    no_framework = 'Ei qbx_core ega qb-core tööta, seega töö- ja jõugureegleid ei saa kontrollida. ACE ja valge nimekirja reeglid töötavad edasi.',
    config_problem = 'Probleem configis: {problem}',
    bypass_attempt = 'Mängija {id} ({name}) jätkas sõidukiga {model} sõitmist pärast peatamist, seega võeti ta sõidukist välja.',
}
