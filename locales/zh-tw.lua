--[[
    Pigeon Vehicle Access: Traditional Chinese (繁體中文).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'zh-tw'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales['zh-tw'] = {
    title = '車輛權限',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = '你無權駕駛這輛 {vehicle}。',
    denied_who = '你無權駕駛這輛 {vehicle}。它僅供 {who} 使用。',
    denied_help = '你無權駕駛這輛車。',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '值勤中的 {jobs}',
    who_gangs = '{gangs}',
    who_grade = '{name}（{grade} 級以上）',
    who_ace = '有權限的管理人員',
    who_whitelist = '白名單內的駕駛',
    who_or = ' 或 ',

    -- Admin command
    usage = '用法: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> 是線上玩家的 server ID、citizen ID 或 discord:<ID>。',
    no_permission = '你沒有權限使用這個指令。',
    unknown_model = '"{model}" 不在 Config.Vehicles 中。',
    not_whitelist_model = '注意：{model} 沒有設定 whitelist = true，所以在你加上之前，白名單項目不會讓任何人駕駛它。',
    bad_who = '"{who}" 不是 server ID、citizen ID 或 discord:<ID>。',
    player_offline = '沒有 server ID 為 {id} 的線上玩家。',
    added = '已將 {who} 加入 {model} 的白名單。',
    already = '{who} 已經在 {model} 的白名單中。',
    removed = '已將 {who} 從 {model} 的白名單中移除。',
    not_found = '{who} 不在 {model} 的白名單中。',
    list_header = '{model} 白名單（{count}）：',
    list_entry = '{who}{note} - 由 {by} 於 {date} 新增',
    list_empty = '{model} 的白名單中沒有任何人。',
    check_result = '玩家 {id} {result}駕駛 {model}（{reason}）。',
    check_can = '可以',
    check_cannot = '不能',
    rules_header = '受限車輛（{count}）：',
    rules_entry = '{model}（{label}）：{who}',

    -- Console
    started = '正在透過 {framework} 監視 {count} 輛受限車輛。',
    no_framework = '沒有執行任何框架（qbx_core、qb-core 或 es_extended），所以無法檢查職業和幫派規則。ACE 和白名單規則仍然有效。',
    config_problem = '設定問題：{problem}',
    bypass_attempt = '玩家 {id}（{name}）被攔下後仍繼續駕駛 {model}，所以已被移出車輛。',
}
