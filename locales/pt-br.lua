--[[
    Pigeon Vehicle Access: Brazilian Portuguese (Português do Brasil).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'pt-br'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales['pt-br'] = {
    title = 'Acesso a veículos',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Você não tem autorização para dirigir este {vehicle}.',
    denied_who = 'Você não tem autorização para dirigir este {vehicle}. Ele é para {who}.',
    denied_help = 'Você não tem autorização para dirigir este veículo.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} em serviço',
    who_gangs = '{gangs}',
    who_grade = '{name} (cargo {grade}+)',
    who_ace = 'staff com permissão',
    who_whitelist = 'motoristas na whitelist',
    who_or = ' ou ',

    -- Admin command
    usage = 'Uso: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> é um ID de servidor online, um citizen ID ou discord:<ID>.',
    no_permission = 'Você não tem permissão para usar este comando.',
    unknown_model = '"{model}" não está em Config.Vehicles.',
    not_whitelist_model = 'Observação: {model} não tem whitelist = true, então as entradas da whitelist não vão deixar ninguém dirigi-lo até você adicionar isso.',
    bad_who = '"{who}" não é um ID de servidor, citizen ID nem discord:<ID>.',
    player_offline = 'Nenhum jogador online com o ID de servidor {id}.',
    added = '{who} adicionado à whitelist de {model}.',
    already = '{who} já está na whitelist de {model}.',
    removed = '{who} removido da whitelist de {model}.',
    not_found = '{who} não está na whitelist de {model}.',
    list_header = 'Whitelist de {model} ({count}):',
    list_entry = '{who}{note} - adicionado em {date} por {by}',
    list_empty = 'Ninguém está na whitelist de {model}.',
    check_result = 'O jogador {id} {result} dirigir {model} ({reason}).',
    check_can = 'pode',
    check_cannot = 'não pode',
    rules_header = 'Veículos restritos ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'Monitorando {count} veículos restritos com {framework}.',
    no_framework = 'Nem qbx_core nem qb-core estão rodando, então as regras de empregos e gangues não podem ser verificadas. As regras de ACE e whitelist continuam funcionando.',
    config_problem = 'Problema na config: {problem}',
    bypass_attempt = 'O jogador {id} ({name}) continuou dirigindo {model} depois de ser parado, então foi tirado do veículo.',
}
