--[[
    Pigeon Vehicle Access: Indonesian (Bahasa Indonesia).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'id'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.id = {
    title = 'Akses kendaraan',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Kamu tidak diizinkan mengemudikan {vehicle} ini.',
    denied_who = 'Kamu tidak diizinkan mengemudikan {vehicle} ini. Kendaraan ini untuk {who}.',
    denied_help = 'Kamu tidak diizinkan mengemudikan kendaraan ini.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} yang sedang bertugas',
    who_gangs = '{gangs}',
    who_grade = '{name} (pangkat {grade}+)',
    who_ace = 'staf dengan izin',
    who_whitelist = 'pengemudi dalam whitelist',
    who_or = ' atau ',

    -- Admin command
    usage = 'Penggunaan: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> adalah server ID pemain yang online, citizen ID, atau discord:<ID>.',
    no_permission = 'Kamu tidak punya izin untuk memakai perintah ini.',
    unknown_model = '"{model}" tidak ada di Config.Vehicles.',
    not_whitelist_model = 'Catatan: {model} tidak punya whitelist = true, jadi entri whitelist tidak akan mengizinkan siapa pun mengemudikannya sampai kamu menambahkannya.',
    bad_who = '"{who}" bukan server ID, citizen ID, atau discord:<ID>.',
    player_offline = 'Tidak ada pemain online dengan server ID {id}.',
    added = '{who} ditambahkan ke whitelist {model}.',
    already = '{who} sudah ada di whitelist {model}.',
    removed = '{who} dihapus dari whitelist {model}.',
    not_found = '{who} tidak ada di whitelist {model}.',
    list_header = 'Whitelist {model} ({count}):',
    list_entry = '{who}{note} - ditambahkan {date} oleh {by}',
    list_empty = 'Tidak ada siapa pun di whitelist {model}.',
    check_result = 'Pemain {id} {result} mengemudikan {model} ({reason}).',
    check_can = 'boleh',
    check_cannot = 'tidak boleh',
    rules_header = 'Kendaraan terbatas ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Memantau {count} kendaraan terbatas dengan {framework}.',
    no_framework = 'qbx_core maupun qb-core tidak berjalan, jadi aturan pekerjaan dan geng tidak bisa diperiksa. Aturan ACE dan whitelist tetap berfungsi.',
    config_problem = 'Masalah config: {problem}',
    bypass_attempt = 'Pemain {id} ({name}) terus mengemudikan {model} setelah dihentikan, jadi mereka dikeluarkan dari kendaraan.',
}
