--[[
    Pigeon Vehicle Access: Turkish (Türkçe).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'tr'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.tr = {
    title = 'Araç erişimi',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Bu {vehicle} aracını kullanma iznin yok.',
    denied_who = 'Bu {vehicle} aracını kullanma iznin yok. Bu araç şunlar için: {who}.',
    denied_help = 'Bu aracı kullanma iznin yok.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = 'görevdeki {jobs}',
    who_gangs = '{gangs}',
    who_grade = '{name} ({grade}+ rütbe)',
    who_ace = 'yetkili ekip',
    who_whitelist = 'beyaz listedeki sürücüler',
    who_or = ' veya ',

    -- Admin command
    usage = 'Kullanım: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> çevrimiçi bir server ID, bir citizen ID ya da discord:<ID> olur.',
    no_permission = 'Bu komutu kullanma iznin yok.',
    unknown_model = '"{model}" Config.Vehicles içinde yok.',
    not_whitelist_model = 'Not: {model} için whitelist = true yok, bu yüzden sen bunu ekleyene kadar beyaz liste kayıtları kimsenin onu kullanmasına izin vermez.',
    bad_who = '"{who}" bir server ID, citizen ID ya da discord:<ID> değil.',
    player_offline = 'Server ID {id} ile çevrimiçi oyuncu yok.',
    added = '{who}, {model} beyaz listesine eklendi.',
    already = '{who} zaten {model} beyaz listesinde.',
    removed = '{who}, {model} beyaz listesinden çıkarıldı.',
    not_found = '{who}, {model} beyaz listesinde değil.',
    list_header = '{model} beyaz listesi ({count}):',
    list_entry = '{who}{note} - {date} tarihinde {by} ekledi',
    list_empty = '{model} beyaz listesinde kimse yok.',
    check_result = 'Oyuncu {id}, {model} aracını {result} ({reason}).',
    check_can = 'kullanabilir',
    check_cannot = 'kullanamaz',
    rules_header = 'Kısıtlı araçlar ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = '{framework} ile {count} kısıtlı araç izleniyor.',
    no_framework = 'Çalışan bir framework yok (qbx_core, qb-core veya es_extended), bu yüzden meslek ve çete kuralları kontrol edilemiyor. ACE ve beyaz liste kuralları çalışmaya devam ediyor.',
    config_problem = 'Config sorunu: {problem}',
    bypass_attempt = 'Oyuncu {id} ({name}) durdurulduktan sonra {model} aracını kullanmaya devam etti, bu yüzden araçtan çıkarıldı.',
}
