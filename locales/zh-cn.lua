--[[
    Pigeon Vehicle Access: Simplified Chinese (简体中文).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'zh-cn'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales['zh-cn'] = {
    title = '车辆权限',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = '你无权驾驶这辆 {vehicle}。',
    denied_who = '你无权驾驶这辆 {vehicle}。它仅供 {who} 使用。',
    denied_help = '你无权驾驶这辆车。',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '值班中的 {jobs}',
    who_gangs = '{gangs}',
    who_grade = '{name}（{grade} 级以上）',
    who_ace = '有权限的管理人员',
    who_whitelist = '白名单内的驾驶员',
    who_or = ' 或 ',

    -- Admin command
    usage = '用法: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> 是在线玩家的 server ID、citizen ID 或 discord:<ID>。',
    no_permission = '你没有权限使用这个命令。',
    unknown_model = '"{model}" 不在 Config.Vehicles 中。',
    not_whitelist_model = '注意：{model} 没有设置 whitelist = true，所以在你加上之前，白名单条目不会让任何人驾驶它。',
    bad_who = '"{who}" 不是 server ID、citizen ID 或 discord:<ID>。',
    player_offline = '没有 server ID 为 {id} 的在线玩家。',
    added = '已将 {who} 加入 {model} 的白名单。',
    already = '{who} 已经在 {model} 的白名单中。',
    removed = '已将 {who} 从 {model} 的白名单中移除。',
    not_found = '{who} 不在 {model} 的白名单中。',
    list_header = '{model} 白名单（{count}）：',
    list_entry = '{who}{note} - 由 {by} 于 {date} 添加',
    list_empty = '{model} 的白名单中没有任何人。',
    check_result = '玩家 {id} {result}驾驶 {model}（{reason}）。',
    check_can = '可以',
    check_cannot = '不能',
    rules_header = '受限车辆（{count}）：',
    rules_entry = '{model}（{label}）：{who}',

    -- Console
    started = '正在通过 {framework} 监视 {count} 辆受限车辆。',
    no_framework = '没有运行任何框架（qbx_core、qb-core 或 es_extended），所以无法检查职业和帮派规则。ACE 和白名单规则仍然有效。',
    config_problem = '配置问题：{problem}',
    bypass_attempt = '玩家 {id}（{name}）被拦下后仍继续驾驶 {model}，所以已被移出车辆。',
}
