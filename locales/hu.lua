--[[
    Pigeon Vehicle Access: Hungarian (Magyar).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'hu'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.hu = {
    title = 'Járműhozzáférés',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Nem vezetheted ezt a járművet ({vehicle}).',
    denied_who = 'Nem vezetheted ezt a járművet ({vehicle}). Ez nekik való: {who}.',
    denied_help = 'Nem vezetheted ezt a járművet.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = 'szolgálatban lévő {jobs}',
    who_gangs = '{gangs}',
    who_grade = '{name} ({grade}+ rang)',
    who_ace = 'jogosult stáb',
    who_whitelist = 'engedélyezett listán lévő sofőrök',
    who_or = ' vagy ',

    -- Admin command
    usage = 'Használat: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = 'A <who> egy online szerver ID, egy citizen ID vagy discord:<ID>.',
    no_permission = 'Nincs jogosultságod ehhez a parancshoz.',
    unknown_model = '"{model}" nincs a Config.Vehicles listában.',
    not_whitelist_model = 'Megjegyzés: a(z) {model} nem rendelkezik whitelist = true beállítással, így a listabejegyzések senkit sem engednek vezetni, amíg ezt hozzá nem adod.',
    bad_who = '"{who}" nem szerver ID, citizen ID vagy discord:<ID>.',
    player_offline = 'Nincs online játékos {id} szerver ID-val.',
    added = '{who} hozzáadva a(z) {model} engedélyezett listájához.',
    already = '{who} már rajta van a(z) {model} engedélyezett listáján.',
    removed = '{who} eltávolítva a(z) {model} engedélyezett listájáról.',
    not_found = '{who} nincs rajta a(z) {model} engedélyezett listáján.',
    list_header = 'A(z) {model} engedélyezett listája ({count}):',
    list_entry = '{who}{note} - hozzáadta {by}, {date}',
    list_empty = 'Senki sincs a(z) {model} engedélyezett listáján.',
    check_result = 'A(z) {id} játékos {result} vezetni ezt: {model} ({reason}).',
    check_can = 'tud',
    check_cannot = 'nem tud',
    rules_header = 'Korlátozott járművek ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = '{count} korlátozott jármű figyelése ezzel: {framework}.',
    no_framework = 'Nem fut framework (qbx_core, qb-core vagy es_extended), így a munka- és bandaszabályok nem ellenőrizhetők. Az ACE és az engedélyezett lista szabályai továbbra is működnek.',
    config_problem = 'Hiba a configban: {problem}',
    bypass_attempt = 'A(z) {id} játékos ({name}) a megállítás után is tovább vezette ezt: {model}, ezért kivették belőle.',
}
