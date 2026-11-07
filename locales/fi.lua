--[[
    Pigeon Vehicle Access: Finnish (Suomi).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'fi'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.fi = {
    title = 'Ajoneuvojen käyttöoikeus',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Sinulla ei ole lupaa ajaa tätä ajoneuvoa ({vehicle}).',
    denied_who = 'Sinulla ei ole lupaa ajaa tätä ajoneuvoa ({vehicle}). Se on tarkoitettu: {who}.',
    denied_help = 'Sinulla ei ole lupaa ajaa tätä ajoneuvoa.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = 'vuorossa olevat {jobs}',
    who_gangs = '{gangs}',
    who_grade = '{name} (arvo {grade}+)',
    who_ace = 'henkilökunta, jolla on oikeus',
    who_whitelist = 'sallittujen listalla olevat kuljettajat',
    who_or = ' tai ',

    -- Admin command
    usage = 'Käyttö: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> on paikalla olevan pelaajan palvelin-ID, citizen-ID tai discord:<ID>.',
    no_permission = 'Sinulla ei ole oikeutta käyttää tätä komentoa.',
    unknown_model = '"{model}" ei ole kohdassa Config.Vehicles.',
    not_whitelist_model = 'Huomio: mallilla {model} ei ole whitelist = true, joten sallittujen listan merkinnät eivät päästä ketään ajamaan sitä, ennen kuin lisäät sen.',
    bad_who = '"{who}" ei ole palvelin-ID, citizen-ID tai discord:<ID>.',
    player_offline = 'Palvelin-ID:llä {id} ei ole paikalla pelaajaa.',
    added = '{who} lisättiin mallin {model} sallittujen listalle.',
    already = '{who} on jo mallin {model} sallittujen listalla.',
    removed = '{who} poistettiin mallin {model} sallittujen listalta.',
    not_found = '{who} ei ole mallin {model} sallittujen listalla.',
    list_header = 'Mallin {model} sallittujen lista ({count}):',
    list_entry = '{who}{note} - lisännyt {by}, {date}',
    list_empty = 'Mallin {model} sallittujen listalla ei ole ketään.',
    check_result = 'Pelaaja {id} {result} ajaa mallia {model} ({reason}).',
    check_can = 'voi',
    check_cannot = 'ei voi',
    rules_header = 'Rajoitetut ajoneuvot ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Valvotaan {count} rajoitettua ajoneuvoa ({framework}).',
    no_framework = 'Kumpikaan qbx_core tai qb-core ei ole käynnissä, joten työ- ja jengisääntöjä ei voi tarkistaa. ACE- ja sallittujen listan säännöt toimivat edelleen.',
    config_problem = 'Ongelma configissa: {problem}',
    bypass_attempt = 'Pelaaja {id} ({name}) jatkoi ajoneuvolla {model} ajamista pysäyttämisen jälkeen, joten hänet poistettiin siitä.',
}
