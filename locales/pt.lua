--[[
    Pigeon Vehicle Access: Portuguese (Português).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'pt'
    to use it, or leave it on 'auto' and set ox_lib's language.
    Keep words in {curly brackets} exactly as they are; they're filled in automatically.
]]

Locales = Locales or {}

Locales.pt = {
    title = 'Acesso a veículos',

    -- Shown to a driver who isn't allowed. {vehicle} is the vehicle's label, {who} says who can drive it.
    denied = 'Não tens autorização para conduzir este {vehicle}.',
    denied_who = 'Não tens autorização para conduzir este {vehicle}. É para {who}.',
    denied_help = 'Não tens autorização para conduzir este veículo.',

    -- How {who} is written.
    who_jobs = '{jobs}',
    who_jobs_on_duty = '{jobs} de serviço',
    who_gangs = '{gangs}',
    who_grade = '{name} (posto {grade}+)',
    who_ace = 'staff com permissão',
    who_whitelist = 'condutores na whitelist',
    who_or = ' ou ',

    -- Admin command
    usage = 'Utilização: /{command} add <model> <who> [note] | remove <model> <who> | list <model> | check <server ID> <model> | rules',
    who_help = '<who> é um ID de servidor online, um citizen ID ou discord:<ID>.',
    no_permission = 'Não tens permissão para usar este comando.',
    unknown_model = '"{model}" não está em Config.Vehicles.',
    not_whitelist_model = 'Nota: {model} não tem whitelist = true, por isso as entradas da whitelist não deixam ninguém conduzi-lo até adicionares isso.',
    bad_who = '"{who}" não é um ID de servidor, citizen ID nem discord:<ID>.',
    player_offline = 'Nenhum jogador online com o ID de servidor {id}.',
    added = '{who} adicionado à whitelist de {model}.',
    already = '{who} já está na whitelist de {model}.',
    removed = '{who} removido da whitelist de {model}.',
    not_found = '{who} não está na whitelist de {model}.',
    list_header = 'Whitelist de {model} ({count}):',
    list_entry = '{who}{note} - adicionado a {date} por {by}',
    list_empty = 'Ninguém está na whitelist de {model}.',
    check_result = 'O jogador {id} {result} conduzir {model} ({reason}).',
    check_can = 'pode',
    check_cannot = 'não pode',
    rules_header = 'Veículos restritos ({count}):',
    rules_entry = '{model} ({label}): {who}',

    -- Console
    started = 'A vigiar {count} veículos restritos com {framework}.',
    no_framework = 'Nem qbx_core nem qb-core estão a correr, por isso as regras de empregos e gangues não podem ser verificadas. As regras de ACE e whitelist continuam a funcionar.',
    config_problem = 'Problema na config: {problem}',
    bypass_attempt = 'O jogador {id} ({name}) continuou a conduzir {model} depois de ser parado, por isso foi tirado do veículo.',
}
